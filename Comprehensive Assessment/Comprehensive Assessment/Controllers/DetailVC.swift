//
//  DetailVC.swift
//  Comprehensive Assessment
//
//  Created by Michelle Cueva on 12/3/19.
//  Copyright © 2019 Michelle Cueva. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {
    
    var currentItem: RequiredFields!
    
    var detailItem: ArtObjectDetail!
    
    var accountType: String!
    
    var favorites: [Favorite]!
    
    
    
    @IBOutlet weak var detailImage: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBOutlet weak var linkButton: UIButton!
    
    @IBOutlet weak var descriptionBox: UITextView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = currentItem.heading
        loadData()
        loadImage()
        linkButton.isHidden = accountType != APINames.ticketmaster.rawValue
        let isFavorited = favorites.contains(where: {$0.uniqueItemID == currentItem.uniqueItemID})
        let buttonImage = isFavorited ? "heart.fill" : "heart"
        favoriteButton.setImage(UIImage(systemName: buttonImage, withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight:.regular)), for: .normal)
    }
    
    
    @IBAction func favoriteButtonPressed(_ sender: UIButton) {
        
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
                        self.favoriteButton.setImage(UIImage(systemName: "heart", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight:.regular)), for: .normal)
                          //self.getFavoritesForThisUser()
                        
                      case .failure(let error):
                          print("handleFavorites: Error Happened \(error)")
                      }
                  }
              } else {
                  let newFavorite = Favorite(title: currentItem.heading, imageURL: currentItem.imageUrl, subtitle: currentItem.subheading, dateCreated: Date(), creatorID: user.uid, itemID: currentItem.uniqueItemID, accountType: accountType)
                  FirestoreService.manager.createFavorite(favorite: newFavorite) { (result) in
                      switch result {
                      case .success():
                          self.favoriteButton.setImage(UIImage(systemName: "heart.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight:.regular)), for: .normal)
                      case .failure(let error):
                          print(error)
                      }
                  }
              }
                
    }
    
    
    @IBAction func getTicketsButtonPressed(_ sender: UIButton) {
       guard let linkEvent = currentItem.linkToEvent else {return}
        let url = URL(string: linkEvent)
        guard let urlLink = url else {return}
        UIApplication.shared.open(urlLink, options:[:], completionHandler: nil)

    }
    
    private func loadData() {
        if accountType == APINames.ticketmaster.rawValue {
            loadDataForTickets()
        } else {
            loadDataForMuseum()
        }
    }
    
    private func loadDataForMuseum() {
        guard let id = currentItem.objectID else {
            print("no ID")
            return
        }
        DetailAPIClient.manager.getDetailObjects(objectNumber: id) { (result) in
            
            DispatchQueue.main.async {
                switch result {
                case .success(let detailsFromOnline):
                    
                    let productionPlaceArr = detailsFromOnline.productionPlaces
                    
                    let productionPlace = productionPlaceArr.count != 0 ? productionPlaceArr[0] : "Not avaiable"
            
                    self.descriptionBox.text = """
                    Date Created: \(detailsFromOnline.dating.presentingDate)
                    
                    Place of Production: \(productionPlace)
                    
                    \(String(detailsFromOnline.plaqueDescriptionEnglish ?? "No description in English available"))
                    """
                case .failure(let error):
                    print(error)
                }
            }

        }
    }
    
    private func loadDataForTickets() {
        guard let priceRange = currentItem.price else {return}
        
        self.descriptionBox.text = """
        Price: \(priceRange)
        
        When: \(currentItem.subheading)
        """
    }
    
    private func loadImage() {
        
               ImageHelper.shared.getImage(urlStr: currentItem.imageUrl) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let imageFromOnline):
                       
                         self.detailImage.image = imageFromOnline
                        
                    case .failure(let error):
                        print(error)
                        self.detailImage.image = UIImage(named: "noImage")
                    }
                    
                    self.activityIndicator.stopAnimating()
                    self.detailImage.backgroundColor = .clear
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
        
                    self?.favorites = favorites
                    
                    
                case .failure(let error):
                    print(":( \(error)")
                }
            }
        }
    }

    
}
