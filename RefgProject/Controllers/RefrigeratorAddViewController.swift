//
//  RefrigeratorAddViewController.swift
//  RefgProject
//
//  Created by 23 09 on 2024/01/25.
//

import UIKit
import GoogleMobileAds
class RefrigeratorAddViewController: UIViewController {

    private let refrigeratorAddView = RefrigeratorAddView()
    var refgArray: [Refrigerator] = []
    var refgDataManager = DataManager()
    let coreDataManger = CoreDataManager.shared
    var refrigeratorData: Refrigerator = Refrigerator(
        refrigeratorName: "",
        refrigeratorDescription: "",
        refrigeratorType: ""
    )

    weak var delegate: FridgeDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = refrigeratorAddView
        setCollectionView()
        setupDatas()
        setupNavi()
        setTargets()
        setupBannerView()
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

        self.title = "냉장고 추가"

        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: refrigeratorAddView.saveButton)
    }

    func setupDatas() {
        refgDataManager.makeRefrData()
        refgArray = refgDataManager.getRefrData()
    }

    func setCollectionView() {
        refrigeratorAddView.collectionView.dataSource = self
        refrigeratorAddView.collectionView.delegate = self
        refrigeratorAddView.collectionView.register(RefgCollectionViewCell.self, forCellWithReuseIdentifier: "RefgCell")
    }

    func setTargets() {
        refrigeratorAddView.saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }

    func showAlert() {
        let alertController = UIAlertController(title: "알림", message: "별명을 입력해주세요.", preferredStyle: .alert)
       let okAction = UIAlertAction(title: "확인", style: .default, handler: { _ in })
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

    @objc func saveButtonTapped() {

        guard let text = refrigeratorAddView.nickNameTextField.text, text != "" else {
            showAlert()
            return }
        refrigeratorData.refrigeratorName = text
      //  guard let refName = refrigeratorData.refrigeratorName , refName != "" else{ return }
        if refrigeratorData.refrigeratorType == "" {
            print("타입없음")
            return
        }
        coreDataManger.saveFridgeData(
            refID: UUID().uuidString,
            refName: refrigeratorData.refrigeratorName,
            refType: refrigeratorData.refrigeratorType,
            completion: {}
        )
        // 냉장고맵 셋팅

        let fridgeDatas = coreDataManger.getFridgeDataFromCoreData()

        delegate?.setCurruntFridge(fridgeDatas[0])

        // 이전뷰의 드롭다운 셋
//        if let navigationController = self.navigationController,
//           let viewController = navigationController.viewControllers.first as? RefrigratorMapViewController {
//            let previousViewController = viewController
//            previousViewController.setDropDownDatas()
//        }
        navigationController?.popViewController(animated: true)
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
        refrigeratorAddView.nickNameTextField.resignFirstResponder()
    }
}

// MARK: - delegate CollectionView

extension RefrigeratorAddViewController: UICollectionViewDataSource,
                                         UICollectionViewDelegateFlowLayout,
                                         UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSpacing: CGFloat = 10 // 가로에서 셀과 셀 사이의 거리
        let width = (collectionView.bounds.width - itemSpacing) / 2
        let height: CGFloat = 226 // 원하는 높이로 설정하세요
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? RefgCollectionViewCell {
            cell.imageView.layer.borderWidth = 3.0 // 경계선 굵기
            cell.imageView.layer.borderColor = UIColor(red: 0.23, green: 0.70, blue: 0.46, alpha: 1.0).cgColor

            if let text = cell.descriptionLabel.text {
                refrigeratorData.refrigeratorType = text
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
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "RefgCell",
            for: indexPath
        ) as? RefgCollectionViewCell
        cell!.mainImageView.image = refgArray[indexPath.row].refrigeratorImage
        cell!.refgNameLabel.text = refgArray[indexPath.row].refrigeratorName
        cell!.descriptionLabel.text = refgArray[indexPath.row].refrigeratorDescription
        return cell!
    }
}

extension RefrigeratorAddViewController: GADBannerViewDelegate {

    private func setupBannerView() {
        refrigeratorAddView.bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        refrigeratorAddView.bannerView.rootViewController = self
        refrigeratorAddView.bannerView.load(GADRequest())
        refrigeratorAddView.bannerView.delegate = self

    }
}
