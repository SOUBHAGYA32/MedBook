//
//  MainTabBarController.swift
//  MedBook
//
//  Created by Soubhagya on 05/04/25.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.backgroundColor
        self.tabBar.barTintColor = UIColor.black
        self.tabBar.backgroundColor = UIColor.black
        self.tabBar.tintColor = UIColor.white
        self.tabBar.unselectedItemTintColor = UIColor.gray
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.poppinsRegular(ofSize: 10)],
            for: .normal)
        self.setupTabBar()
    }
    
    private func setupTabBar() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeScreenViewController") as? HomeScreenViewController,
              let bookmarkVC = storyboard.instantiateViewController(withIdentifier: "BookMarkViewController") as? BookMarkViewController else {
            return
        }
        
        homeVC.tabBarItem = UITabBarItem(title: "Home",
                                         image: UIImage(systemName: "house"),
                                         selectedImage: UIImage(systemName: "house.fill"))
        
        bookmarkVC.tabBarItem = UITabBarItem(title: "Bookmark",
                                             image: UIImage(systemName: "bookmark"),
                                             selectedImage: UIImage(systemName: "bookmark.fill"))
        
        let homeNav = UINavigationController(rootViewController: homeVC)
        let bookmarkNav = UINavigationController(rootViewController: bookmarkVC)
        
        self.viewControllers = [homeNav, bookmarkNav]
    }
}
