//
//  ViewModel.swift
//  AA
//
//  Created by Abdulkadir Oruç on 3.02.2024.
//

import Foundation

protocol ViewModelDelegate: AnyObject{
    func didUpdate()
}

class ViewModel{
    weak var delegate: ViewModelDelegate?
    
    private var quote: Quote = []
    private var errorMessage: Error?
    
    
    func loadData(){
        NetworkService.getQuote {[weak self] result in
            switch result{
            case let .success(quote):
                self?.quote = quote
                self?.delegate?.didUpdate()
            
            case let .failure(error):
                self?.quote = []
                self?.errorMessage = error
            }
        }
    }
    func getQuote() -> QuoteModel{
        return quote[0]
    }
}
