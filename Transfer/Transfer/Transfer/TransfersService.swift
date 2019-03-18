//
//  TransfersService.swift
//  Transfer
//
//  Created by Sasi Moorthy on 15/03/19.
//  Copyright © 2019 Sasi Moorthy. All rights reserved.
//

import Foundation

/*
 * ApiEndPoint declarations for all services
 */
let transfersUrl = "https://my-json-server.typicode.com/Sa74/Transfers/db"


/*
 * Enum type to return success and failure of API response
 */
enum Result {
    case success(Transfers)
    case failure(String)
}


/*
 * Service class to create URLSession and fetch data from given end point
 * Returns Reuslt on URLSession completion block
 */
class TransfersService {
    
    /*
     * API call to fetch transfers from given API end point
     * On success converts the data into transfers struct model and returns the result
     */
    func fetchTranfers(_ completion: @escaping (_ result: Result) -> () ) {
        
        fetchData(url: transfersUrl) { (data, response, error) in
            DispatchQueue.main.async(execute: {
                if error != nil {
                    completion(Result.failure("Unable to download transfers \(error?.localizedDescription ??  "No data received")"))
                } else {
                    do {
                        if let data = data {
                            let transfers = try JSONDecoder().decode(Transfers.self, from: data)
                            completion(Result.success(transfers))
                        } else {
                            completion(Result.failure("Unable to fetch transfers. No data received"))
                        }
                    } catch {
                        completion(Result.failure("Unable to fetch transfers. \(error)"))
                    }
                }
            })
        }
    }
    
    
    /*
     * Create URLRequest and downloads data from given url
     */
    private func fetchData(url: String, completion: @escaping (_ responseData: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        guard let url = URL(string: url) else {
            fatalError("Invalid URL")
        }
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30.0)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) -> Void in
            completion(data, response, error)
        }
        task.resume()
    }
}
