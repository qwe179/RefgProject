//
//  ComponentData+CoreDataProperties.swift
//  
//
//  Created by 23 09 on 2024/01/27.
//
//

import Foundation
import CoreData


extension ComponentData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ComponentData> {
        return NSFetchRequest<ComponentData>(entityName: "ComponentData")
    }

    @NSManaged public var coordinates: String?
    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var refID: String?
    @NSManaged public var tagColor: String?
    @NSManaged public var memo: String?
    @NSManaged public var registerDay: String?
    @NSManaged public var dueDay: String?

}
