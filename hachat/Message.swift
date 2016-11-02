//
//  Message.swift
//  hachat
//
//  Created by jones wang on 2016/10/31.
//  Copyright © 2016年 J40. All rights reserved.
//

import Foundation

class Message {
    var fromId: String?
    var text: String?
    var textTime: Date?
    var profileImage: String?
    
    init(){}
    
    init(fromId: String, msg: String, img: String) {
        self.fromId = fromId
        self.text = msg
        self.textTime = Date()
        self.profileImage = img
    }
}
