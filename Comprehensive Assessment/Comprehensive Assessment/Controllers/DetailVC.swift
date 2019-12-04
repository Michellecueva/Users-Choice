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
    
    
    
    @IBOutlet weak var detailImage: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBOutlet weak var linkButton: UIButton!
    
    @IBOutlet weak var descriptionBox: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = currentItem.heading
        loadData()
        loadImage()
        linkButton.isHidden = accountType != APINames.ticketmaster.rawValue
        
    }
    
    
    @IBAction func favoriteButtonPressed(_ sender: UIButton) {
                
    }
    
    
    @IBAction func getTicketsButtonPressed(_ sender: UIButton) {
       guard let linkEvent = currentItem.linkToEvent else {return}
        let url = URL(string: linkEvent)
        guard let urlLink = url else {return}
        UIApplication.shared.open(urlLink, options:[:], completionHandler: nil)

    }
    
    private func loadData() {
        if accountType == APINames.ticketmaster.rawValue {
            loadDataForTickerts()
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
                    
                    // remember to account for the fact that some museum items dont have plaque or place of prodction
                    self.descriptionBox.text = detailsFromOnline.plaqueDescriptionEnglish
                case .failure(let error):
                    print(error)
                }
            }

        }
    }
    
    private func loadDataForTickerts() {
        guard let priceRange = currentItem.price else {return}
        
        self.descriptionBox.text = """
        Price: \(priceRange)
        
        When: \(currentItem.subheading)
        """
    }
    
    private func loadImage() {
        
               ImageHelper.shared.getImage(urlStr: currentItem.imageUrl) { (result) in
                   
                   switch result {
                   case .success(let imageFromOnline):
                       DispatchQueue.main.async {
                        self.detailImage.image = imageFromOnline
                       }
                   case .failure(let error):
                       print(error)
                       self.detailImage.image = UIImage(named: "noImage")
                   }
               }
    }

    
}
