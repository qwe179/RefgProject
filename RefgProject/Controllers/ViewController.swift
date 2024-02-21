//
//  ViewController.swift
//  What's-in-my-refrigerator
//
//  Created by 23 09 on 2024/01/15.
//

import UIKit

class ViewController: UIViewController {

    private let firstView = FirstView()
    var refgArray: [Refrigerator] = []
    var refgDataManager = DataManager()
    let coreDataManager = CoreDataManager.shared
    var label: String?
    var isFirst: Bool = true
    


    
    // MARK: - 라이프사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        IsPremium.isPremium = true
        setCollectionView()
        setTargets()
        setupDatas()
        
        self.view = firstView
//        CoreDataManager.shared.deleteAllDataOfFridge {
//            
//        }
//        CoreDataManager.shared.deleteAllOfComponents {
//            
//        }
        
        checkIsFirstTime()
        

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        makeNavi()
    }
    
    func checkIsFirstTime() {
        if coreDataManager.getFridgeDataFromCoreData().count != 0 {
            self.isFirst = false
        }
        if self.isFirst == true {
            return
        }else {
            present(NicknameViewController().settingTapBarContoller()!, animated: false, completion: nil)
        }
    }
    
    
    
    // MARK: - 네비게이션 바
    func makeNavi() {

        let appearance = UINavigationBarAppearance()

        // 배경 색상 설정
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.shadowColor = .white //라인 없애기보다 배경색이랑 맞춰주는게 쉬은듯..
        appearance.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 10, weight: .bold)]

        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance

    }
    

    // MARK: - 콜렉션뷰 데이터, 델리게이트 셋팅

    func setupDatas() {
        refgDataManager.makeRefrData()
        refgArray = refgDataManager.getRefrData()
    }
    
    func setCollectionView() {
        firstView.collectionView.dataSource = self
        firstView.collectionView.delegate = self
        firstView.collectionView.register(RefgCollectionViewCell.self, forCellWithReuseIdentifier: "RefgCell")
    }
    
    func setTargets() {
        firstView.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - 버튼 이벤트

    @objc func nextButtonTapped() {
        let nextVC = NicknameViewController()
        if let label = self.label {
            nextVC.fridgeDescription = label
            print(label)
        } else {
            return
        }
        navigationController?.pushViewController(nextVC, animated: true)
    }
    


}

// MARK: - 콜렉션뷰 관련

extension ViewController: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    // MARK: - 콜렉션 뷰 셀 관련 설정들
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
            
            self.label = cell.descriptionLabel.text!

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

//#Preview {
//    ViewController()
//}
