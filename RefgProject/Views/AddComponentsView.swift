//
//  AddComponentsView.swift
//  RefgProject
//
//  Created by 23 09 on 2024/01/23.
//

import UIKit
import DLRadioButton
import GoogleMobileAds

class AddComponentsView: UIView {
    let bannerView: GADBannerView = {
        let view = GADBannerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    
    let dateHelper = DateHelper()
    
    let colorButtons: [UIButton]
    
    let saveButton: UIButton = {
        let bt = UIButton()
        bt.setTitle("저장", for: .normal)
        bt.titleLabel?.font = UIFont(name: "NotoSansKR-Thin_Bold", size: 18)
        bt.setTitleColor(UIColor.init(hexString: "3CB175"), for: .normal)
        return bt
    }()
    

    
    // MARK: - 라디오버튼
    let radioButton: DLRadioButton = {
        let bt = DLRadioButton()
        
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.setTitle("냉장", for: .normal)
        bt.setTitleColor(.black, for: .normal)
        bt.titleLabel?.font = UIFont(name: "NotoSansKR-Thin_Regular", size: 18)
        bt.indicatorColor =  UIColor.getCustomColor()
        bt.iconColor =  .gray
        bt.isIconOnRight = true
        bt.marginWidth = -30
        return bt
    }()
    
    let radioButton2: DLRadioButton = {
        
        let bt = DLRadioButton()
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.setTitle("냉동", for: .normal)
        bt.setTitleColor(.black, for: .normal)
        bt.titleLabel?.font = UIFont(name: "NotoSansKR-Thin_Regular", size: 18)
        bt.indicatorColor =  UIColor.getCustomColor()
        bt.iconColor =  .gray
        bt.isIconOnRight = true
        bt.marginWidth = -30
        return bt
    }()
    // MARK: - 라디오 뷰
    lazy var radioView: UIView = {
        let st = UIView()
        st.translatesAutoresizingMaskIntoConstraints = false
       
        return st
    }()
    
    lazy var contView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false

        return v
    }()
    
