//
//  NetworkConstant.swift
//  AA
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

    
}

