//
//  ViewController.swift
//  hachat
//
//  Created by jones wang on 2016/10/29.
//  Copyright © 2016年 J40. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin


class ViewController: UIViewController{
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getFBProfile()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginButton = LoginButton(readPermissions: [.publicProfile,.email])
        loginButton.delegate = self
        loginButton.frame = CGRect(x: 16, y: 80, width: UIScreen.main.bounds.width-32, height: 50)
        
        view.addSubview(loginButton)
        view.backgroundColor = UIColor.white
        
        navigationItem.title = "Ha Chat"
        
    }
    

}

extension ViewController: LoginButtonDelegate {
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        
    }
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        
        getFBProfile()
        
        
    }
    
    func joinChat() {
        let layout = UICollectionViewFlowLayout()
        let chatlog = ChatLogController(collectionViewLayout: layout)
        navigationController?.pushViewController(chatlog, animated: true)
    }
    
}



