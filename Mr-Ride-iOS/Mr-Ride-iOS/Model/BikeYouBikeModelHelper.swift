//
//  BikeYouBikeModelHelper.swift
//  Mr-Ride-iOS
//
//  Created by Allegretto on 2016/6/24.
//  Copyright © 2016年 AppWorks School Jocy Hsiao. All rights reserved.
//

import CoreLocation
import SwiftyJSON

struct BikeYouBikeModelHelper{}

extension BikeYouBikeModelHelper{
    struct JSONKey{
        static let Name = "sna"
        static let Area = "sarea"
        static let AvailableYB = "sbi"
        static let Address = "ar"
        static let Longitude = "lng"
        static let Latitude = "lat"
    }
    enum JSONError: ErrorType { case MissingName, MissingArea, MissingAvailableYB, MissingAddress, MissingLatitude, MissingLongitude}
    
    func parse(json json: JSON) throws -> BikeYouBikeModel{
        
        guard let name = json[JSONKey.Name].string else{
            throw JSONError.MissingName
        }
        
        guard let area = json[JSONKey.Area].string else{
            throw JSONError.MissingArea
        }
        
        guard let address = json[JSONKey.Address].string else{
            throw JSONError.MissingAddress
        }
        
        let numberFormatter = NSNumberFormatter()
        
        guard let availableYBString = json[JSONKey.AvailableYB].string else{
            throw JSONError.MissingAvailableYB
        }
        let availableYB = numberFormatter.numberFromString(availableYBString) as? Int ?? 0
        
        guard let longitudeString = json[JSONKey.Longitude].string else{
            throw JSONError.MissingLongitude
        }
        let longitude = numberFormatter.numberFromString(longitudeString) as? Double ?? 0.0
        
        guard let latitudeString = json[JSONKey.Latitude].string else{
            throw JSONError.MissingLatitude
        }
        let latitude = numberFormatter.numberFromString(latitudeString) as? Double ?? 0.0
        
        
        let youbike = BikeYouBikeModel(name: name, area: area, availableYB: availableYB, coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), address: address)
        
        return youbike
    }
    
    
    
}
