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
    
    struct Response {
        let isSuccess: Bool
        let message: String
    }
    
    static func login(idToken: String, completion: @escaping (Response) -> ()) {
        let path = url+"/login"
        
        let parameters: Parameters = [
            "idToken": idToken
        ]
        
        Alamofire.request(path, method: .put, parameters: parameters).validate().responseJSON { response in
            switch response.result {
            case .success(let json):
                print("API: login")
                
                let json = JSON(json)
                let isSuccess = json["isSuccess"].bool
                let message = json["message"].string
                
                completion(Response(isSuccess: isSuccess!, message: message!))
                
            case .failure(let error):
                print("API Error: login", error)
                completion(Response(isSuccess: false, message: "Could not connect to server"))
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
                
                // remove old coredata
                PresistenceService.deleteFaculties()
                
                var tempF = [Faculty]()
                
                if let json = JSON(json).array {
                    for j in json {
                        let f = Faculty(context: PresistenceService.context)
                        
                        if let fid = j["FID"].int32 {
                            f.fid = fid
                            
                            // if got fid then get the majors in this faculty
                            getMajorsInFaculty(fid: Int(fid), completion: { (s, majors) in
                                if s {
                                    for m in majors {
                                        f.addToMajors(m)
                                    }
                                }
                            })
                        }
                        if let icon = j["Icon"].url {
                            f.icon = icon
                        }
                        if let info = j["Info"].string {
                            f.info = info
                        }
                        if let lat = j["Location_Latitude"].double {
                            f.location_latitude = lat
                        }
                        if let lon = j["Location_Longitude"].double {
                            f.location_longitude = lon
                        }
                        if let name = j["Name"].string {
                            f.name = name
                        }
                        if let web = j["Website"].url {
                            f.website = web
                        }
                        
                        // TODO - save core data
                        PresistenceService.saveContext()
                        tempF.append(f)
                    }
                    
                    completion(true, tempF)
                }
                
            case .failure(let error):
                print("API Error: getFaculties", error)
                completion(false, PresistenceService.loadFaculties())
            }
        }
    }
    
    static func getMajorsInFaculty(fid:Int, completion: @escaping (Bool,[Major]) -> ()) {
        let path = url+"/faculties/\(fid)/majors"
        
        Alamofire.request(path, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let json):
                print("API: getMajorsInFaculty")
                
                var tempM = [Major]()
                
                if let json = JSON(json).array {
                    for j in json {
                        let m = Major(context: PresistenceService.context)
                        
                        if let fid = j["FID"].int32 {
                            m.fid = fid
                        }
                        if let info = j["Info"].string {
                            m.info = info
                        }
                        if let mid = j["MID"].int32 {
                            m.mid = mid
                        }
                        if let name = j["Name"].string {
                            m.name = name
                        }
                        if let web = j["Website"].url {
                            m.website = web
                        }
                        
                        tempM.append(m)
                    }
                    
                    completion(true, tempM)
                }
                
            case .failure(let error):
                print("API Error: getMajorsInFaculty", error)
                completion(false, [Major]())
            }
        }
    }
    
    static func getUpEvents(completion: @escaping (Bool,[Event]) -> ()) {
        let path = url+"/upevents"
        
        Alamofire.request(path, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let json):
                print("API: getUpEvents")
                
                var tempE = [Event]()
                
                if let json = JSON(json).array {
                    for j in json {
                        let e = Event(context: PresistenceService.context)
                        
                        if let eid = j["EID"].int32 {
                            e.eid = eid
                        }
                        if let fid = j["FID"].int32 {
                            e.fid = fid
                        }
                        if let faculty_name = j["Faculty_Name"].string {
                            e.faculty_name = faculty_name
                        }
                        if let icon = j["Icon"].url {
                            e.icon = icon
                        }
                        if let image = j["Image"].url {
                            e.image = image
                        }
                        if let info = j["Info"].string {
                            e.info = info
                        }
                        if let lat = j["Location_Latitude"].double {
                            e.location_latitude = lat
                        }
                        if let lon = j["Location_Longitude"].double {
                            e.location_longitude = lon
                        }
                        if let mid = j["MID"].int32 {
                            e.mid = mid
                        }
                        if let name = j["Major_Name"].string {
                            e.major_name = name
                        }
                        if let name = j["Name"].string {
                            e.name = name
                        }
                        if let state = j["State"].int16 {
                            e.state = state
                        }
                        if let tid = j["TID"].int32 {
                            e.tid = tid
                        }
                        if let time_start = j["Time_Start"].string {
                            e.time_start = time_start
                        }
                        if let time_end = j["Time_End"].string {
                            e.time_end = time_end
                        }
                        
                        // print(e)
                        // TODO - save core data
                        // PresistenceService.saveContext()
                        tempE.append(e)
                    }
                    
                    completion(true, tempE)
                }
                
            case .failure(let error):
                print("API Error: getUpEvents", error)
                completion(false, [Event]())
            }
        }
    }
    
    static func getMyEvents(completion: @escaping (Bool,[Event]) -> ()) {
        let path = url+"/myevents"
        
        Alamofire.request(path, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let json):
                print("API: getMyEvents")
                
                var tempE = [Event]()
                
                if let json = JSON(json).array {
                    for j in json {
                        let e = Event(context: PresistenceService.context)
                        
                        if let eid = j["EID"].int32 {
                            e.eid = eid
                        }
                        if let fid = j["FID"].int32 {
                            e.fid = fid
                        }
                        if let faculty_name = j["Faculty_Name"].string {
                            e.faculty_name = faculty_name
                        }
                        if let icon = j["Icon"].url {
                            e.icon = icon
                        }
                        if let image = j["Image"].url {
                            e.image = image
                        }
                        if let info = j["Info"].string {
                            e.info = info
                        }
                        if let lat = j["Location_Latitude"].double {
                            e.location_latitude = lat
                        }
                        if let lon = j["Location_Longitude"].double {
                            e.location_longitude = lon
                        }
                        if let mid = j["MID"].int32 {
                            e.mid = mid
                        }
                        if let name = j["Major_Name"].string {
                            e.major_name = name
                        }
                        if let name = j["Name"].string {
                            e.name = name
                        }
                        if let state = j["State"].int16 {
                            e.state = state
                        }
                        if let tid = j["TID"].int32 {
                            e.tid = tid
                        }
                        if let time_start = j["Time_Start"].string {
                            e.time_start = time_start
                        }
                        if let time_end = j["Time_End"].string {
                            e.time_end = time_end
                        }
                        
                        // print(e)
                        // TODO - save core data
                        // PresistenceService.saveContext()
                        tempE.append(e)
                    }
                    
                    completion(true, tempE)
                }
                
            case .failure(let error):
                print("API Error: getMyEvents", error)
                // completion(false, PresistenceService.loadMyEvents())
                completion(false, [Event]())
            }
        }
    }
    
    static func checkMyEventAttend(tid: Int32, completion: @escaping (Bool, Bool) -> ()) {
        let path = url+"/myevents/\(tid)"
        
        Alamofire.request(path, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let json):
                print("API: checkMyEventAttend")
                
                if let json = JSON(json).array {
                    
                    if json.count == 0 {
                        completion(true, false)
                    }else{
                        completion(true,true)
                    }
                    
                }
                
            case .failure(let error):
                print("API Error: checkMyEventAttend", error)
                completion(false,false)
            }
        }
    }
    
    static func joinEvent(tid: Int32, completion: @escaping (Response) -> ()) {
        let path = url+"/myevents/\(tid)"
        
        Alamofire.request(path, method: .post).validate().responseJSON { response in
            switch response.result {
            case .success(let json):
                print("API: joinEvent")
                
                let json = JSON(json)
                let isSuccess = json["isSuccess"].bool
                let message = json["message"].string
                
                completion(Response(isSuccess: isSuccess!, message: message!))
                
            case .failure(let error):
                print("API Error: joinEvent", error)
                completion(Response(isSuccess: false, message: "Could not connect to server"))
            }
        }
    }
    
    static func leaveEvent(tid: Int32, completion: @escaping (Response) -> ()) {
        let path = url+"/myevents/\(tid)"
        
        Alamofire.request(path, method: .delete).validate().responseJSON { response in
            switch response.result {
            case .success(let json):
                print("API: leaveEvent")
                
                let json = JSON(json)
                let isSuccess = json["isSuccess"].bool
                let message = json["message"].string
                
                completion(Response(isSuccess: isSuccess!, message: message!))
                
            case .failure(let error):
                print("API Error: leaveEvent", error)
                completion(Response(isSuccess: false, message: "Could not connect to server"))
            }
        }
    }
    
    
    
}
