//
//  LoginViewController.swift
//  Networking
//
//  Created by Александр Майко on 19.12.2020.
//  Copyright © 2020 Александр Майко. All rights reserved.
//

import UIKit
import FBSDKLoginKit
class LoginViewController: UIViewController {

  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
// MARK: FACEBOOK SDK
        
        // создаем кнопку
        let loginButton = FBLoginButton()
        loginButton.center = view.center
        view.addSubview(loginButton)
        loginButton.delegate = self
        
// СОздаем возможность входить без повторного введения пароля, если ранее уже был введен
        
        if let token = AccessToken.current, !token.isExpired {
            print("The user is logged in")
        }
        // равнозначные записи
        
        if AccessToken.isCurrentAccessTokenActive{
            print("hi")
        }
    }
  
    
}

extension LoginViewController: LoginButtonDelegate {
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if error != nil {
            print(error)
            return
        }
        print("Seccessfully logged in with Facebook...")
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("User did log out of Facebook...")
    }
    
    
}
