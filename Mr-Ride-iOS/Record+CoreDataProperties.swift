//
//  Record+CoreDataProperties.swift
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

extension Record {

    @NSManaged var date: NSDate?
    @NSManaged var distance: NSNumber?
    @NSManaged var duration: NSNumber?
    @NSManaged var routes: NSOrderedSet?
    
    var dateForSection: String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMMM, YYYY"
        dateFormatter.timeZone = NSTimeZone(name: "CST")
        let sectionName = dateFormatter.stringFromDate(date!)
        return sectionName
    }


}
