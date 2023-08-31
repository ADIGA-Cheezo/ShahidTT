//
//  FavoritesViewModel.swift
//  ShahidTT
//
//  Created by atsmac on 31/08/2023.
// this was the most difficult part, i realise i should have created a relation between the user entity and storedGif however that seemed too complicated for the time windows i have to complete this assignment.

import Foundation
import UIKit
import CoreData

class FavoritesViewModel {
    var images: [NSManagedObject] = []
    
    // Load photos from Core Data and populate the array
    func loadPhotos(forUser username: String) -> [NSManagedObject]{
        images = []
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return []}
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "StoredGif")
        request.predicate = NSPredicate(format: "associatedEmail = %@", username)
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                print(data.value(forKey: "title") as? String ?? "No title")
                images.append(data)
            }
            return images
        } catch {
            print("Failed")
            return []
        }
    }
    
    // Toggle favorite status for a photo
    func toggleFavoriteStatus(for GIF: Datum) {
        createData(GIF)
    }
    
    private func createData(_ GIF: Datum) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "StoredGif")
        fetchRequest.predicate = NSPredicate(format: "title == %@ AND associatedEmail == %@", GIF.title, UserDataManager.shared.username)
        
        do {
            if let result = try context.fetch(fetchRequest) as? [NSManagedObject], let existingObject = result.first {
                context.delete(existingObject) // Remove the existing object with matching attributes
            }
            else {
                let entity = NSEntityDescription.entity(forEntityName: "StoredGif", in: context)
                let newUser = NSManagedObject(entity: entity!, insertInto: context)
                
                newUser.setValue(GIF.title, forKey: "title")
                newUser.setValue(GIF.images.downsizedMedium.url, forKey: "imageURLString")
                newUser.setValue(GIF.title, forKey: "datumDescription")
                newUser.setValue(UserDataManager.shared.username, forKey: "associatedEmail")
            }
                try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
