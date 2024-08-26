//
//  FetchPhotosUseCase.swift
//  picsum
//
//  Created by Tieu Viet Trong Nghia on 25/8/24.
//

import Foundation

protocol FetchPhotosUseCase {
    func execute(page: Int, pageSize: Int, completion: @escaping (Result<[Photo], Error>)  -> Void)
}

class FetchPhotosUseCaseImpl: FetchPhotosUseCase {
    private let repository: PhotoRepository
    
    init(repository: PhotoRepository) {
        self.repository = repository
    }
    
    func execute(page: Int, pageSize: Int, completion: @escaping (Result<[Photo], any Error>) -> Void) {
        repository.fetchPhotos(page: page, pageSize: pageSize, completion: completion)
    }
}
