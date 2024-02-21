//
//  RefrigeratorData+CoreDataProperties.swift
//  RefgProject
//
//  Created by 23 09 on 2024/02/20.
//
//

import Foundation
import CoreData


extension RefrigeratorData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RefrigeratorData> {
        return NSFetchRequest<RefrigeratorData>(entityName: "RefrigeratorData")
    }

    @NSManaged public var date: Date?
    @NSManaged public var refID: String?
    @NSManaged public var refName: String?
    @NSManaged public var refType: String?

}

extension RefrigeratorData : Identifiable {

}
