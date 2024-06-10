//
//  RefrigratorView.swift
//  RefgProject
//
//  Created by 23 09 on 2024/01/22.
//

import UIKit
import DropDown
import GoogleMobileAds

class RefrigratorView: UIView {

    let bannerView: GADBannerView = {
        let view = GADBannerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()

    var test = "(상냉장 하냉동)" {
        didSet {
            removeSubviews()
            setupUI()
        }
    }

    var isSwitchOn = false {
        willSet {
            if newValue == true {
                removeSubviews()
                setupListUI()
            } else {
                removeSubviews()
                setupUI()
            }
        }
    }

    // MARK: - 냉장고 및 내용물 정보

//    var kindOfRef: RefData? {
//
//        didSet {
//            //데이터 다시설정하는거 해야함
//        }
//    }

    // MARK: - UI 셋팅

    lazy var button: UIButton = {
        let button = UIButton()

        var title: String = "양문형3/4도어"
//        if let name = kindOfRef?.name {
//            title = name
//        }

        button.setTitle(title, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.black, for: .normal)
        button.setImage(UIImage(named: "arrowdown.png"), for: .normal)
        /* 버튼 이미지 오른쪽으로(스위프트 14이후에는 이렇게 사용)
         그리고 폰트사이즈도 여기서 수정해줘야됨,, 우선적으로 적용되는듯
         */
        var newConfig = UIButton.Configuration.plain()
        newConfig.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
           var outgoing = incoming
           outgoing.font = UIFont(name: "NotoSansKR-Thin_Medium", size: 20)!
            return outgoing
        }
        newConfig.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 2, bottom: 0, trailing: 0)
        newConfig.imagePlacement = .trailing
        newConfig.imagePadding = 8.0

        button.configuration = newConfig

