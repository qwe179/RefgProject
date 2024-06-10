//
//  PremiumInfoViewController.swift
//  RefgProject
//
//  Created by 23 09 on 2024/02/08.
//

import UIKit
import StoreKit

class PremiumInfoViewController: UIViewController {

    let premiumInfoView = PremiumInfoView()
    private var products = [SKProduct]()
    private let productOrder: [String] = [
        MyProducts.productID
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        settingView()
        loadProductsInfo()
    }

    func settingView() {
        premiumInfoView.settingView(self.view)
        sheetPresentationController?.preferredCornerRadius = 30
        premiumInfoView.premiumButton.addTarget(self, action: #selector(premiumButtonTapped), for: .touchUpInside)
    }
    func loadProductsInfo() {
        MyProducts.iapService.getProducts { [weak self] success, products in
          print("load products \(products ?? [])")
          guard let ss = self else { return }
          if success, let products = products {
            DispatchQueue.main.async {
                print("성공")
            }
          }
        }
    }

    @objc func premiumButtonTapped() {
        guard let product = self.products.first else { return }
        MyProducts.iapService.buyProduct(product)
    }

}
