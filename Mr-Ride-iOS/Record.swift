//
//  Record.swift
//  Mr-Ride-iOS
//
//  Created by Allegretto on 2016/6/3.
//  Copyright © 2016年 AppWorks School Jocy Hsiao. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation


class Record: NSManagedObject {
    
    class func add(moc: NSManagedObjectContext, date: NSDate, distance: Double, duration: Double, routes: [CLLocation]){
        let record = NSEntityDescription.insertNewObjectForEntityForName("Record", inManagedObjectContext: moc) as! Record
        record.date = date
        record.distance = distance
        record.duration = duration
        
        var savedLocations = [Route]()
        for location in routes{
            let savedLocation = NSEntityDescription.insertNewObjectForEntityForName("Route", inManagedObjectContext: moc) as! Route
            savedLocation.created = location.timestamp
            savedLocation.latitude = location.coordinate.latitude
            savedLocation.longitude = location.coordinate.longitude
            savedLocations.append(savedLocation)
        }
        record.routes = NSOrderedSet(array: savedLocations)
        do{
            try moc.save()
        }catch{
            fatalError("Failure to save context \(error)")
        }
    }
    
    class func getAll(moc: NSManagedObjectContext) -> [Record]{
        let request = NSFetchRequest(entityName: "Record")
        do{
            return try moc.executeFetchRequest(request) as! [Record]
        }catch{
            fatalError("Failed to fetch data: \(error)")
        }
        
    }
}
