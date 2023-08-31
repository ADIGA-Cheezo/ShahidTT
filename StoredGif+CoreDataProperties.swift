//
//  StoredGif+CoreDataProperties.swift
//  ShahidTT
//
//  Created by atsmac on 31/08/2023.
//
//

import Foundation
import CoreData


extension StoredGif {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StoredGif> {
        return NSFetchRequest<StoredGif>(entityName: "StoredGif")
    }

    @NSManaged public var title: String?
    @NSManaged public var datumDescription: String?
    @NSManaged public var imageURLString: String?
    @NSManaged public var associatedEmail: String?

}

extension StoredGif : Identifiable {

}
