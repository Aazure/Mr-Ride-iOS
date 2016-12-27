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
    
    // MARK: - Public Toilets Data
    func getToilets(completion:[BikeToiletModel] -> Void){
        let toiletUrl = "http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=008ed7cf-2340-4bc4-89b0-e258a5573be2"
        
        if toilets.count > 0{
            completion(self.toilets)
            return
        }
        Alamofire.request(.GET, toiletUrl, encoding: .JSON).validate().responseData {result in
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
                }
                dispatch_async(dispatch_get_main_queue()){
                    completion(self.toilets)
                }
            case .Failure(let err):
                print(err)
            }
            
        }
    }
    
     // MARK: - Youbike Stations Data
    func getYouBikes(completion: [BikeYouBikeModel] -> Void){
        let youbikeUrl = "http://data.taipei/youbike"
        Alamofire.request(.GET, youbikeUrl, encoding: .JSON).validate().responseData{result in
            switch result.result{
            case .Success(let data):
                let json = JSON(data: data)
                for(_, subJSON) in json["retVal"]{
                    
                    do{
                        let youbike = try BikeYouBikeModelHelper().parse(json: subJSON)
                        self.youbikes.append(youbike)
                    }catch(let error){
                        print(error)
                        
                    }
                }
                dispatch_async(dispatch_get_main_queue()){
                    completion(self.youbikes)
                }
            case .Failure(let err):
                print(err)
            }
            
        }
        
    }
    
    
}



