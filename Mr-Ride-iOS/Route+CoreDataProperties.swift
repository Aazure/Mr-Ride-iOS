//
//  Route+CoreDataProperties.swift
//  Mr-Ride-iOS
//
//  Created by Allegretto on 2016/6/3.
//  Copyright © 2016年 AppWorks School Jocy Hsiao. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Route {

    @NSManaged var created: NSDate?
    @NSManaged var latitude: NSNumber?
    @NSManaged var longitude: NSNumber?
    @NSManaged var record: Record?

}
