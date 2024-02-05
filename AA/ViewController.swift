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
        
        if let currentQuote = userDefaults.object(forKey: "currentQuote")as? String{
            label.text = currentQuote
        }
        if let currentQuoteAuthor = userDefaults.object(forKey: "currentQuoteAuthor")as? String{
            authorLabel.text = "- \(currentQuoteAuthor)"
        }

        //scheduleLoadData()
        
    }
    
    private let viewModel: ViewModel
    var favoriteBarItemSelected: Bool = false
    
    private let userDefaults = UserDefaults.standard
    var timer: Timer?
    
    required init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        view.backgroundColor = UIColor(red: 222/255, green: 206/255, blue: 186/255, alpha: 1)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrowshape.turn.up.right.fill"), style: .done, target: self, action: #selector(shareTapped))
        navigationItem.rightBarButtonItem?.tintColor = .black
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .done, target: self, action: #selector(listTapped))
        navigationItem.leftBarButtonItem?.tintColor = .black
        
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
    
    func scheduleLoadData(){
        timer?.invalidate()
        let currentDate = Date()
        let calendar = Calendar.current
        
        // 9:00'a kadar olan süreyi hesapla
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: currentDate)
        components.hour = 19
        components.minute = 39
        components.second = 00
        let targetDate = calendar.date(from: components)!
        
        // Hedef tarihe kadar kalan süreyi hesapla
        let timeInterval = targetDate.timeIntervalSince(currentDate)
        
        if timeInterval > 0{
            print(timeInterval)
            timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false) { [weak self] timer in
                
                self?.viewModel.loadData()
            }
        }

    }

    
    @objc func shareTapped(){
        
    }
    
    @objc func listTapped(){
        
    }
    
}

extension ViewController: ViewModelDelegate{
    func didUpdate() {
        DispatchQueue.main.async {
            let quote = self.viewModel.getQuote()
            self.userDefaults.set(quote.content, forKey: "currentQuote")
            self.userDefaults.set(quote.author, forKey: "currentQuoteAuthor")
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
