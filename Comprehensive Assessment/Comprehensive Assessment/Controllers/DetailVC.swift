//
//  DetailVC.swift
//  Comprehensive Assessment
//
//  Created by Michelle Cueva on 12/3/19.
//  Copyright © 2019 Michelle Cueva. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {
    
    var currentItem: ArtObject!
    
    var detailItem: ArtObjectDetail!
    
    var imageRetrieved: UIImage!
    
    
    
    @IBOutlet weak var detailImage: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    @IBOutlet weak var favoriteButton: UIButton!
    
    
    @IBOutlet weak var descriptionBox: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailImage.image = imageRetrieved
        titleLabel.text = currentItem.title
        loadData()

    }
    
    
    @IBAction func favoriteButtonPressed(_ sender: UIButton) {
    }
    
    
    @IBAction func getTicketsButtonPressed(_ sender: UIButton) {
        //if you are on ticketMaster account make this visiible and direct to link
    }
    
    
    private func loadData() {
        DetailAPIClient.manager.getDetailObjects(objectNumber: currentItem.objectNumber) { (result) in
            
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

    
}
