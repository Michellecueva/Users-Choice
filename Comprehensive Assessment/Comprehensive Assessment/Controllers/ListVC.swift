//
//  SearchVC.swift
//  Comprehensive Assessment
//
//  Created by Michelle Cueva on 12/2/19.
//  Copyright © 2019 Michelle Cueva. All rights reserved.
//

import UIKit


enum DataLocation {
    case fromSearch
    case fromFavorites
}

class ListVC: UIViewController {
    
    var dataLocation: DataLocation! = .fromSearch
    
    var items = [ArtObject]() {
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
        loadDataFromMuseum(maker: "Rembrandt+van+Rijn")
        
    }
    
    //MARK: Private Functions
    
    private func loadDataFromTickets(city: String, state: String) {
        TicketsAPIClient.manager.getTickets(city: city, state: state) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let eventsFromOnline):
                    print(eventsFromOnline)
                    //self.items = eventsFromOnline
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
        cell.nameLabel.text = currentItem.title
        
        cell.eventTimeLabel.text = currentItem.principalOrFirstMaker
        
        
        
        ImageHelper.shared.getImage(urlStr: currentItem.webImage.url) { (result) in
            
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
        return 100
    }
    
    
}
