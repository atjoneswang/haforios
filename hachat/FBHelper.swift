//
//  FBHelper.swift
//  hachat
//
//  Created by jones wang on 2016/11/1.
//  Copyright © 2016年 J40. All rights reserved.
//

import Foundation
import FacebookCore

func getFBProfile() {
    if AccessToken.current != nil {
        let paramater:[String: Any] = ["fields": "name, cover,email"]
        
        let graphRequest = GraphRequest(graphPath: "/me", parameters: paramater, accessToken: AccessToken.current, httpMethod: .GET, apiVersion: GraphAPIVersion.defaultVersion)
        graphRequest.start({ (httpResponse, result) in
            
            switch result{
            case .success(let response):
                let data = response.dictionaryValue
                UserDefaults.standard.set(data?["name"], forKey: "username")
                UserDefaults.standard.set(data?["email"], forKey: "email")
            
                let cover = data?["cover"] as! [String: Any]
                UserDefaults.standard.set(cover["source"]!, forKey: "cover")
                
                
            case .failed(let error):
                print("\(error)")
            }
            
        })
        
    }
}

func getFBName() -> String {
    return UserDefaults.standard.string(forKey: "username")!
}

func getFBCover() -> String {
    return UserDefaults.standard.string(forKey: "cover")!
}
