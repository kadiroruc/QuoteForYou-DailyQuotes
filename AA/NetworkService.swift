//
//  NetworkService.swift
//  AA
//
//  Created by Abdulkadir Oruç on 3.02.2024.
//

import Foundation

enum NetworkError: Error{
    case urlError
    case canNotParseData
}

public class NetworkService{
    
    static func getQuote(completion: @escaping (_ result: Result<Quote,NetworkError>) -> Void){
        
        
        
        let request = NSMutableURLRequest(url: NSURL(string: "\(Constants.shared.serverAdress)/quotes/random?limit=1")! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        let dataDask = session.dataTask(with: request as URLRequest) { data, response, error in
            
            if error != nil{
                completion(.failure(.urlError))
            }else{
                guard let data = data else{
                    completion(.failure(.canNotParseData))
                    return
                }
                if let decodedData = try? JSONDecoder().decode(Quote.self, from: data){
                    completion(.success(decodedData))
                }else{
                    completion(.failure(.canNotParseData))
                }
                    
            }
        }
        dataDask.resume()
    }
    

}

