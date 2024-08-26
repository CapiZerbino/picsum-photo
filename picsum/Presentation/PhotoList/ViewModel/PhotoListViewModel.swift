//
//  PhotoListViewModel.swift
//  picsum
//
//  Created by Tieu Viet Trong Nghia on 25/8/24.
//

import Foundation

protocol PhotoListViewModelDelegate: AnyObject {
    func didUpdatePhotos()
    func didFailWithError(_ error: Error)
}

class PhotoListViewModel {
    private let fetchPhotsUseCase: FetchPhotosUseCase
    private var currentPage = 1
    private var pageSize = 100
    var isLoading = false
    var canLoadMore = false
    
    var photos: [Photo] = []
    weak var delegate: PhotoListViewModelDelegate?
    
    init(fetchPhotsUseCase: FetchPhotosUseCase) {
        self.fetchPhotsUseCase = fetchPhotsUseCase
    }
    
    func fetchPhotos() {
        guard !isLoading else { return }
        isLoading = true
        
        fetchPhotsUseCase.execute(page: currentPage, pageSize: pageSize) { [weak self] result in
            guard let self = self else { return }
            
            self.isLoading = false
            
            switch result {
                case .success(let photos):
                    self.photos.append(contentsOf: photos)
                    canLoadMore = photos.count < pageSize ? false : true
                    self.delegate?.didUpdatePhotos()
                case .failure(let error):
                    self.delegate?.didFailWithError(error)
            }
        }
    }
    
    func refreshPhotos() {
        currentPage = 1
        photos.removeAll()
        fetchPhotos()
    }
    
    func fetchMorePhotos() {
        self.currentPage += 1
        fetchPhotos()
    }
}
