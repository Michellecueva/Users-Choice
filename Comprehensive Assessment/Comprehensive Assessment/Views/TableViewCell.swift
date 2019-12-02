//
//  TableViewCell.swift
//  Comprehensive Assessment
//
//  Created by Michelle Cueva on 12/2/19.
//  Copyright © 2019 Michelle Cueva. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    var nameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    var eventTimeLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    var listImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func addSubviews() {
        self.contentView.addSubview(self.nameLabel)
        self.contentView.addSubview(self.eventTimeLabel)
        self.contentView.addSubview(self.listImageView)
    }
    
    private func setConstraints() {
        self.nameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.eventTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.listImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            listImageView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            listImageView.heightAnchor.constraint(equalToConstant: 50),
            listImageView.widthAnchor.constraint(equalToConstant: 50),
            
            nameLabel.topAnchor.constraint(equalTo: listImageView.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: listImageView.trailingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -15),
            
            eventTimeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            eventTimeLabel.leadingAnchor.constraint(equalTo: listImageView.trailingAnchor, constant: 20),
            eventTimeLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -15)
        ])
    }

}
