//
//  ComponentData+CoreDataProperties.swift
//  RefgProject
//
//  Created by 23 09 on 2024/02/20.
//
//

import Foundation
import CoreData


extension ComponentData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ComponentData> {
        return NSFetchRequest<ComponentData>(entityName: "ComponentData")
    }

    @NSManaged public var coordinates: String?
    @NSManaged public var dueDay: Date?
    @NSManaged public var id: String?
    @NSManaged public var isFreezer: String?
    @NSManaged public var memo: String?
    @NSManaged public var name: String?
    @NSManaged public var refID: String?
    @NSManaged public var registerDay: Date?
    @NSManaged public var tagColor: String?

}

extension ComponentData : Identifiable {

}
