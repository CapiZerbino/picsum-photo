//
//  PhotoRepository.swift
//  picsum
//
//  Created by Tieu Viet Trong Nghia on 25/8/24.
//

import Foundation

protocol PhotoRepository {
    func fetchPhotos(page: Int, pageSize: Int, completion: @escaping (Result<[Photo], Error>) -> Void )
}

class PhotoRepositoryImpl: PhotoRepository {
    private let networkService: NetworkService
    
    init(networkService: NetworkService = .shared) {
        self.networkService = networkService
    }
    
    func fetchPhotos(page: Int, pageSize: Int, completion: @escaping (Result<[Photo], any Error>) -> Void) {
        guard let url = APIEndpoints.photos(page: page, limit: pageSize) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        networkService.fetchData(from: url) { result in
            switch result {
                case .success(let data):
                do {
                    let photos = try JSONDecoder().decode([Photo].self, from: data)
                    completion(.success(photos))
                } catch {
                    completion(.failure(error))
                }
                case .failure(let error):
                completion(.failure(error))
                
            }
        }
    }
}
