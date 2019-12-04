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

    override func viewDidLoad() {
        super.viewDidLoad()
        searchVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        favoriteVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        self.viewControllers = [searchVC, favoriteVC]
        
    }
    
    private func createSearchVC() -> UIViewController {
        let firstVC = ListVC()
        firstVC.dataLocation = .fromSearch
        firstVC.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "sign-out", style: .done, target: self, action: #selector(signOutButton))
        return firstVC
    }
    
    private func createFavoritesVC() -> UIViewController {
        let secondVC = ListVC()
        secondVC.dataLocation = .fromFavorites
        secondVC.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "sign-out", style: .done, target: self, action: #selector(signOutButton))
        return secondVC
        
    }
    
    @objc func signOutButton() {
        FirebaseAuthService.manager.signOutUser()
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            
            let sceneDelegate = windowScene.delegate as? SceneDelegate, let window = sceneDelegate.window else {return}
        
        window.rootViewController = SignInVC()
    }

}
