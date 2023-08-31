//
//  loginViewModel.swift
//  ShahidTT
//
//  Created by atsmac on 30/08/2023.
//

import Foundation

class loginViewModel {
    var username: String = ""
    var password: String = ""
    
    private var allowedEmailsArray = ["sghotouk@gmail.com",
                                      "nezar.Najdawi@shahid.net",
                                      "nizar.Basbous@shahid.net",
                                      "laith.Shanti@mbc.net"]
    
    func login(completion: @escaping (Bool) -> Void) {
        if allowedEmailsArray.contains(username.lowercased()) && password == "password" {
            completion(true)
        } else {
            completion(false)
        }
    }
}
