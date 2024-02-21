//
//  MemoView.swift
//  RefgProject
//
//  Created by 23 09 on 2024/02/06.
//

import UIKit
import GoogleMobileAds

class MemoView: UIView {
    
    let bannerView: GADBannerView = {
        let view = GADBannerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    let button: UIButton = {
        let btn = UIButton()
        btn.setTitle("메모", for: .normal)
        btn.titleLabel?.font = UIFont(name: "NotoSansKR-Thin_Medium", size: 20)
        btn.setTitleColor(.black, for: .normal)
        return btn
    }()
    
    let plusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "add_circle.png"), for: .normal)
        return button
    }()
    
    // MARK: - 테이블뷰
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.showsVerticalScrollIndicator = false
        // MARK: - 테이블뷰 라인 틀어졌을 경우에 마진 설정해줘야함
        tableView.separatorInset.left = 30
        tableView.separatorInset.right = 30
        return tableView
    }()
    
    // MARK: - 서치바

    lazy var searchBar : UISearchBar = {
        let search = UISearchBar()
        search.translatesAutoresizingMaskIntoConstraints = false
        search.searchBarStyle = .minimal
        search.showsCancelButton = false
        search.searchTextField.backgroundColor = .clear
        search.searchTextField.borderStyle = .none
        search.placeholder = "검색"
        search.layer.borderColor = UIColor(hexString: "3CB175").cgColor
        search.layer.cornerRadius = 10
        search.layer.borderWidth = 1.0
        return search
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
        self.addSubview(searchBar)
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor,constant: 4),
            searchBar.leadingAnchor.constraint(equalTo: self.leadingAnchor , constant: 10),
            searchBar.trailingAnchor.constraint(equalTo: self.trailingAnchor , constant: -10),
            searchBar.heightAnchor.constraint(equalToConstant: 40),
        ])
        
        self.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor,constant: 0),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor , constant: 0),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor , constant: 0),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant:  -30)
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
