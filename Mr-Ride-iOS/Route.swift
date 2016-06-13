//
//  Route.swift
//  Mr-Ride-iOS
//
//  Created by Allegretto on 2016/6/3.
//  Copyright © 2016年 AppWorks School Jocy Hsiao. All rights reserved.
//

import Foundation
import CoreData


class Route: NSManagedObject {
    
    class func add(moc: NSManagedObjectContext, created: NSDate, latitude: Double, longitude: Double){
        let route = NSEntityDescription.insertNewObjectForEntityForName("Route", inManagedObjectContext: moc) as! Route
        route.created = created
        route.latitude = latitude
        route.longitude = longitude
        
    }
    
    class func getAllLocation(moc: NSManagedObjectContext) -> [Route]{
        let request = NSFetchRequest(entityName: "Route")
        do{
            return try moc.executeFetchRequest(request) as! [Route]
        }catch{
            fatalError("Failed to fetch data: \(error)")
        }
        
    }

}
