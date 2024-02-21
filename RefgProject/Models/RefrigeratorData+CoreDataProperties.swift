//
//  RefrigeratorData+CoreDataProperties.swift
//  
//
//  Created by 23 09 on 2024/01/27.
//
//

import Foundation
import CoreData


extension RefrigeratorData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RefrigeratorData> {
        return NSFetchRequest<RefrigeratorData>(entityName: "RefrigeratorData")
    }

    @NSManaged public var refID: String?
    @NSManaged public var refName: String?
    @NSManaged public var refType: String?

}
