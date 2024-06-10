//
//  MemoDetailViewController.swift
//  RefgProject
//
//  Created by 23 09 on 2024/02/06.
//

import UIKit
import GoogleMobileAds

class MemoEditViewController: UIViewController {

    let memoEditView = MemoEditView()
    let memoDataManager = MemoDataManager.shared

    var titleName: String?
    var memoData: MemoData?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = memoEditView
        setupNavi()
        setupTextField()
        addTargets()
        setupBannerView()
    }
    // 현재 컨트롤러엔 네비게이션 없고, 이전화면에 있고 설정해야함.. 아래건 임시..
    func setupNavi() {
        if let title = titleName {
            self.tabBarController?.navigationItem.title = title
        }
        self.tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: memoEditView.editButton)
    }

    func addTargets() {
        memoEditView.editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
    }

    @objc func editButtonTapped() {
        guard let data = self.memoData else {return}
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. M. d. HH:mm '수정됨'"
        let formattedDate = dateFormatter.string(from: currentDate)
        // 버튼 눌렀을 때 텍스트필드 활성화
        memoEditView.memoTextField.isEditable.toggle()
        // 버튼 눌렀을 때 버튼 수정,저장
        if memoEditView.memoTextField.isEditable == true {
            memoEditView.editButton.setTitle("저장", for: .normal)
            memoEditView.dateLabel.text = ""
            memoEditView.memoTextField.becomeFirstResponder()
        } else {
            memoEditView.editButton.setTitle("수정", for: .normal)
            memoEditView.dateLabel.text = formattedDate
            self.tabBarController?.navigationItem.title = memoEditView.memoTextField.text

            data.memo = memoEditView.memoTextField.text
            data.isEdit = true
            data.date = Date()
            memoDataManager.updateMemoDatas(memoData: data, completion: {
                print("업데이트 성공")
            })
        }

        self.view.setNeedsLayout()
        self.view.setNeedsDisplay()
    }

    // 화면에 탭을 감지(UIResponder)하는 메서드
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        memoEditView.memoTextField.resignFirstResponder()
    }
}

extension MemoEditViewController: UITextFieldDelegate {
    func setupTextField() {
        guard let data = self.memoData else {return}
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        if data.isEdit == true {
            dateFormatter.dateFormat = "yyyy. M. d. HH:mm '수정됨'"
        } else {
            dateFormatter.dateFormat = "yyyy. M. d. HH:mm '작성됨'"
        }
        let formattedDate = dateFormatter.string(from: currentDate)
        // memoEditView.memoTextField.delegate = self
        // memoEditView.memoTextField.becomeFirstResponder()
        memoEditView.memoTextField.text = memoData?.memo

        memoEditView.dateLabel.text = formattedDate
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
}

extension MemoEditViewController: GADBannerViewDelegate {

    private func setupBannerView() {
        memoEditView.bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        memoEditView.bannerView.rootViewController = self
        memoEditView.bannerView.load(GADRequest())
        memoEditView.bannerView.delegate = self

    }
}
