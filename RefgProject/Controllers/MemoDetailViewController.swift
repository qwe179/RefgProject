//
//  MemoDetailViewController.swift
//  RefgProject
//
//  Created by 23 09 on 2024/02/06.
//

import UIKit
import GoogleMobileAds

class MemoDetailViewController: UIViewController {
    
    let memoDetailView = MemoDetailView()
    let memoDataManager = MemoDataManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = memoDetailView

        textviewDelegate()
        addTargets()
        setupNavi()
        setupBannerView()
//        self.navigationController?.title = "재료 추가"

    }
    
    //현재 컨트롤러엔 네비게이션 없고, 이전화면에 있고 설정해야함.. 아래건 임시..
    func setupNavi() {
        self.title = "메모쓰기"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: memoDetailView.saveButton)

    }
    
    func addTargets() {
        memoDetailView.saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    @objc func saveButtonTapped() {
//        if memoDetailView.memoTextField.text == "" {
//            return
//        }
        memoDataManager.saveMemoData(memo: memoDetailView.memoTextField.text ?? "", completion: {})
        navigationController?.popViewController(animated: true)
    }
    

    

}

extension MemoDetailViewController: UITextFieldDelegate{
    func textviewDelegate() {
//        memoDetailView.memoTextField.delegate = self
        memoDetailView.memoTextField.becomeFirstResponder()
        
    }
    // 텍스트필드의 엔터키가 눌러졌을때 호출 (동작할지 말지 물어보는 것)
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(#function)
        return true
    }
    
    // 화면에 탭을 감지(UIResponder)하는 메서드
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        memoDetailView.memoTextField.resignFirstResponder()
    }
}


extension MemoDetailViewController: GADBannerViewDelegate {
    
    private func setupBannerView() {
        //let adSize = GADAdSizeFromCGSize(CGSize(width: GADAdSizeBanner.size.width, height: 50))

        memoDetailView.bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        memoDetailView.bannerView.rootViewController = self
        memoDetailView.bannerView.load(GADRequest())
        memoDetailView.bannerView.delegate = self

    }
}

