//
//  RefrigeratorEditView.swift
//  RefgProject
//
//  Created by 23 09 on 2024/01/25.
//

import UIKit
import GoogleMobileAds

class RefrigeratorAddView: UIView {

     let stackView: UIStackView! = UIStackView()
    // MARK: - UI 생성
    let bannerView: GADBannerView = {
        let view = GADBannerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .blue
        return view
    }()

    let saveButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("저장", for: .normal)
        btn.titleLabel?.font = UIFont(name: "NotoSansKR-Thin_Bold", size: 18)
        btn.setTitleColor(UIColor.init(hexString: "3CB175"), for: .normal)
        return btn
    }()

    let nickNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "냉장고 별명"
        label.font = UIFont(name: "NotoSansKR-Thin_Regular", size: 24)
        return label
    }()

    let refTypeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "냉장고 타입"
        label.font = UIFont(name: "NotoSansKR-Thin_Regular", size: 24)
        return label
    }()

    let nickNameTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "양문형 3/4도어"
        textField.font = UIFont(name: "NotoSansKR-Thin_Regular", size: 18)
        return textField
    }()

    let collectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
       layout.scrollDirection = .vertical
       layout.minimumLineSpacing = 20  // 각 행(세로) 간의 간격

       let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
       collectionView.translatesAutoresizingMaskIntoConstraints = false

       return collectionView
   }()

    lazy var selectLabelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(nickNameTextField)
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 10

        return stackView
    }()

    private let scrollView: UIScrollView = {
        let scView = UIScrollView()
        scView.translatesAutoresizingMaskIntoConstraints = false
        scView.backgroundColor = .white
        return scView
    }()
    // 스크롤뷰의 콘텐트뷰
    private let contentView: UIView = {
          let contentView = UIView()
          contentView.translatesAutoresizingMaskIntoConstraints = false
          return contentView
    }()
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = """
이미 등록된 식재료의 위치는 변경되지 않습니다.
변경된 가이드라인에 따라 다시 조정해주세요
"""
        label.font = UIFont(name: "NotoSansKR-Thin_Regular", size: 12)
        label.textColor = UIColor(hexString: "3CB175")
        label.numberOfLines = 2
        return label
    }()

    // MARK: - 뷰 생성할때 오토레이아웃 잡아줌

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupUI()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
//        setupUI()
    }

    // MARK: - 오토레이아웃 및 뷰 등록

    private func setupUI() {
        // UIScrollView 추가
        addSubview(scrollView)
        // UIScrollView 제약 조건 설정
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        // 콘텐츠 뷰를 UIScrollView에 추가
        scrollView.addSubview(contentView)
        // 콘텐츠 뷰 제약 조건 설정
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        // 예시 뷰를 콘텐츠 뷰에 추가
        contentView.addSubview(nickNameLabel)
        // 예시 뷰 제약 조건 설정
        // MARK: 하위 뷰의 가장위의 뷰는 하단제약조건없어야되고, 가장아래 뷰는 하단제약조건이 콘텐트뷰의 제약조건이어야 한다.
        NSLayoutConstraint.activate([
            nickNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            nickNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            nickNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10)
        ])

        contentView.addSubview(nickNameTextField)
        NSLayoutConstraint.activate([
            nickNameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            nickNameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            nickNameTextField.topAnchor.constraint(equalTo: nickNameLabel.bottomAnchor, constant: 10),
            nickNameTextField.heightAnchor.constraint(equalToConstant: 54)
        ])

        contentView.addSubview(refTypeLabel)
        NSLayoutConstraint.activate([
            refTypeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            refTypeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            refTypeLabel.topAnchor.constraint(equalTo: nickNameTextField.bottomAnchor, constant: 10)
        ])
        contentView.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            collectionView.topAnchor.constraint(equalTo: refTypeLabel.bottomAnchor, constant: 10),
            collectionView.heightAnchor.constraint(equalToConstant: 474),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        self.addSubview(bannerView)
        NSLayoutConstraint.activate([
            bannerView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            bannerView.heightAnchor.constraint(equalToConstant: GADAdSizeBanner.size.height),
            bannerView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            bannerView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])

        if IsPremium.isPremium == true {
            self.bannerView.removeFromSuperview()
        }

     }
}
