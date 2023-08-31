//
//  FavoritesViewController.swift
//  ShahidTT
//
//  Created by atsmac on 31/08/2023.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        //had to place it in init as using viewdidload woul not allow the HomeController to present the tab bar with all tabs loaded
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func setupUI() {
        title = "Favorites"
        tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "star"), tag: 0)
    }

}
