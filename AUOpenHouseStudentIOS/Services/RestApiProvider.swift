//
//  RestApiProvider.swift
//  AUOpenHouseStudentIOS
//
//  Created by ios-project on 9/6/2561 BE.
//

import Foundation
import Alamofire
import SwiftyJSON

class RestApiProvider {
    
    static let url = "https://auopenhouse.herokuapp.com/api/student"
    
    static func login(idToken: String, completion: @escaping (Bool) -> ()) {
        let path = url+"/login"
        
        let parameters: Parameters = [
            "idToken": idToken
        ]
        
        Alamofire.request(path, method: .put, parameters: parameters).validate().responseJSON { response in
            switch response.result {
            case .success:
                print("API: login")
                completion(true)
            case .failure(let error):
                print("API Error: login", error)
                completion(false)
            }
        }
    }
    
    static func logout(completion: @escaping (Bool) -> ()) {
        let path = url+"/logout"
        
        Alamofire.request(path, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success:
                print("API: logout")
                completion(true)
            case .failure(let error):
                print("API Error: logout", error)
                completion(false)
            }
        }
    }
    
    static func temp(completion: @escaping (Bool) -> ()) {
        
    }
    
    static func getMyPoints(completion: @escaping (Bool,Int) -> ()) {
        let path = url+"/mygamepoints"
        
        Alamofire.request(path, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let json):
                print("API: getMyPoints")
                               
                var json = JSON(json)
                
                if let points = json[0]["Points"].int {
                    completion(true,points)
                }else{
                    completion(true,0)
                }
                
            case .failure(let error):
                print("API Error: getMyPoints", error)
                completion(false,0)
            }
        }
    }
    
    static func getFaculties(completion: @escaping (Bool,[Faculty]) -> ()) {
        let path = url+"/faculties"
        
        Alamofire.request(path, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let json):
                print("API: getFaculties")
                
                var tempF = [Faculty]()
                
                if let json = JSON(json).array {
                    for j in json {
                        let f = Faculty(context: PresistenceService.context)
                        
                        if let fid = j["FID"].int32 {
                            f.fid = fid
                        }
                        if let icon = j["Icon"].url {
                            f.icon = icon
                        }
                        if let info = j["Info"].string {
                            f.info = info
                        }
                        if let lat = j["Location_Latitude"].float {
                            f.location_latitude = lat
                        }
                        if let lon = j["Location_Longitude"].float {
                            f.location_longitude = lon
                        }
                        if let name = j["Name"].string {
                            f.name = name
                        }
                        if let web = j["Website"].url {
                            f.website = web
                        }
                        
                        // print(f)
                        // TODO - save core data
                        // PresistenceService.saveContext()
                        tempF.append(f)
                    }
                    
                    completion(true, tempF)
                }
                
            case .failure(let error):
                print("API Error: getFaculties", error)
                completion(false, [Faculty]())
            }
        }
    }
    
}
