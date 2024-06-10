//
//  MyProducts.swift
//  RefgProject
//
//  Created by 23 09 on 2024/02/21.
//

import Foundation
import StoreKit

typealias ProductsRequestCompletion = (_ success: Bool, _ products: [SKProduct]?) -> Void

protocol IAPServiceType {
  var canMakePayments: Bool { get }

  func getProducts(completion: @escaping ProductsRequestCompletion)
  func buyProduct(_ product: SKProduct)
  func isProductPurchased(_ productID: String) -> Bool
  func restorePurchases()
}

final class IAPService: NSObject, IAPServiceType {

    private let productIDs: Set<String>
    private var purchasedProductIDs: Set<String> = []
    private var productsRequest: SKProductsRequest?
    private var productsCompletion: ProductsRequestCompletion?

    var canMakePayments: Bool {
        SKPaymentQueue.canMakePayments()
    }

    func getProducts(completion: @escaping ProductsRequestCompletion) {
      self.productsRequest?.cancel()
      self.productsCompletion = completion
      self.productsRequest = SKProductsRequest(productIdentifiers: self.productIDs)
      self.productsRequest?.delegate = self
      self.productsRequest?.start()
    }

    func buyProduct(_ product: SKProduct) {
      SKPaymentQueue.default().add(SKPayment(product: product))
    }
    func isProductPurchased(_ productID: String) -> Bool {
      self.purchasedProductIDs.contains(productID)
    }
    func restorePurchases() {
      SKPaymentQueue.default().restoreCompletedTransactions()
    }

    init(productIDs: Set<String>) {
        self.productIDs = productIDs

        super.init()
    }
}

extension IAPService: SKProductsRequestDelegate {
  // didReceive
  func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
    let products = response.products
    self.productsCompletion?(true, products)
    self.clearRequestAndHandler()

    products.forEach { print("Found product: \($0.productIdentifier) \($0.localizedTitle) \($0.price.floatValue)") }
  }

  // failed
  func request(_ request: SKRequest, didFailWithError error: Error) {
    print("Erorr: \(error.localizedDescription)")
    self.productsCompletion?(false, nil)
    self.clearRequestAndHandler()
  }

  private func clearRequestAndHandler() {
    self.productsRequest = nil
    self.productsCompletion = nil
  }
}
