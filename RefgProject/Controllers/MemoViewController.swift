//
//  MemoViewController.swift
//  RefgProject
//
//  Created by 23 09 on 2024/01/22.
//

import UIKit
import GoogleMobileAds

class MemoViewController: UIViewController {
    let memoView = MemoView()
    let memoDataManger = MemoDataManager.shared
    var selectedMemoData: MemoData?
    var isFiltering:Bool = false
     // filter(서치바를 통해 작성한 무언가)를 담는 리스트
     var filterredArr: [MemoData] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = memoView
        makeNavi()
        setTargets()
        setSearchBar()
        addGesture()
        setupTableView()
        setupBannerView()
       
    

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        memoView.tableView.reloadData()
 
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // MARK: - 사라질때 탭바 숨기는거 취소
        hidesBottomBarWhenPushed = false
    }
    
    func setTargets() {
        memoView.plusButton.addTarget(self, action: #selector(plusButtonTapped(_:)), for: .touchUpInside)
    }
    
    func setupTableView() {
        memoView.tableView.dataSource = self
        memoView.tableView.delegate = self
        // 셀의 등록과정⭐️⭐️⭐️ (스토리보드 사용시에는 스토리보드에서 자동등록)
        memoView.tableView.register(MemoTableViewCell.self, forCellReuseIdentifier: "MemoCell")
    }
    
    func addGesture() {
        // UITapGestureRecognizer를 추가하여 터치 이벤트 감지
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        // MARK: - "테이블뷰 didselect와 충돌날 시에는 아래 추가해줘야함"
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
    }
    
    

    
    func makeNavi() {
        let appearance = UINavigationBarAppearance()
        // 네비게이션 바 왼쪽에 버튼 추가
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: memoView.button)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: memoView.plusButton)

        
        // 배경 색상 설정
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.shadowColor = .white //라인 없애기보다 배경색이랑 맞춰주는게 쉬은듯..
        //appearance.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 10, weight: .bold)]
        appearance.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 20)]

        // 다른 속성 설정
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance

        
        //네비게이션 뒤로가기 버튼 커스텀~~ 설정안해주면 디폴트 Back으로 들어감
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
            backBarButtonItem.tintColor = .black  // 색상 변경
            self.navigationItem.backBarButtonItem = backBarButtonItem
        
    }
    // MARK: - 메모 추가 버튼

    @objc func plusButtonTapped(_ sender: UISwitch) {
        print("플러스 버튼 탭드")
        let nextVC = MemoDetailViewController()
        hidesBottomBarWhenPushed = true
   
        navigationController?.pushViewController(nextVC, animated: true)
    }

    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        // 터치 이벤트가 발생할 때 실행될 코드
        memoView.searchBar.resignFirstResponder()
    }
    
//    // 화면에 탭을 감지(UIResponder)하는 메서드
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesBegan(touches, with: event)
//        memoView.searchBar.resignFirstResponder()
//        
//    }
    
    
   

}


// MARK: - 탭바 델리게이트

extension MemoViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        // 선택된 뷰 컨트롤러에 따라 다른 동작 수행
        if viewController.tabBarItem.title == "공유" {
            // 첫 번째 탭이 선택되었을 때의 동작 수행
            print("첫 번째 탭이 선택되었습니다.")
            let memoController = viewController as! MemoEditViewController
            shareItems(shareText: memoController.memoEditView.memoTextField.text)

        }else if viewController.tabBarItem.title == "삭제" {
            print("두 번째 탭이 선택되었습니다.")
            if let id = self.selectedMemoData?.id{
                memoDataManger.deleteMemoByID(id: id , completion: {})
            }

            navigationController?.popViewController(animated: true)
        }
    }
    
    func shareItems (shareText: String?) {
        var shareItems = [String]()
        if let text = shareText {
            shareItems.append(text)
        }

        let activityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
}

