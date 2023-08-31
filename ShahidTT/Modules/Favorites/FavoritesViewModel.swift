//
//  FavoritesViewModel.swift
//  ShahidTT
//
//  Created by atsmac on 31/08/2023.
//

import Foundation

class FavoritesViewModel {
    var photos: [Datum] = []
    
    // Load photos from Core Data and populate the array
    func loadPhotos(forUser username: String) {
        // Fetch photos for the given username
        // Update 'photos' array
        
        // For example:
        // photos = CoreDataHelper.fetchPhotosForUser(username: username)
    }
    
    // Toggle favorite status for a photo
    func toggleFavoriteStatus(for GIF: Datum) {
        // Update 'isFavorite' property of the photo in Core Data
        // Update the 'photos' array
    }
}
