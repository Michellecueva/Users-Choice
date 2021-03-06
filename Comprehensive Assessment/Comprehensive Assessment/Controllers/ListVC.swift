//
//  SearchVC.swift
//  Comprehensive Assessment
//
//  Created by Michelle Cueva on 12/2/19.
//  Copyright © 2019 Michelle Cueva. All rights reserved.
//

import UIKit
import FirebaseAuth
import CoreLocation

enum DataLocation {
    case fromSearch
    case fromFavorites
}

class ListVC: UIViewController {
    
    
    var dataLocation: DataLocation! = .fromSearch
    var accountType = "Ticketmaster" {
        didSet {
            setSearchBarPlaceHolder()
            setNavTitle(accountType: accountType)
            getFavoritesForThisUser()
        }
    }
    
    var items = [RequiredFields]() {
        didSet {
            listTableView.reloadData()
        }
    }
    
    var favorites = [Favorite]() {
        didSet {
            listTableView.reloadData()
        }
    }
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        return searchBar
    }()
    
    lazy var listTableView: UITableView = {
        let tableview = UITableView()
        tableview.backgroundColor = .lightGray
        tableview.register(TableViewCell.self, forCellReuseIdentifier: "listCell")
        return tableview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setSubviews()
        setConstraints()
        listTableView.delegate = self
        listTableView.dataSource = self
        searchBar.delegate = self
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.crop.circle.badge.xmark"), style:.plain, target: self, action: #selector(signOutButton))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getAccountType()
    }
    
    //MARK: Obj-C Methods
    
    @objc func signOutButton() {
        FirebaseAuthService.manager.signOutUser()
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            
            let sceneDelegate = windowScene.delegate as? SceneDelegate, let window = sceneDelegate.window else {return}
        
        window.rootViewController = SignInVC()
    }
    
    //MARK: Private Functions
    
    private func getAccountType() {
        FirestoreService.manager.getAccountType() { [weak self] (result) in
            switch result {
            case .success(let typeFromDatabase):
                let newAccountType = typeFromDatabase as! String
                if self!.accountType != newAccountType {
                    self!.items = []
                    self!.searchBar.text = ""
                }
                self!.accountType = newAccountType
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func loadDataFromTickets(city: String) {
        TicketsAPIClient.manager.getTickets(city: city) { [weak self] (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let eventsFromOnline):
                    self!.items = eventsFromOnline
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    private func loadDataFromMuseum(maker: String) {
        MuseumAPIClient.manager.getArtObjects(maker: maker) { [weak self] (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let objectsFromOnline):
                    self!.items = objectsFromOnline
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    private func getFavoritesForThisUser() {
        guard  let id =  FirebaseAuthService.manager.currentUser?.uid else {
            print("userID not found")
            return
        }
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            FirestoreService.manager.getFavorites(forUserID: id, accountType: self!.accountType) { (result) in
                switch result {
                case .success(let favorites):
                    if self!.dataLocation == .fromFavorites {
                        self!.items = favorites
                    }
                    self!.favorites = favorites
                    
                case .failure(let error):
                    print(":( \(error)")
                }
            }
        }
    }
    
    
    private func setNavTitle(accountType: String) {
        let navTitle = self.dataLocation == .fromSearch ? "\(accountType)" : "\(accountType) Favorites"
        self.navigationItem.title = navTitle
    }
    
    private func setSearchBarPlaceHolder() {
        let placeholder = accountType == APINames.Ticketmaster.rawValue ? "Enter City" : "Enter Name"
        searchBar.placeholder = placeholder
    }
    
    
    //MARK: UI Setup
    
    private func setSubviews() {
        if dataLocation == .fromSearch {
            self.view.addSubview(searchBar)
        }
        
        self.view.addSubview(listTableView)
    }
    
    
    private func setConstraints() {
        if dataLocation == .fromSearch {
            setConstraintsForSearchVC()
        } else {
            setConstraintsForFavVC()
        }
    }
    
    private func setConstraintsForSearchVC() {
        setSearchBarConstraints()
        setTableviewConstraints()
    }
    
    private func setConstraintsForFavVC() {
        setTableviewConstraintsForFavVC()
    }
    
    private func setSearchBarConstraints() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
        
    }
    
    private func setTableviewConstraints() {
        
        listTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            listTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            listTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            listTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            listTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
    }
    
    private func setTableviewConstraintsForFavVC() {
        listTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            listTableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            listTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            listTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            listTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
}

extension ListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listTableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as! TableViewCell
        
        let currentItem = items[indexPath.row]
        cell.nameLabel.text = currentItem.heading
        
        cell.eventTimeLabel.text = currentItem.subheading
        
        cell.favoriteButton.tag = indexPath.row
        cell.delegate = self
        
        let isFavorited = favorites.contains(where: {$0.uniqueItemID == currentItem.uniqueItemID})
        let buttonImage = isFavorited ? "heart.fill" : "heart"
        cell.favoriteButton.setImage(UIImage(systemName: buttonImage, withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight:.regular)), for: .normal)
        
        ImageHelper.shared.getImage(urlStr: currentItem.imageUrl) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let imageFromOnline):
                    DispatchQueue.main.async {
                        cell.listImageView.image = imageFromOnline
                    }
                case .failure(let error):
                    print(error)
                    cell.listImageView.image = UIImage(named: "noImage")
                }
                cell.activityIndicator.stopAnimating()
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if dataLocation == .fromFavorites {return}
        
        let currentItem = items[indexPath.row]
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let DVC = storyBoard.instantiateViewController(identifier: "detailView") as! DetailVC
        
        DVC.currentItem = currentItem
        DVC.accountType = accountType
        DVC.favorites = favorites
        
        self.navigationController?.pushViewController(DVC, animated: true)
        
    }
}

extension ListVC : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else {return}
        
        if accountType == APINames.Ticketmaster.rawValue {
            let geoCoder = CLGeocoder()
            geoCoder.geocodeAddressString(text) {
                placemarks, error in
                let placemark = placemarks?.first
                guard let city = placemark?.locality else {return}
                self.loadDataFromTickets(city:city)
            }
        } else {
            loadDataFromMuseum(maker: text)
        }
    }
}

extension ListVC: CellDelegate {
    
    func handleFavorites(tag: Int) {
        let currentItem = items[tag]
        
        guard let user = FirebaseAuthService.manager.currentUser else {return}
        let isFavorited = favorites.contains(where: {$0.uniqueItemID == currentItem.uniqueItemID})
        
        if isFavorited {
            guard let favoriteItem = favorites.filter({$0.uniqueItemID == currentItem.uniqueItemID}).first else {
                print("Favorite Item Not Found")
                return
            }
            FirestoreService.manager.removeFavorite(favorite: favoriteItem) { (result) in
                switch result {
                case .success():
                    let indexOfFav = self.favorites.firstIndex { $0.itemID == favoriteItem.itemID}
                    guard let index = indexOfFav else {return}
                    self.favorites.remove(at: index)
                    self.listTableView.reloadData()
                case .failure(let error):
                    print("handleFavorites: Error Happened \(error)")
                }
            }
        } else {
            let newFavorite = Favorite(title: currentItem.heading, imageURL: currentItem.imageUrl, subtitle: currentItem.subheading, dateCreated: Date(), creatorID: user.uid, itemID: currentItem.uniqueItemID, accountType: accountType)
            FirestoreService.manager.createFavorite(favorite: newFavorite) { (result) in
                switch result {
                case .success():
                    self.getFavoritesForThisUser()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
