//
//  SettingViewController.swift
//  RefgProject
//
//  Created by 23 09 on 2024/01/22.
//

import UIKit
import GoogleMobileAds

class SettingViewController: UIViewController {
    
    private let settingView = SettingView()
    private var settings: [Settings] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = settingView
        makeNavi()
        setupTableView()
        setupSettingDatas()
        setupBannerView()
        
      //  addTargets()
      
    }
 
    
//    func addTargets() {
//        settingView.button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
//    }
    
    func setupSettingDatas() {
        self.settings.append(Settings(settingName: "유료 버전 구매(광고 제거)", redirection: nil))
        self.settings.append(Settings(settingName: "냉장고맵 응원하러 가기", redirection: nil))
        self.settings.append(Settings(settingName: "버전정보 1.0.0", redirection: nil))
    }
    
    
    func setupTableView() {
        settingView.tableView.dataSource = self
        settingView.tableView.delegate = self
        // 셀의 등록과정⭐️⭐️⭐️ (스토리보드 사용시에는 스토리보드에서 자동등록)
        settingView.tableView.register(SettingTableViewCell.self, forCellReuseIdentifier: "SettingCell")
        
    }
    func makeNavi() {
        let appearance = UINavigationBarAppearance()
        // 배경 색상 설정
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.shadowColor = .white //라인 없애기보다 배경색이랑 맞춰주는게 쉬은듯..
        appearance.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 20)]
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: settingView.button)
        // 다른 속성 설정
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
    }
    


}

extension SettingViewController: UITableViewDataSource, UITableViewDelegate {
    /// MARK: - 섹션헤더가 자동으로 들어가서 선이들어가짐 ㅡㅡ 제거함그래서

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as! SettingTableViewCell
        cell.settings = settings[indexPath.row]
        cell.label.tag = indexPath.row
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        if let cell = tableView.cellForRow(at: indexPath) as? SettingTableViewCell{
            if indexPath.row == 0 {
                setPremiumInfo()
            }
        }
    }

    

    
    
    
    
    func setPremiumInfo() {
        print("================")
        let nextVC = PremiumInfoViewController()
        nextVC.modalPresentationStyle = .pageSheet
        if let sheetPresentationController = nextVC.sheetPresentationController {
            let multiplier = 0.6
            //얘를 클로저 밖에 선언해줘야 드래그 했을 때 크기가 일정하게 유지됨
            let viewSize =  nextVC.view.frame.height
            let fraction = UISheetPresentationController.Detent.custom { context in
                viewSize * multiplier
            }
            sheetPresentationController.detents = [fraction,.large()]
//            sheetPresentationController.detents = [.medium(), .large()]
            sheetPresentationController.delegate = self
        }
        present(nextVC, animated: true, completion: nil)
    }
    
    
    
}


extension SettingViewController: UISheetPresentationControllerDelegate {
    
}



extension SettingViewController: GADBannerViewDelegate {
    
    private func setupBannerView() {
        //let adSize = GADAdSizeFromCGSize(CGSize(width: GADAdSizeBanner.size.width, height: 50))

        settingView.bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        settingView.bannerView.rootViewController = self
        settingView.bannerView.load(GADRequest())
        settingView.bannerView.delegate = self

    }
}

