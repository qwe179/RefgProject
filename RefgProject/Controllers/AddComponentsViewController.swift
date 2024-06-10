//
//  AddComponentsViewController.swift
//  RefgProject
//
//  Created by 23 09 on 2024/01/23.
//

import UIKit
import DLRadioButton
import GoogleMobileAds

class AddComponentsViewController: UIViewController {
    let addComponentsView = AddComponentsView()
    let myColor = UIColor.getCustomColor()
    let coreDataManager = CoreDataManager.shared
    var currentFridgeData: RefrigeratorData?
    var isFreezer: String = "N"
    var tagColor: String?

    weak var delegate: ComponentDelegate?

    private var whichTextField: UITextField?
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view = addComponentsView
        setupNavi()
        addTargets()
        textviewDelegate()
        calendarViewDelegate()
        setupBannerView()

    }

    func setupNavi() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.shadowColor = .white
        appearance.titleTextAttributes = [.font: UIFont(name: "NotoSansKR-Thin_Regular", size: 20)!]
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance

        self.title = "재료 추가"
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: addComponentsView.saveButton)
    }

    func addTargets() {
        addComponentsView.radioButton.addTarget(self, action: #selector(radioButtonTapped), for: .touchUpInside)
        addComponentsView.radioButton2.addTarget(self, action: #selector(radioButtonTapped), for: .touchUpInside)

        // MARK: - color Buttons

        addComponentsView.blackButton.addTarget(self, action: #selector(blackButtonTapped), for: .touchUpInside)
        addComponentsView.redButton.addTarget(self, action: #selector(redButtonTapped), for: .touchUpInside)
        addComponentsView.greenButton.addTarget(self, action: #selector(greenButtonTapped), for: .touchUpInside)
        addComponentsView.yellowButton.addTarget(self, action: #selector(yellowButtonTapped), for: .touchUpInside)
        addComponentsView.blueButton.addTarget(self, action: #selector(blueButtonTapped), for: .touchUpInside)
        addComponentsView.saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)

    }

    func textviewDelegate() {
        // MARK: - 델리게이트 하나씩다 해줘야 함
        addComponentsView.componentTextField.becomeFirstResponder()
        addComponentsView.componentTextField.delegate = self
        addComponentsView.registerDateTextField.delegate = self
        addComponentsView.expirationDateTextField.delegate = self
        addComponentsView.memoTextField.delegate = self
    }

    func calendarViewDelegate () {
        addComponentsView.calendarView.selectionBehavior = UICalendarSelectionSingleDate(delegate: self)
    }

    func setComponentData() -> Component? {

        guard let data = currentFridgeData else {return nil}

        guard let name = addComponentsView.componentTextField.text else { return nil}
        guard let registerDay = addComponentsView.registerDateTextField.text else { return nil}
        guard let dueDay = addComponentsView.expirationDateTextField.text else { return nil}
        guard let memo = addComponentsView.memoTextField.text else { return nil}
        let tagColor = self.tagColor ?? "black"

        return Component(
            refID: data.refID!,
            id: UUID().uuidString,
            name: name,
            registerDay: registerDay,
            dueDay: dueDay,
            isFreezer: isFreezer,
            memo: memo,
            tagColor: tagColor,
            coordinates: "")
    }

    @objc func radioButtonTapped(radioButton: DLRadioButton) {
        addComponentsView.radioButton.iconColor =  .gray
        addComponentsView.radioButton2.iconColor =  .gray

        if let text = radioButton.titleLabel?.text, text == "냉장" {
            self.isFreezer = "N"
        } else {
            self.isFreezer = "Y"
        }
        radioButton.iconColor =  myColor
    }

    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        // 특정 뷰에서 터치 이벤트가 발생했을 때의 처리
        print("Tap Gesture Recognized on TextField")
    }

    @objc func blackButtonTapped() {
        addComponentsView.colorButtons.forEach { btn in
            btn.imageView?.layer.borderColor = UIColor.white.cgColor
        }
        addComponentsView.blackButton.imageView?.layer.borderColor = UIColor(hexString: "3CB175").cgColor
        addComponentsView.blackButton.imageView?.layer.borderWidth = 3.0
        addComponentsView.blackButton.imageView?.layer.cornerRadius = 14
        self.tagColor = "222222"
    }
    @objc func redButtonTapped() {
        addComponentsView.colorButtons.forEach { btn in
            btn.imageView?.layer.borderColor = UIColor.white.cgColor
        }
        addComponentsView.redButton.imageView?.layer.borderColor = UIColor(hexString: "3CB175").cgColor
        addComponentsView.redButton.imageView?.layer.borderWidth = 3.0
        addComponentsView.redButton.imageView?.layer.cornerRadius = 14
        self.tagColor = "FF5D47"
    }
    @objc func greenButtonTapped() {
        addComponentsView.colorButtons.forEach { btn in
            btn.imageView?.layer.borderColor = UIColor.white.cgColor
        }
        addComponentsView.greenButton.imageView?.layer.borderColor = UIColor(hexString: "3CB175").cgColor
        addComponentsView.greenButton.imageView?.layer.borderWidth = 3.0
        addComponentsView.greenButton.imageView?.layer.cornerRadius = 14
        self.tagColor = "1B8900"
    }
    @objc func yellowButtonTapped() {
        addComponentsView.colorButtons.forEach { btn in
            btn.imageView?.layer.borderColor = UIColor.white.cgColor
        }
        addComponentsView.yellowButton.imageView?.layer.borderColor = UIColor(hexString: "3CB175").cgColor
        addComponentsView.yellowButton.imageView?.layer.borderWidth = 3.0
        addComponentsView.yellowButton.imageView?.layer.cornerRadius = 14
        self.tagColor = "E8D420"
    }
    @objc func blueButtonTapped() {
        addComponentsView.colorButtons.forEach { btn in
            btn.imageView?.layer.borderColor = UIColor.white.cgColor
        }
        addComponentsView.blueButton.imageView?.layer.borderColor = UIColor(hexString: "3CB175").cgColor
        addComponentsView.blueButton.imageView?.layer.borderWidth = 3.0
        addComponentsView.blueButton.imageView?.layer.cornerRadius = 14
        self.tagColor = "0AB9E1"
    }

    @objc func saveButtonTapped() {
        guard let component = setComponentData() else {
            print("재료 데이터 없음")
            return }
        delegate?.addNewComponent(component)
        navigationController?.popViewController(animated: true)
    }
}

extension AddComponentsViewController: UITextFieldDelegate {

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // MARK: - 등록일자, 소비기한 텍스트필드와 캘린더간 로직
        if textField.tag == 2 || textField.tag == 3 {
            addComponentsView.calendarView.isHidden = false

            if let date = textField.text?.components(separatedBy: ".") {
                if let year = Int(date[0]), let month = Int(date[1]), let day = Int(date[2]) {
                    let selectionDate = UICalendarSelectionSingleDate(delegate: self)
                    selectionDate.selectedDate = DateComponents(
                        calendar: Calendar(identifier: .gregorian),
                        year: year,
                        month: month,
                        day: day
                    )
                    addComponentsView.calendarView.selectionBehavior = selectionDate
                    addComponentsView.calendarView.setNeedsDisplay()
                }

            }

            whichTextField = textField
            return false
        } else {
            return true
        }
    }
    // 텍스트필드에 글자내용이 (한글자 한글자) 입력되거나 지워질때 호출 (허용할지 말지를 물어보는 것)
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    // 텍스트필드 에딧팅시작할때
    func textFieldDidBeginEditing(_ textField: UITextField) {

    }

    // 텍스트필드의 엔터키가 눌러졌을때 호출 (동작할지 말지 물어보는 것)
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(#function)
        return true
    }

    // 텍스트필드의 입력이 끝날때 호출 (끝낼지 말지를 물어보는 것)
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }

    // 텍스트필드의 입력이 (실제) 끝났을때 호출 (시점)
    func textFieldDidEndEditing(_ textField: UITextField) {
        print(#function)
    }

    // 화면에 탭을 감지(UIResponder)하는 메서드
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        addComponentsView.componentTextField.resignFirstResponder()
        addComponentsView.memoTextField.resignFirstResponder()

        addComponentsView.calendarView.isHidden = true
        addComponentsView.calendarView.setNeedsDisplay() // 특정뷰만 다시그리고 싶을 때 소환
    }

}
// MARK: - 캘린더 이벤트 처리

extension AddComponentsViewController: UICalendarSelectionSingleDateDelegate {

    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        guard let year = dateComponents?.year,
                let month = dateComponents?.month,
                let day = dateComponents?.day else { return }
        whichTextField!.text = "\(year).\(month).\(day)"
        whichTextField!.setNeedsDisplay()
        addComponentsView.calendarView.isHidden = true
        addComponentsView.calendarView.setNeedsDisplay()

    }
}

extension AddComponentsViewController: GADBannerViewDelegate {

    private func setupBannerView() {
        addComponentsView.bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        addComponentsView.bannerView.rootViewController = self
        addComponentsView.bannerView.load(GADRequest())
        addComponentsView.bannerView.delegate = self
    }
}
