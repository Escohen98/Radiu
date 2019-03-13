//
//  Comment.swift
//  Radiu
//
//  Created by Conor Reiland on 3/10/19.
//  Copyright © 2019 University of Washington. All rights reserved.
//

import Foundation
import Alamofire

class Repository{
    
    static var sessionManager = SessionManager()
    
    //static var currentComments : [Comment] = [Comment(text: "test comment", image: profileImageView!, username:"username"), Comment(text: "test comment", image: profileImageView!, username:"username"), Comment(text: "test comment", image: profileImageView!, username:"username")]
    
    //static var sessionManager = Alamofire.SessionManager.default
    
    class func beginSession(token: String){
        self.sessionManager.adapter = AccessTokenAdapter(accessToken: token)
    }

//    class func getComments() -> [Comment]{
//        return self.currentComments
//    }
    
    class func initializeRepo(){
        
        
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        
        self.sessionManager.request("https://api.creiland.me/v1/channels/43", headers: headers).responseJSON { response in
            debugPrint(response)
        }
    }
    
    class func loginUser(email: String?, password: String?, completion: @escaping (String?) -> Void){
        
        var authToken : String?
        
        if(email == nil || password == nil){
            print("Error, either email or password is empty")
            completion(nil)
            return
        }
        
        let parameters: Parameters = [
            "email": email!,
            "password": password!
        ]
        
        print(parameters)
        
        guard let url = URL(string: "https://api.creiland.me/v1/sessions") else {
            completion(nil)
            return
        }
        Alamofire.request(url,
                          method: .post,
                          parameters: parameters,
                          encoding: JSONEncoding.default)
            .validate()
            .responseJSON { response in
                guard response.result.isSuccess else {
                    print("Error authenticating user")
                        completion(nil)
                    return
                }
                
                if let auth = response.response?.allHeaderFields["Authorization"] as? String {
                    authToken = auth.components(separatedBy: " ")[1]
                } else {
                    completion(nil)
                    return
                }
                
                completion(authToken)
        }
    }
}

class AccessTokenAdapter: RequestAdapter {
    private let accessToken: String
    
    init(accessToken: String) {
        self.accessToken = accessToken
    }
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        
        if let urlString = urlRequest.url?.absoluteString, urlString.hasPrefix("https://api.creiland.me") {
            urlRequest.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        }
        
        return urlRequest
    }
}
