//
//  RestApiProvider.swift
//  AUOpenHouseStudentIOS
//
//  Created by ios-project on 9/6/2561 BE.
//

import Foundation
import Alamofire

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
    
    static func getMyPoints(completion: @escaping (Bool) -> ()) {
        let path = url+"/mygamepoints"
        
        Alamofire.request(path, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success:
                print("API: getMyPoints")
                if let json = response.result.value {
                    print("JSON: \(json)")
                }
                completion(true)
            case .failure(let error):
                print("API Error: getMyPoints", error)
                completion(false)
            }
        }
    }
    
}
