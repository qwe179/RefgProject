//
//  CustomPopup.swift
//  RefgProject
//
//  Created by 23 09 on 2024/02/05.
//

import Foundation

protocol  ModalPopUpDelegate: AnyObject {
    func  setupSortingType (sortType: String? )
    func reloadTableView()
}
