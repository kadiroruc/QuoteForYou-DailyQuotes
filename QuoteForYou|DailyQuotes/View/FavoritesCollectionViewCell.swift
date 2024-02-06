//
//  FavoritesCollectionViewCell.swift
//  QuoteForYou|DailyQuotes
//
//  Created by Abdulkadir Oruç on 5.02.2024.
//

import UIKit

class FavoritesCollectionViewCell: UICollectionViewCell {
    
    lazy var label: UILabel = {
        let label = UILabel()
        
        label.textAlignment = .center
        label.font = UIFont(name: "Avenir", size: 26)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: "Avenir", size: 14)
        label.textColor = UIColor(white: 0.2, alpha: 1)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(label)
        addSubview(authorLabel)
        label.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.leftAnchor.constraint(equalTo: leftAnchor),
            label.rightAnchor.constraint(equalTo: rightAnchor),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.heightAnchor.constraint(equalToConstant: frame.height*9/10)
        ])
        
        NSLayoutConstraint.activate([
            authorLabel.leftAnchor.constraint(equalTo: leftAnchor),
            authorLabel.rightAnchor.constraint(equalTo: rightAnchor),
            authorLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            authorLabel.topAnchor.constraint(equalTo: label.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
    }
}
