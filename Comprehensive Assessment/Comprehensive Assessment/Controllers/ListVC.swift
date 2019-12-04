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
    var accountType: String! {
        didSet {
            let placeholder = accountType == APINames.ticketmaster.rawValue ? "Enter city" : "Enter name"
            
            searchBar.placeholder = placeholder
        }
    }
    
    var items = [RequiredFields]() {
        didSet {
            listTableView.reloadData()
        }
    }
    
    var imageRetrieved: UIImage!
    
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
        let fireService = FirestoreService()
        fireService.getAccountType() { [weak self] (result) in
            switch result {
            case .success(let typeFromDatabase):
                self!.accountType = typeFromDatabase as? String
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if dataLocation == .fromFavorites {
            getFavoritesForThisUser()
        }
    }
    
    //MARK: Private Functions
    
    private func loadDataFromTickets(city: String, state: String) {
        TicketsAPIClient.manager.getTickets(city: city, state: state) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let eventsFromOnline):
                    self.items = eventsFromOnline
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    private func loadDataFromMuseum(maker: String) {
        MuseumAPIClient.manager.getArtObjects(maker: maker) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let objectsFromOnline):
                    self.items = objectsFromOnline
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
            FirestoreService.manager.getFavorites(forUserID: id) { (result) in
                switch result {
                case .success(let favorites):
                    self?.items = favorites
                case .failure(let error):
                    print(":( \(error)")
                }
            }
        }
    }
    
    
    //MARK: UI Setup
    
    private func setSubviews() {
        self.view.addSubview(searchBar)
        self.view.addSubview(listTableView)
    }
    
    private func setConstraints() {
        setSearchBarConstraints()
        setTableviewConstraints()
        
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
        
        
        
        ImageHelper.shared.getImage(urlStr: currentItem.imageUrl) { (result) in
            
            switch result {
            case .success(let imageFromOnline):
                DispatchQueue.main.async {
                    cell.listImageView.image = imageFromOnline
                }
            case .failure(let error):
                print(error)
                cell.listImageView.image = UIImage(named: "noImage")
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentItem = items[indexPath.row]
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        let DVC = storyBoard.instantiateViewController(identifier: "detailView") as! DetailVC
        
        DVC.currentItem = currentItem
        DVC.accountType = accountType
        
        self.navigationController?.pushViewController(DVC, animated: true)
        
        
    }
}

extension ListVC : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else {return}
        
        if accountType == APINames.ticketmaster.rawValue {
            let geoCoder = CLGeocoder()
            geoCoder.geocodeAddressString(text) {
                placemarks, error in
                let placemark = placemarks?.first
                guard let city = placemark?.locality else {return}
                guard let state = placemark?.administrativeArea else {return}
                print(city)
                print(state)
                self.loadDataFromTickets(city:city, state: state)
                
            }
        } else {
            loadDataFromMuseum(maker: text)
        }
        
    }
}

extension ListVC: CellDelegate {

    func addToFavorites(tag: Int) {
        let currentItem = items[tag]
        
        guard let user = FirebaseAuthService.manager.currentUser else {return}
        
        let newFavorite = Favorite(title: currentItem.heading, imageURL: currentItem.imageUrl, subtitle: currentItem.subheading, dateCreated: Date(), creatorID: user.uid)
        
        FirestoreService.manager.createFavorite(favorite: newFavorite) { (result) in
            switch result {
            case .success():
                print("this worked")
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    
}
