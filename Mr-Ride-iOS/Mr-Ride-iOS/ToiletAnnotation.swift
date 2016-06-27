//
//  CustomAnnotation.swift
//  Mr-Ride-iOS
//
//  Created by Allegretto on 2016/6/27.
//  Copyright © 2016年 AppWorks School Jocy Hsiao. All rights reserved.
//

import UIKit
import MapKit

class ToiletAnnotation: MKPointAnnotation {
    
    var catelog: String
    var address: String
    
    init(catelog: String, address: String){
    self.catelog = catelog
    self.address = address
    }

}
