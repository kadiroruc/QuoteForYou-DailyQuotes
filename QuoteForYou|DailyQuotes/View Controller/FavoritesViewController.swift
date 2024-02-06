//
//  FavoritesViewController.swift
//  QuoteForYou|DailyQuotes
//
//  Created by Abdulkadir Oruç on 5.02.2024.
//

import UIKit

class FavoritesViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    
    
    private lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
    
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
            
        collectionView.backgroundColor = UIColor(red: 222/255, green: 206/255, blue: 186/255, alpha: 1)
        collectionView.register(FavoritesCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    var favoriteQuotes = [QuoteDataModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    func setupUI(){
        title = "Scroll Right"
        navigationController?.navigationBar.tintColor = .black
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints  = false
        
        NSLayoutConstraint.activate([
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        favoriteQuotes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FavoritesCollectionViewCell
        cell.backgroundColor = .white
        cell.layer.cornerRadius = 20
        cell.layer.masksToBounds = true
        
        cell.label.text = favoriteQuotes[indexPath.item].content
        cell.authorLabel.text = favoriteQuotes[indexPath.item].author
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let cellWidth: CGFloat = collectionView.frame.width - 50
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let collectionViewWidth = collectionView.frame.width
        let collectionViewHeight = collectionView.frame.height
        let cellWidth : CGFloat = collectionViewWidth - 50
        return UIEdgeInsets(top:25 , left: (collectionViewWidth-cellWidth)/2, bottom: 0, right:0)

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return (collectionView.frame.width - (collectionView.frame.width-50))/2
    }
    

}
