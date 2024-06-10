//
//  MyProducts.swift
//  RefgProject
//
//  Created by 23 09 on 2024/02/21.
//
import Foundation

enum MyProducts {

    static let productID = "com.refrigeratormap.comong"
    static let iapService: IAPServiceType = IAPService(productIDs: Set<String>([productID]))
    static func getResourceProductName(_ id: String) -> String? {
        id.components(separatedBy: ".").last
    }
}
