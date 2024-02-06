//
//  NetworkConstant.swift
//  QuoteForYou|DailyQuotes
//
//  Created by Abdulkadir Oruç on 3.02.2024.
//

import Foundation

class Constants{
    public static var shared: Constants = Constants()
    
    private init(){
        //singleton
    }
    
    public var serverAdress: String {
        get{
            return "https://api.quotable.io"
        }
    }
    
    public var currentQuote: String{
        get{
            return "currentQuote"
        }
    }
    
    public var currentQuoteAuthor: String{
        get{
            return "currentQuoteAuthor"
        }
    }

    
}

