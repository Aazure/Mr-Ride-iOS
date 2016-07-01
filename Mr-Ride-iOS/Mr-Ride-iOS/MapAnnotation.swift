//
//  MapAnnotation.swift
//  Mr-Ride-iOS
//
//  Created by Allegretto on 2016/7/1.
//  Copyright © 2016年 AppWorks School Jocy Hsiao. All rights reserved.
//

import Foundation
import MapKit

class MapAnnotation: MKPointAnnotation {
    
    var type: String?
    var catelog: String?
    var address: String?
    
    init(type: String, catelog: String, address: String){
        self.type = type
        self.catelog = catelog
        self.address = address
    }
    
}

