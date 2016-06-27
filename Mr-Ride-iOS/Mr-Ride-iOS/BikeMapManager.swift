//
//  BikeMapManager.swift
//  Mr-Ride-iOS
//
//  Created by Allegretto on 2016/6/16.
//  Copyright © 2016年 AppWorks School Jocy Hsiao. All rights reserved.
//

import Alamofire
import SwiftyJSON

class BikeMapManager{
    static let sharedManager = BikeMapManager()
    var toilets: [BikeToiletModel] = []
    var youbikes: [BikeYouBikeModel] = []
    
    func getToilets(){
        let toiletUrl = "http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=008ed7cf-2340-4bc4-89b0-e258a5573be2"
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND,0)){
            Alamofire.request(.GET, toiletUrl).validate().responseData {result in
                switch result.result{
                case .Success(let data):
                    let json = JSON(data: data)
                    for(_, subJSON) in json["result"]["results"]{
                        do{
                            let toilet = try BikeToiletModelHelper().parse(json: subJSON)
                            self.toilets.append(toilet)
                        }catch(let error){
                            print(error)
                        }
                        //                        success(toilets: toilets)
                      
                    }
//                    return toilets
                case .Failure(let err):
                    print(err)
                }
                
            }
        }
    }
    
    func getYouBikes(){
        let youbikeUrl = "http://data.taipei/youbike"
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT,0)){
            Alamofire.request(.GET, youbikeUrl).validate().responseData{result in
                switch result.result{
                case .Success(let data):
                    let json = JSON(data: data)
                    for(_, subJSON) in json["data"]{
                        
                        do{
                            let youbike = try BikeYouBikeModelHelper().parse(json: subJSON)
                            self.youbikes.append(youbike)
                        }catch(let error){
                            print(error)
                            
                        }
                    }
                case .Failure(let err):
                    print(err)
                }
                
            }
            
        }
        
    }
    
    
}