    let nameComponentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "재료명"
        label.font = UIFont(name: "NotoSansKR-Thin_Regular", size: 16)
        return label
    }()
    
    let componentTextField: CustomTextField = {
        let tf = CustomTextField()
        //tf.placeholder = "test"
        tf.tag = 1
        return tf
    }()

    
    lazy var componentStackView: UIStackView = {
        let st = UIStackView()
        st.translatesAutoresizingMaskIntoConstraints = false
        st.axis = .vertical
        st.alignment = .fill
        st.distribution = .fill
        st.addArrangedSubview(nameComponentLabel)
        st.addArrangedSubview(componentTextField)
        return st
    }()
    
    // MARK: - 등록일자 ~ 소비기한 선언부

    let registerDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "등록일자"
        label.font = UIFont(name: "NotoSansKR-Thin_Regular", size: 16)
        return label
    }()
    
    lazy var registerDateTextField: CustomTextField = {
        let tf = CustomTextField()
//        tf.isUserInteractionEnabled = false
        tf.tag = 2
        tf.text = dateHelper.todayString
        return tf
    }()
    
    lazy var registerDateStackView: UIStackView = {
        let st = UIStackView()
        st.translatesAutoresizingMaskIntoConstraints = false
        st.axis = .vertical
        st.alignment = .fill
        st.distribution = .fill
        st.addArrangedSubview(registerDateLabel)
        st.addArrangedSubview(registerDateTextField)
        
        return st
    }()
    
    let expirationDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "소비기한"
        label.font = UIFont(name: "NotoSansKR-Thin_Regular", size: 16)
        return label
    }()
    
    lazy var expirationDateTextField: CustomTextField = {
        let tf = CustomTextField()
//        tf.isUserInteractionEnabled = false
        tf.tag = 3
        tf.text = dateHelper.calculateDate(day: 7)
        return tf
    }()
    
    lazy var expirationDateStackView: UIStackView = {
        let st = UIStackView()
        st.translatesAutoresizingMaskIntoConstraints = false
        st.axis = .vertical
        st.alignment = .fill
        st.distribution = .fill
        st.addArrangedSubview(expirationDateLabel)
        st.addArrangedSubview(expirationDateTextField)
        
        return st
    }()
    
    // MARK: - 메모
    let memoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "메모"
        label.font = UIFont(name: "NotoSansKR-Thin_Medium", size: 20)
        return label
    }()
    
    let memoTextField: CustomTextField = {
        let tf = CustomTextField()
        tf.placeholder = "메모를 입력해주세요"
        tf.tag = 4
        return tf
    }()
    
    lazy var memoStackView: UIStackView = {
        let st = UIStackView()
        st.translatesAutoresizingMaskIntoConstraints = false
        st.axis = .vertical
        st.alignment = .fill
        st.distribution = .fill
        st.addArrangedSubview(memoLabel)
        st.addArrangedSubview(memoTextField)
        return st
    }()
    
    
    // MARK: - 태그 색깔 선택
    
    let tagLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "태그색깔선택"
        label.font = UIFont(name: "NotoSansKR-Thin_Regular", size: 16)
        return label
    }()

    let blackButton: CustomColorButton = {
        let btn = CustomColorButton()
        btn.tintColor = .black
        return btn
    }()
    
    let redButton: CustomColorButton = {
        let btn = CustomColorButton()
        btn.tintColor = UIColor(hexString: "FF5D47")
        return btn
    }()
    
    let greenButton: CustomColorButton = {
        let btn = CustomColorButton()
        btn.tintColor = UIColor(hexString: "1B8900")
        return btn
    }()
    
    let yellowButton: CustomColorButton = {
        let btn = CustomColorButton()
        btn.tintColor = UIColor(hexString: "E8D420")
        return btn
    }()
    
    let blueButton: CustomColorButton = {
        let btn = CustomColorButton()
        btn.tintColor = UIColor(hexString: "0AB9E1")
        return btn
    }()
    
    lazy var colorStackView: UIStackView = {
        let st = UIStackView()
        st.translatesAutoresizingMaskIntoConstraints = false
        st.axis = .horizontal
        st.distribution = .fillEqually
        st.alignment = .fill
        st.addArrangedSubview(blackButton)
        st.addArrangedSubview(redButton)
        st.addArrangedSubview(greenButton)
        st.addArrangedSubview(yellowButton)
        st.addArrangedSubview(blueButton)
        return st
    }()
    
    lazy var tagStackView: UIStackView = {
        let st = UIStackView()
        st.translatesAutoresizingMaskIntoConstraints = false
        st.axis = .vertical
        st.distribution = .fill
        st.alignment = .fill
        st.addArrangedSubview(tagLabel)
        st.addArrangedSubview(colorStackView)
        return st
    }()

    // MARK: - 캘린더 뷰
    lazy var calendarView: UICalendarView = {
        let cal = UICalendarView()
        cal.translatesAutoresizingMaskIntoConstraints = false
        cal.wantsDateDecorations = true //달력커스텀을 하기위해 설정하는 속성
        cal.backgroundColor = .white
        //cal.isUserInteractionEnabled = true
        cal.calendar = .current
        cal.locale = .current
        
        //달력 그림자
        cal.layer.cornerRadius = 20
        cal.layer.masksToBounds = false
        cal.layer.shadowOffset = CGSize(width: 2, height: 5) //그림자 방향
        cal.layer.shadowColor = UIColor.black.cgColor
        cal.layer.shadowRadius = 2
        cal.layer.shadowOpacity = 0.2
        cal.isHidden = true //처음에는 숨기기
        
        return cal
    }()

    
    
    // MARK: - init

    override init(frame: CGRect) {
        self.colorButtons = [self.blackButton,self.redButton,self.greenButton,self.yellowButton,self.blueButton]
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        self.backgroundColor = .white
        self.addSubview(contView)
        NSLayoutConstraint.activate([
            contView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 40),
            contView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -133),
            contView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            contView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20)
        ])
        
        radioButton.otherButtons = [radioButton2]

        contView.addSubview(radioView)
        radioView.addSubview(radioButton)
        radioView.addSubview(radioButton2)
        
        // MARK: - 라디오버튼..

        if let imageView = radioButton.imageView {
            NSLayoutConstraint.deactivate(imageView.constraints)
        }
        NSLayoutConstraint.activate([
            radioView.topAnchor.constraint(equalTo: contView.topAnchor),
            radioView.heightAnchor.constraint(equalToConstant: 43),
            radioView.leadingAnchor.constraint(equalTo: contView.leadingAnchor, constant: 0),
            radioView.trailingAnchor.constraint(equalTo: contView.trailingAnchor, constant: 0)
        ])
        NSLayoutConstraint.activate([
            //나중에 동적으로 바꿔야할듯..
            radioButton.widthAnchor.constraint(equalToConstant: 100),
            radioButton.leadingAnchor.constraint(equalTo: radioView.leadingAnchor, constant: 40),
            radioButton.centerYAnchor.constraint(equalTo: radioView.centerYAnchor),
            
            radioButton2.widthAnchor.constraint(equalToConstant: 100),
            radioButton2.trailingAnchor.constraint(equalTo: radioView.trailingAnchor, constant: -80),
            radioButton2.centerYAnchor.constraint(equalTo: radioView.centerYAnchor)
        ])
        // MARK: - 재료명

        self.addSubview(componentStackView)
        NSLayoutConstraint.activate([
            componentStackView.leadingAnchor.constraint(equalTo: contView.leadingAnchor),
            componentStackView.trailingAnchor.constraint(equalTo: contView.trailingAnchor),
            componentStackView.topAnchor.constraint(equalTo: radioView.bottomAnchor, constant: 20),
            componentStackView.heightAnchor.constraint(equalToConstant: 84),
            componentTextField.heightAnchor.constraint(equalToConstant: 51)
        ])
        // MARK: - 등록일자, 소비기한

        self.addSubview(registerDateStackView)
        NSLayoutConstraint.activate([
            registerDateStackView.leadingAnchor.constraint(equalTo: contView.leadingAnchor),
            registerDateStackView.widthAnchor.constraint(equalTo: contView.widthAnchor, multiplier: 0.45),
            registerDateStackView.topAnchor.constraint(equalTo: componentStackView.bottomAnchor, constant: 20),
            registerDateStackView.heightAnchor.constraint(equalToConstant: 84),
            registerDateTextField.heightAnchor.constraint(equalToConstant: 51)
        ])
        
        self.addSubview(expirationDateStackView)
        NSLayoutConstraint.activate([
            expirationDateStackView.trailingAnchor.constraint(equalTo: contView.trailingAnchor),
            expirationDateStackView.widthAnchor.constraint(equalTo: contView.widthAnchor, multiplier: 0.45),
            expirationDateStackView.topAnchor.constraint(equalTo: componentStackView.bottomAnchor, constant: 20),
            expirationDateStackView.heightAnchor.constraint(equalToConstant: 84),
            expirationDateTextField.heightAnchor.constraint(equalToConstant: 51)
        ])
        
        // MARK: - 메모 오토레이아웃
        self.addSubview(memoStackView)
        NSLayoutConstraint.activate([
            memoStackView.trailingAnchor.constraint(equalTo: contView.trailingAnchor),
            memoStackView.leadingAnchor.constraint(equalTo: contView.leadingAnchor),
            memoStackView.topAnchor.constraint(equalTo: expirationDateStackView.bottomAnchor, constant: 20),
            memoStackView.heightAnchor.constraint(equalToConstant: 84),
            memoTextField.heightAnchor.constraint(equalToConstant: 51)
        ])
        // MARK: - 태그 색깔 선택
        self.addSubview(tagStackView)
        NSLayoutConstraint.activate([
            tagStackView.topAnchor.constraint(equalTo: memoStackView.bottomAnchor),
            tagStackView.leadingAnchor.constraint(equalTo: contView.leadingAnchor),
            tagStackView.widthAnchor.constraint(equalTo: contView.widthAnchor, multiplier: 0.7),
            tagStackView.heightAnchor.constraint(equalToConstant: 84)
        ])
        
        // MARK: - 달력 뷰 오토레이아웃
        self.addSubview(calendarView)
        NSLayoutConstraint.activate([
            calendarView.leadingAnchor.constraint(equalTo: contView.leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: contView.trailingAnchor),
            calendarView.topAnchor.constraint(equalTo: registerDateStackView.bottomAnchor),
            calendarView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,constant: -70)
        ])
        
        
        //배너뷰는 bottom anchor를 등록해야되나볌
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
