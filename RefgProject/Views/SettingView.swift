//
//  SettingView.swift
//  RefgProject
//
//  Created by 23 09 on 2024/02/08.
//

import UIKit
import GoogleMobileAds

class SettingView: UIView {
    
    let bannerView: GADBannerView = {
        let view = GADBannerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()

    let button: UIButton = {
        let btn = UIButton()
        btn.setTitle("설정", for: .normal)
        btn.titleLabel?.font = UIFont(name: "NotoSansKR-Thin_Medium", size: 20)
        btn.setTitleColor(.black, for: .normal)
        return btn
    }()
    
    // MARK: - 테이블뷰
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isScrollEnabled = false
       // tableView.backgroundColor = .white
        return tableView
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI() 
        self.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupUI() {
        self.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor,constant: 10),
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
