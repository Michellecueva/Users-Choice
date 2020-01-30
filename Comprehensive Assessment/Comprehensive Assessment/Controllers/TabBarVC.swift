//
//  TabBarVC.swift
//  Comprehensive Assessment
//
//  Created by Michelle Cueva on 12/2/19.
//  Copyright © 2019 Michelle Cueva. All rights reserved.
//

import UIKit

class TabBarVC: UITabBarController {
    
    
    lazy var searchVC = UINavigationController(rootViewController: createSearchVC())
    
    lazy var favoriteVC = UINavigationController(rootViewController: createFavoritesVC())
    
    lazy var settingVC = UINavigationController(rootViewController: SettingsVC())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBaritemsForVCs()
        self.viewControllers = [searchVC, favoriteVC, settingVC]
    }
    
    private func createSearchVC() -> UIViewController {
        let firstVC = ListVC()
        firstVC.dataLocation = .fromSearch
        return firstVC
    }
    
    private func createFavoritesVC() -> UIViewController {
        let secondVC = ListVC()
        secondVC.dataLocation = .fromFavorites
        return secondVC
        
    }
    
    private func setTabBaritemsForVCs() {
        searchVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        favoriteVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        settingVC.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "person"), tag: 2)
    }
    
    
}
