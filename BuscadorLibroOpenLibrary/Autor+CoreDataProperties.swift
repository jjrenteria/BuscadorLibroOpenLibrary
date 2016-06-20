//
//  Autor+CoreDataProperties.swift
//  BuscadorLibroOpenLibrary
//
//  Created by Juan Jose Renteria on 17/06/16.
//  Copyright © 2016 Juan Jose Renteria. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Autor {

    @NSManaged var nombre: String?
    @NSManaged var escribe: Book?

}
