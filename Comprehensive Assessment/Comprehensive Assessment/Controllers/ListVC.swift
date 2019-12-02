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
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listTableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as! TableViewCell
        
        cell.nameLabel.text = "Title"
        cell.eventTimeLabel.text = "Time"
        cell.listImageView.image = UIImage(named: "noImage")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
}
