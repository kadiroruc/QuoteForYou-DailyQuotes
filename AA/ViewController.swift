//
//  ViewController.swift
//  AA
//
//  Created by Abdulkadir Oruç on 3.02.2024.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: "Avenir", size: 32)
        label.textAlignment = .center
        return label
    }()
    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: "Avenir", size: 16)
        label.textColor = UIColor(white: 0.2, alpha: 1)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        navigationController?.tabBarController?.delegate = self
    }

    //private let quote: Quote = []
    private let viewModel: ViewModel
    var favoriteBarItemSelected: Bool = false
    
    required init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadData()
    }
    
    func setupUI(){
        view.backgroundColor = UIColor(red: 222/255, green: 206/255, blue: 186/255, alpha: 1)
        
        view.addSubview(label)
        view.addSubview(authorLabel)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 40),
            label.rightAnchor.constraint(equalTo: view.rightAnchor,constant: -40),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            authorLabel.topAnchor.constraint(equalTo: label.bottomAnchor,constant: 10),
            authorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
    }
    
}

extension ViewController: ViewModelDelegate{
    func didUpdate() {
        DispatchQueue.main.async {
            let quote = self.viewModel.getQuote()
            self.label.text = quote.content
            self.authorLabel.text = "- \(quote.author)"
        }
    }
    
}

extension ViewController: UITabBarControllerDelegate{
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        let selectedIndex = tabBarController.selectedIndex
        
        if selectedIndex == 0 {
            favoriteBarItemSelected.toggle()
            if favoriteBarItemSelected{
                tabBarController.tabBar.items?[selectedIndex].image = UIImage(systemName: "heart.fill")
            }else{
                tabBarController.tabBar.items?[selectedIndex].image = UIImage(systemName: "heart")
            }


        }
    }
}

