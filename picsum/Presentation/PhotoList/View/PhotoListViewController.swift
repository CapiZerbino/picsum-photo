//
//  PhotoListViewController.swift
//  picsum
//
//  Created by Tieu Viet Trong Nghia on 25/8/24.
//

import Foundation
import UIKit

class PhotoListViewController: UIViewController {
    private var viewModel: PhotoListViewModel!
    var filteredPhotos: [Photo] = []
    let refreshControl = UIRefreshControl()
    let activityIndicator = UIActivityIndicatorView(style: .large)
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var photoSearchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.setupViewModel()
        activityIndicator.startAnimating()
        viewModel.fetchPhotos()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupTableView() {
        self.tableView.register(UINib(nibName: PhotoTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: PhotoTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshPhotos), for: .valueChanged)
        tableView.tableFooterView = activityIndicator
    }
    
    private func setupViewModel() {
        let repository = PhotoRepositoryImpl()
        let usecase = FetchPhotosUseCaseImpl(repository: repository)
        
        viewModel = PhotoListViewModel(fetchPhotsUseCase: usecase)
        viewModel.delegate = self
    }
    
    private func performSearch(with query: String) {
        if query.isEmpty {
            filteredPhotos = viewModel.photos
        } else {
            filteredPhotos = viewModel.photos.filter({ photo in
                return photo.author.lowercased().contains(query.lowercased()) ||
                photo.id.lowercased().contains(query.lowercased())
            })
        }
        tableView.reloadData()
    }
    
    @objc private func refreshPhotos() {
        photoSearchBar.text = ""
        photoSearchBar.resignFirstResponder()
        viewModel.refreshPhotos()
        refreshControl.endRefreshing()
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    private func normalizeTextSearch(query: String) -> String {
        // Filter out special characters
        let filteredText = query.filter { character in
            return character.isLetter || character.isNumber || "!@#$%^&*():.,<>/[]?".contains(character)
        }
        
        // Remove diacritics
        let normalizedText = filteredText.folding(options: .diacriticInsensitive, locale: .current)

        // Limit the text to 15 characters
        let limitedText = String(normalizedText.prefix(15))
        
        return limitedText
    }
}

extension PhotoListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPhotos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PhotoTableViewCell.identifier, for: indexPath) as! PhotoTableViewCell
        cell.configure(with: filteredPhotos[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.photos.count - 1 && viewModel.canLoadMore {
            activityIndicator.startAnimating()
            viewModel.fetchMorePhotos()
        }
    }
}

extension PhotoListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let normalizedText = normalizeTextSearch(query: searchText)
        searchBar.text = normalizedText
        performSearch(with: normalizedText)
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if UIPasteboard.general.string == text {
            let normalizedText = normalizeTextSearch(query: text)
            searchBar.text = normalizedText
            performSearch(with: normalizedText)
            return false
        }
        return true
    }
}

extension PhotoListViewController: PhotoListViewModelDelegate {
    func didUpdatePhotos() {
        // Update photo from view model to table when fetching from API success
        filteredPhotos = viewModel.photos
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.tableView.reloadData()
        }
    }
    
    func didFailWithError(_ error: any Error) {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        }
        print(error)
    }
}