        return button
    }()

    let plusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "add_circle.png"), for: .normal)
        return button
    }()

    let listButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "list1.png"), for: .normal)
        return button
    }()
    // MARK: - 냉장고 추가 버튼
    // UISwitch 생성
    let switchList: UISwitch = {
        let switchList = UISwitch()
        switchList.onTintColor = UIColor.getCustomColor()
        // UISwitch의 상태 변경 이벤트에 대한 액션 추가 (옵션)
        switchList.translatesAutoresizingMaskIntoConstraints = false
        return switchList
    }()

    let switchLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "리스트로 보기"
        label.font = UIFont(name: "NotoSansKR-Thin_Regular", size: 18)
        return label
    }()

    lazy var  switchStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.addSubview(switchList)
        stackView.addSubview(switchLabel)
        stackView.backgroundColor = .white
        return stackView
    }()

    // MARK: - 재료 추가 버튼
    let addListButton: UIButton = {
//        let button = UIButton(type: .contactAdd)
        let button = UIButton()
        button.setImage(UIImage(named: "FAB_button.png"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
       // button.layer.zPosition = 1 //자꾸 가려서 우선순위줌
        return button
    }()

    lazy var refViews: [UIView] = {
        var vList: [UIView] = []
        for item in 1...4 {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.layer.cornerRadius = 20
            view.layer.masksToBounds = false
            view.layer.shadowOffset = CGSize(width: 0, height: 5)
            view.layer.shadowColor = UIColor.black.cgColor
            view.layer.shadowRadius = 2
            view.layer.shadowOpacity = 0.2
            view.backgroundColor = UIColor.white
            vList.append(view)
        }
        return vList
    }()

    lazy var refStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 8
//        sv.addArrangedSubview(refViews[0])
//        sv.addArrangedSubview(refViews[1])
        return stackView
    }()
    // MARK: - 2도어

    lazy var refStackView2: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        return stackView
    }()

    // MARK: - 3/4도어

    lazy var refStackView3: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        return stackView
    }()

    // MARK: - 드롭다운!!

    lazy var dropDown: DropDown = {
        let dropDown = DropDown()
        var itemList = ["양문형3/4도어", "양문형 2도어", "일반형 2도어", "일반형"]
        dropDown.dataSource = itemList
        dropDown.selectionAction = {  (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
        }
        dropDown.bottomOffset = CGPoint(x: 0, y: button.bounds.height)
        dropDown.dismissMode = .automatic // 팝업을 닫을 모드 설정
        dropDown.anchorView = button
        return dropDown
    }()

    // MARK: - 테이블뷰
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.showsVerticalScrollIndicator = false
        // MARK: - 테이블뷰 라인 틀어졌을 경우에 마진 설정해줘야함
        tableView.separatorInset.left = 0
        tableView.separatorInset.right = 0
        return tableView
    }()

    let sortBarStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        return stackView
    }()

    let sortButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("최신 등록 순", for: .normal)
        btn.setTitleColor(.green, for: .normal)
        btn.setTitleColor(UIColor(hexString: "3CB175"), for: .normal)
        btn.backgroundColor = .white
        btn.setImage(UIImage(named: "sortIcon.png"), for: .normal)
        btn.contentHorizontalAlignment = .left
        btn.titleLabel?.font = UIFont(name: "NotoSansKR-Thin_Regular", size: 14)!
        return btn
    }()

    let sortDeleteButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("재료삭제", for: .normal)
        btn.setTitleColor(.red, for: .normal)
        btn.backgroundColor = .white
        btn.contentHorizontalAlignment = .right
        btn.titleLabel?.font = UIFont(name: "NotoSansKR-Thin_Regular", size: 14)
        return btn
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - 오토레이아웃
    func createLabel(_ gesture: UIPanGestureRecognizer, _ componentData: ComponentData) -> UIButton {
        let label: UIButton = {
            let btn = UIButton()
            btn.translatesAutoresizingMaskIntoConstraints = false
            btn.setTitle(componentData.name, for: .normal)
            var buttonConfig = UIButton.Configuration.plain()
            buttonConfig.titlePadding = 4
            buttonConfig.baseForegroundColor = UIColor.white
            buttonConfig.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
               var outgoing = incoming
               outgoing.font = UIFont(name: "NotoSansKR-Thin_Medium", size: 12)!
                return outgoing
            }
            btn.configuration = buttonConfig
            btn.backgroundColor = UIColor(hexString: componentData.tagColor ?? "FF5D47")
         //   v.titleLabel?.font = UIFont(name: "NotoSansKR-Thin_Regular", size: 12)
            btn.layer.cornerRadius = 5
            btn.layer.masksToBounds = true
            return btn
        }()
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(gesture)
        return label
    }

    func setupConstraintsOfLabels(_ labels: [UIView]) {
        for label in labels {
            self.addSubview(label)
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            label.heightAnchor.constraint(equalToConstant: 28).isActive = true
        }
    }

    func setupUI() {
        // 오토레이아웃 설정
        self.backgroundColor = UIColor(hexString: "F1F1F1")
        self.addSubview(switchStackView)
        NSLayoutConstraint.activate([
            switchStackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            switchStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            switchStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            switchStackView.heightAnchor.constraint(equalToConstant: 40)
        ])
        NSLayoutConstraint.activate([
            switchList.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8)
        ])
        NSLayoutConstraint.activate([
            switchLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            switchLabel.centerYAnchor.constraint(equalTo: switchStackView.centerYAnchor)
        ])

        switch test {
        case "(상냉장 하냉동)":
            refStackView.axis = .horizontal
            refStackView.addArrangedSubview(refViews[0])
            refStackView.addArrangedSubview(refViews[1])
            refStackView2.addArrangedSubview(refViews[2])
            refStackView2.addArrangedSubview(refViews[3])
            refStackView3.addArrangedSubview(refStackView)
            refStackView3.addArrangedSubview(refStackView2)
            self.addSubview(refStackView3)
            NSLayoutConstraint.activate([
                refStackView3.topAnchor.constraint(equalTo: switchStackView.bottomAnchor, constant: 20),
                refStackView3.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
                refStackView3.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
                refStackView3.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -58)

            ])
            print("something1")
        case "(좌냉동 우냉장)":
            refStackView.axis = .horizontal
            refStackView.addArrangedSubview(refViews[0])
            refStackView.addArrangedSubview(refViews[1])

            self.addSubview(refStackView)
            NSLayoutConstraint.activate([
                refStackView.topAnchor.constraint(equalTo: switchStackView.bottomAnchor, constant: 20),
                refStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
                refStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
                refStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -58)
            ])
        case "(상냉동 하냉장)":
            refStackView.addArrangedSubview(refViews[0])
            refStackView.addArrangedSubview(refViews[1])
            refStackView.axis = .vertical
            self.addSubview(refStackView)
            NSLayoutConstraint.activate([
                refStackView.topAnchor.constraint(equalTo: switchStackView.bottomAnchor, constant: 20),
                refStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
                refStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
                refStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -58)
            ])
            print("일반형 2도어")
        case "(냉장전용/김치냉장고)":
            self.addSubview(refViews[0])
            NSLayoutConstraint.activate([
                refViews[0].topAnchor.constraint(equalTo: switchStackView.bottomAnchor, constant: 20),
                refViews[0].leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
                refViews[0].trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
                refViews[0].bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -58)
            ])
        default:
            self.addSubview(refStackView3)
            NSLayoutConstraint.activate([
                refStackView3.topAnchor.constraint(equalTo: switchStackView.bottomAnchor, constant: 20),
                refStackView3.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
                refStackView3.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
                refStackView3.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -58)

            ])
        }
        // 뷰 등록하는 순서가 중요
        self.addSubview(addListButton)
        NSLayoutConstraint.activate([
            addListButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: 0),
            addListButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -42)
        ])

        // 배너뷰는 bottom anchor를 등록해야되나볌
        self.addSubview(bannerView)
        NSLayoutConstraint.activate([
            bannerView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            bannerView.heightAnchor.constraint(equalToConstant: GADAdSizeBanner.size.height),
            bannerView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            bannerView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])

        if IsPremium.isPremium == true {
            self.bannerView.removeFromSuperview()

            addListButton.removeFromSuperview()
            self.addSubview(addListButton)
            NSLayoutConstraint.activate([
                addListButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: 0),
                addListButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20)
            ])
        }

    }

    func setupListUI() {
        self.backgroundColor = .white
        self.addSubview(switchStackView)

        NSLayoutConstraint.activate([
            switchStackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            switchStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            switchStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            switchStackView.heightAnchor.constraint(equalToConstant: 40)
        ])
        NSLayoutConstraint.activate([
            switchList.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8)
        ])
        NSLayoutConstraint.activate([
            switchLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            switchLabel.centerYAnchor.constraint(equalTo: switchStackView.centerYAnchor)
        ])
        sortBarStackView.addArrangedSubview(sortButton)
        sortBarStackView.addArrangedSubview(sortDeleteButton)
        self.addSubview(sortBarStackView)
        NSLayoutConstraint.activate([
            sortBarStackView.topAnchor.constraint(equalTo: switchStackView.bottomAnchor),
            sortBarStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            sortBarStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            sortBarStackView.heightAnchor.constraint(equalToConstant: 40)
        ])

        self.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: sortBarStackView.bottomAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -50)
        ])

        self.addSubview(addListButton)
        NSLayoutConstraint.activate([
            addListButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: 0),
            addListButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -42)
        ])

        // 배너뷰는 bottom anchor를 등록해야되나볌
        self.addSubview(bannerView)
        NSLayoutConstraint.activate([
            bannerView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            bannerView.heightAnchor.constraint(equalToConstant: GADAdSizeBanner.size.height),
            bannerView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            bannerView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])

        if IsPremium.isPremium == true {
            self.bannerView.removeFromSuperview()

            addListButton.removeFromSuperview()
            self.addSubview(addListButton)
            NSLayoutConstraint.activate([
                addListButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: 0),
                addListButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20)
            ])
        }
    }
    func removeSubviews() {
        self.switchStackView.removeFromSuperview()
        self.refStackView3.removeFromSuperview()
        self.refStackView2.removeFromSuperview()
        self.refStackView.removeFromSuperview()
        self.refViews[0].removeFromSuperview()
        self.refViews[1].removeFromSuperview()
        self.refViews[2].removeFromSuperview()
        self.refViews[3].removeFromSuperview()
        self.addListButton.removeFromSuperview()
        self.tableView.removeFromSuperview()
        self.sortButton.removeFromSuperview()
        self.sortDeleteButton.removeFromSuperview()
        self.sortBarStackView.removeFromSuperview()
        self.bannerView.removeFromSuperview()
    }
}
