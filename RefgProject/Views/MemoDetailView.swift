//
//  MemoDetailView.swift
//  RefgProject
//
//  Created by 23 09 on 2024/02/06.
//

import UIKit
import GoogleMobileAds

class MemoDetailView: UIView {
    
    let bannerView: GADBannerView = {
        let view = GADBannerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    

    
    let saveButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("저장", for: .normal)
        btn.setTitleColor(UIColor(hexString: "3CB175"), for: .normal)
        return btn
    }()
    
    let memoTextField: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
//        tv.contentVerticalAlignment = .top
        tv.font = UIFont(name: "NotoSansKR-Thin_Regular", size: 16)
        return tv
    }()


    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
        self.backgroundColor = .white
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    
    func setupConstraints() {
        self.addSubview(memoTextField)
        NSLayoutConstraint.activate([
            memoTextField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 40),
            memoTextField.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -168),
            memoTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            memoTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20)
        ])
        
        //배너뷰는 bottom anchor를 등록해야되나볌
        self.addSubview(bannerView)
        NSLayoutConstraint.activate([
            bannerView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            bannerView.heightAnchor.constraint(equalToConstant: GADAdSizeBanner.size.height),
            bannerView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -52),
            bannerView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
        
        if IsPremium.isPremium == true {
            self.bannerView.removeFromSuperview()
        }
        
    }
    
}
