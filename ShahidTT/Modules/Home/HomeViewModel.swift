//
//  HomeViewModel.swift
//  ShahidTT
//
//  Created by atsmac on 31/08/2023.
//

import Foundation

class HomeViewModel {
    var GIFs: [Datum] = []
    var currentPage = 0
    let itemsPerPage = 20
    
    func fetchData(completion: @escaping () -> Void) {
        let parameters: [String : Any] = ["api_key": API.APIKey,
                                          "limit": itemsPerPage,
                                          "offset": currentPage * itemsPerPage]
        
        guard let url = URL(string: API.baseURL) else { return }
        NetworkManager.shared.requestData(url: url, method: .get, parameters: parameters) { (result: Result<GiphyItem, Error>) in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.GIFs.append(contentsOf: response.data) // Append new data
                    completion()
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    func search(query: String, completion: @escaping () -> Void) {
        GIFs.removeAll()
        let parameters: [String : Any] = ["api_key": API.APIKey,
                                          "q": query,
                                          "limit": itemsPerPage]
        
        guard let url = URL(string: API.searchURL) else { return }
        NetworkManager.shared.requestData(url: url, method: .get, parameters: parameters) { (result: Result<GiphyItem, Error>) in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.GIFs.append(contentsOf: response.data) // Append new data
                    completion()
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
}

