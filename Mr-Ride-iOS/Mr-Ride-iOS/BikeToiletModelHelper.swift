//
//  BikeToiletModelHelper.swift
//  Mr-Ride-iOS
//
//  Created by Allegretto on 2016/6/16.
//  Copyright © 2016年 AppWorks School Jocy Hsiao. All rights reserved.
//

import CoreLocation
import SwiftyJSON

struct BikeToiletModelHelper { }

extension BikeToiletModelHelper{
    
    struct JSONKey {
        static let Catelog = "類別"
        static let Name = "單位名稱"
        static let Address = "地址"
        static let Longitude = "經度"
        static let Latitude = "緯度"
    }
    
    enum JSONError: ErrorType { case MissingCatelog, MissingName, MissingAddress, MissingLatitude, MissingLongitude}
    
    func parse(json json: JSON) throws -> BikeToiletModel{
        
        guard let catelog = json[JSONKey.Catelog].string else{
            throw JSONError.MissingCatelog
        }
        
        guard let name = json[JSONKey.Name].string else{
            throw JSONError.MissingName
        }
        
        guard let address = json[JSONKey.Address].string else{
            throw JSONError.MissingAddress
        }
        
        let numberFormatter = NSNumberFormatter()
        guard let longitudeString = json[JSONKey.Longitude].string else{
            throw JSONError.MissingLongitude
        }
        let longitude = numberFormatter.numberFromString(longitudeString) as? Double ?? 0.0
        
        guard let latitudeString = json[JSONKey.Latitude].string else{
            throw JSONError.MissingLatitude
        }
        let latitude = numberFormatter.numberFromString(latitudeString) as? Double ?? 0.0
        
        
        let toilet = BikeToiletModel(catelog: catelog, name: name, address: address,
                                     coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
        
        return toilet
    }
    
    
    
}
