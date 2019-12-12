//
//  Entity+CoreDataProperties.swift
//  Hilo-iwatch-1 WatchKit Extension
//
//  Created by ZHONG Sailin on 09.12.19.
//  Copyright © 2019 ZHONG Sailin. All rights reserved.
//
//

import Foundation
import CoreData


extension Entity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entity> {
        return NSFetchRequest<Entity>(entityName: "Entity")
    }

    @NSManaged public var isP0UserReacted: Bool
    @NSManaged public var isP1UserReacted: Bool
    @NSManaged public var isP2UserReacted: Bool

}
