//
//  refrigratorAdsOffViewController.swift
//  What's-in-my-refrigerator
//
//  Created by 23 09 on 2024/01/17.
//

import UIKit
import DropDown
import GoogleMobileAds

final class RefrigratorMapViewController: UIViewController, UISheetPresentationControllerDelegate {
    
    var buttonBackup: UIButton?
    var backgroundColorBackup: UIColor?

    private let refrigratorView = RefrigratorView()
    let componentDetailView = ComponentDetailView()
    private let coreDataManager = CoreDataManager.shared
    //var gesture: UIPanGestureRecognizer!
    var currentFridgeData: RefrigeratorData? {
        didSet {
            if let name = self.currentFridgeData?.refName {
                print("currentFridgeData:",name)
            } else {
                print("currentFridgeData:nil")
            }
        }
    }
    var currentComponentData: ComponentData?
    var buttons: [UIButton] = []
    var removeComponentsList: [ComponentData] = []
    var changedCell: [ComponentsTableViewCell] = []
    var sortType: String?
    
    var demoAdmobView: GADBannerView = { // admob 부분
        var view = GADBannerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
   
    // MARK: - 라이프사이클

    override func viewDidLoad() {
        super.viewDidLoad()
        let fridgeDatas = coreDataManager.getFridgeDataFromCoreData()
        currentFridgeData = fridgeDatas[0]
        
        setDropDownDatas()
        self.view = refrigratorView
        makeNavi()
        setTargets()
        setupTableView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        //제스쳐 다른뷰에도 인식가능하도록..
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        
        self.view.addGestureRecognizer(tapGesture)
        
        setupBannerView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        

        setDropDownDatas()
        if let refType = currentFridgeData?.refType {
            refrigratorView.test = refType
        }
        buttons.forEach { v in
            v.removeFromSuperview()
        }
        buttons = []
        //데이터 다시 가져오기
        if !refrigratorView.switchList.isOn {
            //리스트 스위치 온이면 재료뷰 셋팅안함
            setComponentOfFridge()
        } else {
            refrigratorView.removeSubviews()
            refrigratorView.setupListUI()
        }
        //화면 새로로드
        refrigratorView.tableView.reloadData()
        

        self.view.setNeedsLayout()
        self.view.setNeedsDisplay()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // MARK: - 사라질때 탭바 숨기는거 취소
        hidesBottomBarWhenPushed = false
    }
    
    
    // MARK: - 네비게이션

    func makeNavi() {

        let appearance = UINavigationBarAppearance()
        
        // 네비게이션 바 왼쪽에 버튼 추가
        // 왼쪽 및 오른쪽 아이템의 폰트 크기 설정

   
    
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: refrigratorView.button)
        if  IsPremium.isPremium == true {
            navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: refrigratorView.listButton),UIBarButtonItem(customView: refrigratorView.plusButton)]
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: refrigratorView.listButton)
        }

        
        // 배경 색상 설정
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.shadowColor = .white //라인 없애기보다 배경색이랑 맞춰주는게 쉬은듯..
        //appearance.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 10, weight: .bold)]
        appearance.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 5)]

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
    
    // MARK: - 냉장고 닉네임
    func setDropDownDatas() {
        let fridgeDatas = coreDataManager.getFridgeDataFromCoreData()
        let nickNames = fridgeDatas.map{$0.refName! }
        
        refrigratorView.dropDown.dataSource = nickNames
        //refrigratorView.button.setTitle(nickNames.first, for: .normal)
        refrigratorView.button.setTitle(currentFridgeData?.refName, for: .normal)

        //currentFridgeData = fridgeDatas[0]
        
        refrigratorView.dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let self = self else { return }
            refrigratorView.button.setTitle(item, for: .normal)
            // 선택된 아이템의 인덱스로  데이터를 가져오기
            currentFridgeData = fridgeDatas[index]
            if let refType = currentFridgeData?.refType {
                refrigratorView.test = refType
            }
            //기존 재료들 초기화
            buttons.forEach { v in
                v.removeFromSuperview()
            }
            buttons = []
            //데이터 다시 가져오기
            if !refrigratorView.switchList.isOn {
                setComponentOfFridge()
            } else {
                refrigratorView.removeSubviews()
                refrigratorView.setupListUI()
                refrigratorView.tableView.reloadData()
            }
            //삭제할 재료들 초기화(테이블뷰)
            removeComponentsList = []
            changedCell.forEach { cell in
                cell.contentView.backgroundColor = .clear
            }
            changedCell = []

            //화면 새로로드
            self.view.setNeedsLayout()
            self.view.setNeedsDisplay()

        }
            
    }
    
    func setComponentOfFridge() {
        let components = coreDataManager.getComponentsFromCoreData(currentFridgeData?.refID, nil)
        components.enumerated().forEach { (index, ComponentData) in
            let gesture = UIPanGestureRecognizer(target: self, action: #selector(draggingView))
            let button = refrigratorView.createLabel(gesture, ComponentData)
            button.tag = index
            buttons.append(button)
            // MARK: - 재료 버튼 타겟
            button.addTarget(self, action: #selector(componentButtonTapped), for: .touchUpInside)
            
           // print(index,ComponentData)
            if ComponentData.coordinates == "" {
                self.view.addSubview(button)
                button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
                button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
                button.heightAnchor.constraint(equalToConstant: 28).isActive = true
                
            } else {
                //여기 실제 좌표 써야함..
                guard let coordinates = CGPoint.fromString(ComponentData.coordinates!) else { return }
                self.view.addSubview(button)
                button.centerXAnchor.constraint(equalTo: self.view.leadingAnchor, constant: coordinates.x).isActive = true
                button.centerYAnchor.constraint(equalTo: self.view.topAnchor,constant: coordinates.y).isActive = true
                button.heightAnchor.constraint(equalToConstant: 28).isActive = true
            }
        }
    }

    
    


    func setTargets() {
        refrigratorView.button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        refrigratorView.switchList.addTarget(self, action: #selector(switchValueTapped(_:)), for: .valueChanged)
        refrigratorView.plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        refrigratorView.listButton.addTarget(self, action: #selector(listButtonTapped), for: .touchUpInside)
        refrigratorView.addListButton.addTarget(self, action: #selector(addListButtonTapped), for: .touchUpInside)
        refrigratorView.addListButton.addTarget(self, action: #selector(addListButtonTapped), for: .touchUpInside)
        refrigratorView.sortDeleteButton.addTarget(self, action: #selector(sortDeleteButtonTapped), for: .touchUpInside)
        refrigratorView.sortButton.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
        componentDetailView.deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }
    
    func setupTableView() {
        refrigratorView.tableView.dataSource = self
        refrigratorView.tableView.delegate = self
        // 셀의 등록과정⭐️⭐️⭐️ (스토리보드 사용시에는 스토리보드에서 자동등록)
        refrigratorView.tableView.register(ComponentsTableViewCell.self, forCellReuseIdentifier: "ComponentCell")
    }
    
    
    
    
    // MARK: - 버튼, 스위치 이벤트
    //재료 태그 드래그 할 시 이벤트
    @objc func draggingView(_ sender: UIPanGestureRecognizer) {
        let point = sender.location(in: view)
        var finalPoint = point
        let draggedView = sender.view!
        let safeAreaHeight = self.view.safeAreaLayoutGuide.layoutFrame.origin
      //  draggedView.center = point
        
        //제스쳐 상태 처리 코드
        switch sender.state {
        case .began:
            // 드래그 시작
            // 필요한 초기화 작업을 수행할 수 있습니다.
            componentDetailView.isHidden = true
            break
        case .changed:
            // 드래그 중
            if point.y > safeAreaHeight.y + 50 {
                draggedView.center = point
            }else {
                sender.isEnabled = false
                sender.isEnabled = true
                let components = coreDataManager.getComponentsFromCoreData(currentFridgeData?.refID, nil)
                finalPoint.y = safeAreaHeight.y + 49
                components[draggedView.tag].coordinates = finalPoint.toString()
                guard let refID = currentFridgeData?.refID else { return }
                guard let id = components[draggedView.tag].id else { return }
                guard let coordinates = components[draggedView.tag].coordinates else { return }
          //      DispatchQueue.global().async {
                    self.coreDataManager.updateCoordinatesOfComponents(refID: refID, id: id, coordinates: coordinates, completion: { })
         //       }
                buttons.forEach { v in
                    v.removeFromSuperview()
                }
                buttons = []
                setComponentOfFridge()
                componentDetailView.isHidden = true
                return
            }
            break
        case .ended:
            // 드래그 종료
            // 여기다가 현재 재료 위치 셋팅하는 코드 넣어야함
            let components = coreDataManager.getComponentsFromCoreData(currentFridgeData?.refID , nil)
            components[draggedView.tag].coordinates = finalPoint.toString()
            guard let refID = currentFridgeData?.refID else { return }
            guard let id = components[draggedView.tag].id else { return }
            guard let coordinates = components[draggedView.tag].coordinates else { return }
           // DispatchQueue.global().async {
                self.coreDataManager.updateCoordinatesOfComponents(refID: refID, id: id, coordinates: coordinates, completion: {
                    
                })
          //  }
            buttons.forEach { v in
                v.removeFromSuperview()
            }
            buttons = []
            setComponentOfFridge()
            componentDetailView.isHidden = true
            
            break
        default:
            break
        }
    }
    
    
    @objc func buttonTapped() {
        refrigratorView.dropDown.show()
    }
    
    @objc func switchValueTapped(_ sender: UISwitch) {
        print("스위치 토글")
        switch sender.isOn {
        case true:
            refrigratorView.isSwitchOn = true
            buttons.forEach { v in
                v.removeFromSuperview()
            }
            buttons = []
            
            self.view.setNeedsLayout()
            self.view.setNeedsDisplay()
            refrigratorView.tableView.reloadData()

        case false:
            refrigratorView.isSwitchOn = false
            buttons.forEach { v in
                v.removeFromSuperview()
            }
            buttons = []
            setComponentOfFridge() //스위치 꺼지면 재료뷰 셋팅해야함
            self.view.setNeedsLayout()
            self.view.setNeedsDisplay()
        }
   
    }
    // MARK: - 냉장고 추가 버튼

    @objc func plusButtonTapped(_ sender: UISwitch) {
        print("플러스 버튼 탭드")
        let nextVC = RefrigeratorAddViewController()
        nextVC.delegate = self //커스텀 델리게이트
        hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(nextVC, animated: true)
    }
    // MARK: - 냉장고 편집 버튼

    @objc func listButtonTapped(_ sender: UISwitch) {
        let nextVC = RefrigeratorEditViewController()
        
        nextVC.delegate = self //커스텀 델리게이트
        nextVC.currentFridgeData = self.currentFridgeData //현재 냉장고 데이터 전달
        nextVC.refrigeratorEditView.nickNameTextField.text = self.currentFridgeData?.refName
        hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(nextVC, animated: true)
    }
    // MARK: - 재료 추가 버튼

    @objc func addListButtonTapped() {
        let nextVC = AddComponentsViewController()
        nextVC.delegate = self //커스텀 델리게이트
        
        nextVC.currentFridgeData = self.currentFridgeData
        
        hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    // MARK: - 재료 클릭 이벤트
    @objc func componentButtonTapped(_ sender: UIButton) {
        buttonBackup = sender
        backgroundColorBackup = sender.backgroundColor
        sender.backgroundColor = UIColor.getCustomColor() //재료 버튼 색깔 초록색으로 표시
        let data = coreDataManager.getComponentsFromCoreData(currentFridgeData?.refID, nil)
        componentDetailView.removeFromSuperview()
        self.view.addSubview(componentDetailView)

        
        componentDetailView.registerDateLabel.text =         DateHelper().dateToStringFormat(date: data[sender.tag].registerDay)
        componentDetailView.expireDateLabel.text =         DateHelper().dateToStringFormat(date:  data[sender.tag].dueDay)
        componentDetailView.memoContentLabel.text = data[sender.tag].memo
        componentDetailView.deleteButton.tag = sender.tag
        componentDetailView.topAnchor.constraint(equalTo: sender.bottomAnchor, constant: -7).isActive = true //버튼이랑 태그사이 간격 붙이기
        componentDetailView.widthAnchor.constraint(equalToConstant: 160).isActive = true
        componentDetailView.leadingAnchor.constraint(equalTo: sender.leadingAnchor).isActive = true
        //componentDetailView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        componentDetailView.bottomAnchor.constraint(equalTo: componentDetailView.deleteButtonStackView.bottomAnchor,constant: 10).isActive = true
        componentDetailView.isHidden = false
        componentDetailView.setNeedsLayout()
        componentDetailView.setNeedsDisplay()
    }
    
    // MARK: - 터치이벤트

    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        // 특정 뷰에서 터치 이벤트가 발생했을 때의 처리
        componentDetailView.isHidden = true
        guard let button = buttonBackup else { return }
        button.backgroundColor = backgroundColorBackup
    }


    
    @objc func deleteButtonTapped(_ sender: UIButton) {
        let data = coreDataManager.getComponentsFromCoreData(currentFridgeData?.refID, nil)
            coreDataManager.deleteComponentsByID(id: data[sender.tag].id!, completion: { })
        componentDetailView.isHidden = true
     //   buttons[sender.tag].removeFromSuperview()
        buttons.forEach { v in
            v.removeFromSuperview()
        }
        buttons = []
        setComponentOfFridge()
        self.view.setNeedsLayout()
        self.view.setNeedsDisplay()
        
    }
    @objc func sortDeleteButtonTapped(_ sender: UIButton) {
        print("test")
        print("count:",removeComponentsList.count)
        for component in removeComponentsList {
            if let id = component.id {
                coreDataManager.deleteComponentsByID(id: id, completion: { })
            }
            //삭제할 재료들 초기화(테이블뷰)
            removeComponentsList = []
            changedCell.forEach { cell in
                cell.contentView.backgroundColor = .clear
            }
            changedCell = []
        }

        refrigratorView.tableView.reloadData()
        
    }
    
    @objc func sortButtonTapped(_ sender: UIButton) {
        print("솔팅 버튼 탭드")
        let nextVC = SortingPopUpViewController()
        nextVC.modalPresentationStyle = .pageSheet
//        nextVC.view.alpha = 0.50;
        if let sheetPresentationController = nextVC.sheetPresentationController {
            // MARK: - 모달 팝업 크기 조절 관련 코드.. 변수 등 메모해놓으면 도움 될 것 같다

          //  sheetPresentationController.detents = [.medium(), .large()]
            let multiplier = 0.3
            let fraction = UISheetPresentationController.Detent.custom { context in
                // height is the view.frame.height of the view controller which presents this bottom sheet
                nextVC.view.frame.height * multiplier
            }
            sheetPresentationController.detents = [fraction]
            sheetPresentationController.delegate = self
            
        }
        
        nextVC.sortingType = self.sortType
        nextVC.delegate = self
        present(nextVC, animated: true, completion: nil)
        
    }
    

}

// MARK: - 델리게이트

extension RefrigratorMapViewController: ComponentDelegate, UIGestureRecognizerDelegate {
    func addNewComponent(_ component: Component) {
        coreDataManager.addComponentsOnFridge(refID: component.refID, id: component.id, name: component.name, registerDay: component.registerDay, dueDay: component.dueDay, isFreezer: component.isFreezer, memo: component.memo, tagColor: component.tagColor, coordinates: component.coordinates, completion: {
            print("재료 추가 성공")
        })
    }
    
    func DeleteComponent(index: Int, _ component: Component) {
        print("do something")
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return !self.componentDetailView.bounds.contains(touch.location(in: self.componentDetailView))

    }
    
    
}

extension RefrigratorMapViewController: FridgeDelegate {
    func setCurruntFridge(_ fridgeData: RefrigeratorData) {
        self.currentFridgeData = fridgeData
    }

    
    
}
// MARK: - 테이블뷰 델리게이트

extension RefrigratorMapViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coreDataManager.getComponentsFromCoreData(currentFridgeData?.refID, nil).count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ComponentCell", for: indexPath) as! ComponentsTableViewCell
        if let sortType = self.sortType {
            print("self.sortType ::",self.sortType )
            if self.sortType == "dueDay" {
                let componentsData = coreDataManager.getComponentsFromCoreData(currentFridgeData?.refID, "dueDay")
                cell.componentsData = componentsData[indexPath.row]
            } else {
                let componentsData = coreDataManager.getComponentsFromCoreData(currentFridgeData?.refID, "name")
                cell.componentsData = componentsData[indexPath.row]
            }
            
        } else {
            let componentsData = coreDataManager.getComponentsFromCoreData(currentFridgeData?.refID, nil)
            cell.componentsData = componentsData[indexPath.row]
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let componentsData = coreDataManager.getComponentsFromCoreData(currentFridgeData?.refID, nil)
        //        let componentsData = coreDataManager.getComponentsFromCoreData(currentFridgeData?.refID, "dueDay")
        //        let componentsData = coreDataManager.getComponentsFromCoreData(currentFridgeData?.refID, "name")
        
        
        let cell = tableView.cellForRow(at: indexPath) as! ComponentsTableViewCell
        if cell.contentView.backgroundColor == UIColor(hexString: "E5FDF0") {
            cell.contentView.backgroundColor = .white
            //재료 삭제 취소
           // removeComponentsList = removeComponentsList.filter{ $0 != componentsData[indexPath.row] }
            removeComponentsList = removeComponentsList.filter{ $0 != cell.componentsData! }
        } else {
            // 검정색이 아니면 선택 시 검정색으로 변경
            cell.contentView.backgroundColor = UIColor(hexString: "E5FDF0")
            //삭제할 재료 추가
            removeComponentsList.append(cell.componentsData!)
            changedCell.append(cell)
            
        }
        print("셀렉되었습니다")
    }
    

    
    
}


extension RefrigratorMapViewController: ModalPopUpDelegate {
    
    func setupSortingType(sortType: String?) {
        
        print("11")
        self.sortType = sortType
        
  
        //정렬 버튼 이름 설정
        if let sortType = sortType {
            if sortType == "dueDay" {
                self.refrigratorView.sortButton.setTitle("소비기한 적게 남은 순", for: .normal)
            } else {
                self.refrigratorView.sortButton.setTitle("식재료 이름(ㄱ-ㅎ)", for: .normal)
            }
            
        } else {
            self.refrigratorView.sortButton.setTitle("최근 등록 순", for: .normal)
        }
    }
    
    func reloadTableView() {
        refrigratorView.tableView.reloadData()
        self.view.setNeedsLayout()
        self.view.setNeedsDisplay()
    }
    
    
}

extension RefrigratorMapViewController: GADBannerViewDelegate {
    
    private func setupBannerView() {
        //let adSize = GADAdSizeFromCGSize(CGSize(width: GADAdSizeBanner.size.width, height: 50))

        refrigratorView.bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        refrigratorView.bannerView.rootViewController = self
        refrigratorView.bannerView.load(GADRequest())
        refrigratorView.bannerView.delegate = self

    }
}




//extension RefrigratorMapViewController: UINavigationControllerDelegate {
//    
//    func delegateOfNavigation() {
//        navigationController?.delegate = self
//    }
//}
