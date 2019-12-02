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
    
    lazy var favoriteVC = createFavoritesVC()

    override func viewDidLoad() {
        super.viewDidLoad()
        searchVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        favoriteVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        self.viewControllers = [searchVC, favoriteVC]
        
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

}
