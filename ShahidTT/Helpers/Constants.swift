//
//  Constants.swift
//  ShahidTT
//
//  Created by atsmac on 31/08/2023.
//

import UIKit

enum API {
    static let APIKey = "brgaGffldAQVWMaojy8fQnxoVuf2eX4a"
    static let baseURL = "https://api.giphy.com/v1/gifs/trending"
    static let searchURL = "https://api.giphy.com/v1/gifs/search"
}

enum Color {
    static let primary = UIColor(named: "AccentColor") ?? UIColor.systemGreen
    static let secondary = UIColor(named: "SecondaryColor") ?? UIColor.systemBlue
}

enum ControllerName {
    static let home = "HomeViewController"
    static let favorites = "FavoritesViewController"
    static let details = "DetailsViewController"
}

class UserDataManager {
    static let shared = UserDataManager()

    var username: String = ""
}
