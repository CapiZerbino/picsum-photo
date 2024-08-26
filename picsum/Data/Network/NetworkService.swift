//
//  NetworkService.swift
//  picsum
//
//  Created by Tieu Viet Trong Nghia on 25/8/24.
//

import Foundation

class NetworkService {
    static let shared = NetworkService()
    
    func fetchData(from url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        print(request.curlString)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(.failure(error))
            } else if let data = data {
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Response Data: \(jsonString)")
                } else {
                    print("Unable to convert data to string")
                }
                completion(.success(data))
            }
        }
        task.resume()
    }
}
