//
//  SortingPopUpViewController.swift
//  RefgProject
//
//  Created by 23 09 on 2024/02/05.
//

import UIKit

class SortingPopUpViewController: UIViewController {
    
    weak var delegate: ModalPopUpDelegate?
    var sortingType: String?
    
    let registerSortingButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("최근 등록 순", for: .normal)
        btn.titleLabel?.font = UIFont(name: "NotoSansKR-Thin_Regular", size: 16)
        btn.setTitleColor(.black, for: .normal)
        btn.contentHorizontalAlignment = .left //버튼 왼쪽정렬
        btn.backgroundColor = .white
        return btn
    }()
    let expireSortingButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("소비기한 적게 남은 순", for: .normal)
        btn.titleLabel?.font = UIFont(name: "NotoSansKR-Thin_Regular", size: 16)
        btn.setTitleColor(.black, for: .normal)
        btn.contentHorizontalAlignment = .left //버튼 왼쪽정렬
        btn.backgroundColor = .white
        return btn
    }()
    //NotoSansKR-Thin_Regular
    let nameSortingButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("식재료 이름(ㄱ-ㅎ)", for: .normal)
        btn.titleLabel?.font = UIFont(name: "NotoSansKR-Thin_Regular", size: 16)
        btn.setTitleColor(.black, for: .normal)
        btn.contentHorizontalAlignment = .left //버튼 왼쪽정렬
        btn.backgroundColor = .white
        return btn
    }()
    lazy var stackView:UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.distribution = .fillEqually
        sv.alignment = .fill
        sv.addArrangedSubview(registerSortingButton)
        sv.addArrangedSubview(expireSortingButton)
        sv.addArrangedSubview(nameSortingButton)
        sv.backgroundColor = .white
        return sv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addTargets()
        setButtonText()
    }
    
    func setButtonText() {
        if let sortType = self.sortingType {
            if sortType == "dueDay" {
                expireSortingButton.setTitleColor(UIColor(hexString: "3CB175"), for: .normal)
            } else {
                nameSortingButton.setTitleColor(UIColor(hexString: "3CB175"), for: .normal)
            }
        }
        else {
            registerSortingButton.setTitleColor(UIColor(hexString: "3CB175"), for: .normal)
        }
        
    }
    
    func setupUI() {
        self.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.backgroundColor = .white
        sheetPresentationController?.preferredCornerRadius = 30
        
        self.view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -24),
            stackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20)
        ])

    }
    
    func addTargets() {
        registerSortingButton.addTarget(self, action: #selector(registerSortingButtonTapped), for: .touchUpInside)
        expireSortingButton.addTarget(self, action: #selector(expireSortingButtonTapped), for: .touchUpInside)
        nameSortingButton.addTarget(self, action: #selector(nameSortingButtonTapped), for: .touchUpInside)
    }
    @objc func registerSortingButtonTapped() {
        delegate?.setupSortingType(sortType: nil)
        delegate?.reloadTableView()
        dismiss(animated: true, completion: {})
    }
    @objc func expireSortingButtonTapped() {
        delegate?.setupSortingType(sortType: "dueDay")
        delegate?.reloadTableView()
        dismiss(animated: true, completion: {})
    }
    @objc func nameSortingButtonTapped() {
        delegate?.setupSortingType(sortType: "name")
        delegate?.reloadTableView()
        dismiss(animated: true, completion: {})
    }
    
    
    




}
