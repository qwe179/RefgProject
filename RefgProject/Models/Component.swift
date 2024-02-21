//
//  Component.swift
//  RefgProject
//
//  Created by 23 09 on 2024/01/27.
//

import Foundation
protocol ComponentDelegate: AnyObject {
    func addNewComponent(_ component: Component)
    func DeleteComponent(index: Int, _ component: Component)
}


struct Component {
    var refID: String
    var id: String
    var name: String
    var registerDay: String
    var dueDay: String
    var isFreezer: String
    var memo: String
    var tagColor: String
    var coordinates: String

}
