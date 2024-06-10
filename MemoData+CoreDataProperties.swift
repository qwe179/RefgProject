//
//  MemoData+CoreDataProperties.swift
//  RefgProject
//
//  Created by 23 09 on 2024/02/20.
//
//

import Foundation
import CoreData

extension MemoData: Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MemoData> {
        return NSFetchRequest<MemoData>(entityName: "MemoData")
    }

    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var isEdit: Bool
    @NSManaged public var memo: String?

}
