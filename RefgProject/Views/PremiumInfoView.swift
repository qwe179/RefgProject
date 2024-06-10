//
//  PremiumInfoView.swift
//  RefgProject
//
//  Created by 23 09 on 2024/02/08.
//

import UIKit

class PremiumInfoView: UIView {

    let mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "유료 버전 안내"
        label.font = UIFont(name: "NotoSansKR-Thin_Bold", size: 20)
        label.textColor = .black
        return label
    }()

    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text =
        """
        냉장고맵을 이용해주셔서 감사합니다!🤩
        월 1,200원으로 광고를 제거하고 여러대의 냉장고를 추가하여 김치냉장고 혹은 실내에 보관하는 식재료까지 관리할 수 있어요.
        앞으로 더욱 많은 업데이트가 예정되어 있으니 기대해주세요.
        """
        label.numberOfLines = 0
        label.font = UIFont(name: "NotoSansKR-Thin_Regular", size: 12)
        label.textColor = .black
        return label
    }()
    // MARK: - 광고제거 버튼

    let removeOnlyAdButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor(red: 0.23, green: 0.70, blue: 0.46, alpha: 1.0)
      //  button.setTitle("광고만제거- 월 결제                          900₩", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "NotoSansKR-Thin_Regular", size: 14)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 20
        let originalTitle = "광고만제거- 월 결제                                   ₩900"

        // NSMutableAttributedString 생성
          let attributedString = NSMutableAttributedString(string: originalTitle)

          // 마지막 글자에 대한 범위 설정
          let lastCharacterRange = NSRange(location: originalTitle.count - 5, length: 5)

          // 마지막 글자에 대한 속성 설정 (예: Bold)
          attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 14), range: lastCharacterRange)

          // 버튼에 NSAttributedString을 설정
          button.setAttributedTitle(attributedString, for: .normal)
        return button
    }()

    let premiumButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor(red: 0.23, green: 0.70, blue: 0.46, alpha: 1.0)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "NotoSansKR-Thin_Regular", size: 14)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 20

        let originalTitle = "유료버전결제 - 월 결제                                      ₩1,200"
        // NSMutableAttributedString 생성
          let attributedString = NSMutableAttributedString(string: originalTitle)

          // 마지막 글자에 대한 범위 설정
          let lastCharacterRange = NSRange(location: originalTitle.count - 5, length: 5)

          // 마지막 글자에 대한 속성 설정 (예: Bold)
          attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 14), range: lastCharacterRange)

          // 버튼에 NSAttributedString을 설정
          button.setAttributedTitle(attributedString, for: .normal)
        return button
    }()

    lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 20
        stackView.distribution = .fillEqually
      //  stackView.addArrangedSubview(removeOnlyAdButton)
        stackView.addArrangedSubview(premiumButton)
        return stackView
    }()

    let bilLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text =
        """
        구독 확정 시 iTuens 계정에 적용됩니다. 구독은 현재 기간이 끝나기 전에 취소되지 않으면 자동으로 갱신됩니다. iTuens 계정 설정에서 언제든지 취소할 수 있습니다.

        개인정보 취급방침
        URL:

        이용 약관(EULA)
        URL
        """
        label.numberOfLines = 0
        label.font = UIFont(name: "NotoSansKR-Thin_Regular", size: 12)
        label.textColor = .gray
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUI() {

        self.addSubview(mainLabel)
        NSLayoutConstraint.activate([
            mainLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 21),
            mainLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            mainLabel.heightAnchor.constraint(equalToConstant: 60)
        ])

        self.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 40),
            descriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 90)
        ])

        self.addSubview(buttonStackView)

        NSLayoutConstraint.activate([
            buttonStackView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            buttonStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            buttonStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24),
            buttonStackView.heightAnchor.constraint(equalToConstant: 48)
        ])

        self.addSubview(bilLabel)
        NSLayoutConstraint.activate([
            bilLabel.topAnchor.constraint(equalTo: buttonStackView.bottomAnchor, constant: 20),
            bilLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            bilLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24)
        ])
    }

    func settingView(_ view: UIView) {
        view.backgroundColor = .white
        view.addSubview(self)
        self.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        self.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
