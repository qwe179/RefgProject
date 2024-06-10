//
//  ComponentDetailView.swift
//  RefgProject
//
//  Created by 23 09 on 2024/02/01.
//

import UIKit

class ComponentDetailView: UIView {

    // MARK: - 등록일자

    let registerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "등록일자"
        label.textColor = .white
        label.font = UIFont(name: "NotoSansKR-Thin_Bold", size: 12)
        return label
    }()

    let registerDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont(name: "NotoSansKR-Thin_Regular", size: 12)
        label.textColor = .white
        return label
    }()

    lazy var registerDateStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.addArrangedSubview(registerLabel)
        stackView.addArrangedSubview(registerDateLabel)
        return stackView
    }()

    // MARK: - 소비기한
    let expireLabel: UILabel = {
        let label = UILabel()
        label.text = "소비기한"
        label.font = UIFont(name: "NotoSansKR-Thin_Bold", size: 12)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let expireDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont(name: "NotoSansKR-Thin_Regular", size: 12)
        label.textColor = .white
        return label
    }()

    lazy var expireDateStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.addArrangedSubview(expireLabel)
        stackView.addArrangedSubview(expireDateLabel)
        return stackView
    }()
    // MARK: - 메모
    let memoLabel: UILabel = {
        let label = UILabel()
        label.text = "메모"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "NotoSansKR-Thin_Bold", size: 12)
        return label
    }()
    let memoContentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont(name: "NotoSansKR-Thin_Regular", size: 12)
        label.textColor = .white
        return label
    }()

    lazy var memoStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .top
        stackView.addArrangedSubview(memoLabel)
        stackView.addArrangedSubview(memoContentLabel)
        return stackView
    }()

    // MARK: - 재료 삭제 버튼(냉장고맵화면에서)
    let deleteButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("재료 삭제", for: .normal)
        btn.setTitleColor(.red, for: .normal)
        btn.backgroundColor = .white
        btn.titleLabel?.font = UIFont(name: "NotoSansKR-Thin_Regular", size: 12)
        return btn
    }()

    lazy var deleteButtonStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.addArrangedSubview(deleteButton)
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 5
        backgroundColor = UIColor.getCustomColor()
        self.translatesAutoresizingMaskIntoConstraints = false
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUI() {
        self.addSubview(registerDateStackView)
        NSLayoutConstraint.activate([
            registerDateStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            registerDateStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            registerDateStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            registerDateStackView.heightAnchor.constraint(equalToConstant: 17)
        ])

        self.addSubview(expireDateStackView)
        NSLayoutConstraint.activate([
            expireDateStackView.topAnchor.constraint(equalTo: registerDateStackView.bottomAnchor, constant: 10),
            expireDateStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            expireDateStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            expireDateStackView.heightAnchor.constraint(equalToConstant: 17)
        ])

        self.addSubview(memoStackView)
        NSLayoutConstraint.activate([
            memoStackView.topAnchor.constraint(equalTo: expireDateStackView.bottomAnchor, constant: 10),
            memoStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            memoStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
           // memoStackView.heightAnchor.constraint(equalToConstant: 17)
        ])

        self.addSubview(deleteButtonStackView)
        NSLayoutConstraint.activate([
            deleteButtonStackView.topAnchor.constraint(equalTo: memoStackView.bottomAnchor, constant: 10),
            deleteButtonStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            deleteButtonStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            deleteButtonStackView.heightAnchor.constraint(equalToConstant: 25)
        ])
    }

}