extension MemoViewController: UISearchBarDelegate {
    func setSearchBar() {
        memoView.searchBar.delegate = self
    }
    // 서치바에서 검색을 시작할 때 호출
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {

    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = memoView.searchBar.text?.lowercased() else { return }
        self.filterredArr = memoDataManger.getMemoDataBySearching(memo: text)
        if  searchBar.text! == "" {
            isFiltering = false
        }else {
            isFiltering = true
        }
        print(self.filterredArr)
        memoView.tableView.reloadData()
        print("2")
    }
    
    // 서치바에서 검색버튼을 눌렀을 때 호출
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let text = memoView.searchBar.text?.lowercased() else { return }
        self.filterredArr = memoDataManger.getMemoDataBySearching(memo: text)
        memoView.tableView.reloadData()
        print("3")
    }
    
    // 서치바에서 취소 버튼을 눌렀을 때 호출
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        memoView.searchBar.text = ""
        memoView.searchBar.resignFirstResponder()
        self.isFiltering = false
        print("isFiltering:",self.isFiltering)
        memoView.tableView.reloadData()
        
        print("4")
    }
    
    // 서치바 검색이 끝났을 때 호출
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {

        print("isFiltering:",self.isFiltering)
        print("filterredArr:",self.filterredArr)
        if  searchBar.text! == "" {
            isFiltering = false
        }
        memoView.tableView.reloadData()
        memoView.searchBar.resignFirstResponder()
    }

    
    
    
}

extension MemoViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = MemoEditViewController()
        let nextVC2 = MemoEditViewController()
        if let cell = tableView.cellForRow(at: indexPath) as? MemoTableViewCell {
            nextVC.titleName = cell.memoData?.memo
            nextVC.memoData = cell.memoData
            nextVC2.memoData = cell.memoData
            self.selectedMemoData = cell.memoData
        }
        
        nextVC.title = "공유"
        nextVC2.title = "삭제"
        let tabBarController = UITabBarController()
        tabBarController.setViewControllers([nextVC, nextVC2], animated: false)
        tabBarController.modalPresentationStyle = .fullScreen
        tabBarController.tabBar.backgroundColor = .white
        // 탭 바 아이템 이미지 및 텍스트 속성 설정
        let items = tabBarController.tabBar.items ?? []
        let attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.0)
        ]
        tabBarController.tabBar.tintColor = UIColor(hexString: "3CB175") //탭바 선택했을 때의 색깔
        
        for (index, item) in items.enumerated() {
            switch index {
            case 0:
                item.image = UIImage(named: "share.png")?.resize(targetSize: CGSize(width: 24, height: 24))
            case 1:
                item.image = UIImage(named: "trashIcon.png")?.resize(targetSize: CGSize(width: 24, height: 24))
            default:
                break
            }
            item.setTitleTextAttributes(attributes, for: .normal)
        }
        hidesBottomBarWhenPushed = true
        tabBarController.delegate = self
        
  
        
  
        navigationController?.pushViewController(tabBarController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("isFilteringin count:",self.isFiltering)
        return self.isFiltering ? self.filterredArr.count : memoDataManger.getMemoDataFromCoreData().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("isFilteringin table:",self.isFiltering)
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemoCell", for: indexPath) as! MemoTableViewCell
        if self.isFiltering {
            cell.memoData = filterredArr[indexPath.row]
        }else {
            let memoData = memoDataManger.getMemoDataFromCoreData()
            cell.memoData = memoData[indexPath.row]
        }
        cell.selectionStyle = .none

        return cell
    }
    
    
    
    
}

extension MemoViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return true

    }
    
}


extension MemoViewController: GADBannerViewDelegate {
    
    private func setupBannerView() {
        //let adSize = GADAdSizeFromCGSize(CGSize(width: GADAdSizeBanner.size.width, height: 50))

        memoView.bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        memoView.bannerView.rootViewController = self
        memoView.bannerView.load(GADRequest())
        memoView.bannerView.delegate = self

    }
}



