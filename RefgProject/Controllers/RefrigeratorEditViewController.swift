//
//  RefrigeratorEditViewController.swift
//  RefgProject
//
//  Created by 23 09 on 2024/01/25.
//

import UIKit
import GoogleMobileAds



class RefrigeratorEditViewController: UIViewController {
    
    let refrigeratorEditView = RefrigeratorEditView()
    var refgArray: [Refrigerator] = []
    var refgDataManager = DataManager()
    // MARK: - 이전 화면에서 받아온 현재 냉장고 데이터
    var currentFridgeData: RefrigeratorData?
    let coreDataManger = CoreDataManager.shared
    
    weak var delegate: FridgeDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = refrigeratorEditView
        setCollectionView()
        setupDatas()
        setupNavi()
        setTargets()
        setupBannerView()
        textviewDelegate()
        addGesture()
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
        
        self.title = "냉장고 편집"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView:         refrigeratorEditView.saveButton)
        
        
    }
    
    func setupDatas() {
        refgDataManager.makeRefrData()
        refgArray = refgDataManager.getRefrData()
    }
    
    func setCollectionView() {
        refrigeratorEditView.collectionView.dataSource = self
        refrigeratorEditView.collectionView.delegate = self
        refrigeratorEditView.collectionView.register(RefgCollectionViewCell.self, forCellWithReuseIdentifier: "RefgCell")
    }
    
    func setTargets() {
        refrigeratorEditView.saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        refrigeratorEditView.fridgeDeleteButton.addTarget(self, action: #selector(fridgeDeleteButtonTapped), for: .touchUpInside)
    }
    
    func showAlert() {
        let alertController = UIAlertController(title: "알림", message: "별명을 입력해주세요.", preferredStyle: .alert)
       let okAction = UIAlertAction(title: "확인", style: .default, handler: { action in
            print("확인 버튼 눌림")
        })
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func saveButtonTapped() {
        guard let text = refrigeratorEditView.nickNameTextField.text, text != "" else {
            showAlert()
            return }
        currentFridgeData?.refName = text
        guard let fridgeData = currentFridgeData else { return }
        coreDataManger.updateFridgeDatas(fridgeData: fridgeData, completion: {})
        //delegate?.setCurruntFridge(fridgeData[0])
        navigationController?.popViewController(animated: true)
    }
    
    @objc func fridgeDeleteButtonTapped() {
        let confirmAlert = UIAlertController(title: nil, message: "냉장고가 하나일 때는 삭제할 수 없습니다", preferredStyle: UIAlertController.Style.alert)
        let confirmAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default)
        confirmAction.setValue(UIColor(hexString: "3CB175"), forKey: "titleTextColor")
        confirmAlert.addAction(confirmAction)
        
        
        let alert = UIAlertController(title: nil, message: "이 냉장고를 삭제 하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "취소", style: UIAlertAction.Style.default)
        let deleteAction = UIAlertAction(title: "삭제", style: UIAlertAction.Style.destructive){_ in
            if self.coreDataManger.getFridgeDataFromCoreData().count <= 1 {
                self.present(confirmAlert, animated: true)
            } else {
                guard let fridgeData = self.currentFridgeData else { return }
                self.coreDataManger.deleteFridgeByID(data: fridgeData, completion: {})
                self.coreDataManger.deleteComponentsByRefID(refID: fridgeData.refID, completion: {})
                // MARK: - 위에서 데이터 삭제했으니까 다시가져와야됨;;;
                let data = self.coreDataManger.getFridgeDataFromCoreData()
                self.delegate?.setCurruntFridge(data[0])
                self.navigationController?.popViewController(animated: true)
            }
        }
        
        // MARK: - 알람 메인 레이블 커스터마이징 하는 법
//        var attributedString = NSMutableAttributedString()
//        attributedString = NSMutableAttributedString(string: "삭제", attributes: [NSAttributedString.Key.foregroundColor: UIColor(hexString: "3CB175")])
//        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value:  UIColor.blue, range: NSRange(location: 0, length: attributedString.length))
//        alert.setValue(attributedString, forKey: "attributedMessage")

        deleteAction.setValue(UIColor(hexString: "3CB175"), forKey: "titleTextColor")

    
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        self.present(alert, animated: true)
        
    }
    
    func addGesture() {
        // UITapGestureRecognizer를 추가하여 터치 이벤트 감지
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        // MARK: - "테이블뷰 didselect와 충돌날 시에는 아래 추가해줘야함"
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - 터치이벤트

    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        refrigeratorEditView.nickNameTextField.resignFirstResponder()
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

// MARK: - delegate CollectionView

extension RefrigeratorEditViewController: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSpacing: CGFloat = 10 //가로에서 셀과 셀 사이의 거리
        let width = (collectionView.bounds.width - itemSpacing) / 2
        let height: CGFloat = 226 // 원하는 높이로 설정하세요
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? RefgCollectionViewCell {
            cell.imageView.layer.borderWidth = 3.0 // 경계선 굵기
            cell.imageView.layer.borderColor = UIColor(red: 0.23, green: 0.70, blue: 0.46, alpha: 1.0).cgColor
            
            if let text = cell.descriptionLabel.text {
                currentFridgeData?.refType = text //현재 냉장고의 냉장고 타입 교체,
            }
            
        }
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? RefgCollectionViewCell {
            cell.imageView.layer.borderWidth = 1.0 // 경계선 굵기
            cell.imageView.layer.borderColor = UIColor.white.cgColor
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return refgArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RefgCell", for: indexPath) as! RefgCollectionViewCell
        cell.mainImageView.image = refgArray[indexPath.row].refrigeratorImage
        cell.refgNameLabel.text = refgArray[indexPath.row].refrigeratorName
        cell.descriptionLabel.text = refgArray[indexPath.row].refrigeratorDescription
        return cell
    }
    
    
}

extension RefrigeratorEditViewController: UITextFieldDelegate {
    
    func textviewDelegate() {
        refrigeratorEditView.nickNameTextField.delegate = self
    }
    
}



extension RefrigeratorEditViewController: GADBannerViewDelegate {
    
    private func setupBannerView() {
        //let adSize = GADAdSizeFromCGSize(CGSize(width: GADAdSizeBanner.size.width, height: 50))

        refrigeratorEditView.bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        refrigeratorEditView.bannerView.rootViewController = self
        refrigeratorEditView.bannerView.load(GADRequest())
        refrigeratorEditView.bannerView.delegate = self

    }
}
