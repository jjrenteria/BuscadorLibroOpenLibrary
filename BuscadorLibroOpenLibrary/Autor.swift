//
//  Autor.swift
//  BuscadorLibroOpenLibrary
//
//  Created by Juan Jose Renteria on 17/06/16.
//  Copyright © 2016 Juan Jose Renteria. All rights reserved.
//

import Foundation
import CoreData


class Autor: NSManagedObject {

    class func inserta( nombre:String , libro:Book, managedContext :NSManagedObjectContext   ) -> Autor {
        let autor = NSEntityDescription.insertNewObjectForEntityForName("Autor", inManagedObjectContext: managedContext) as! Autor
        autor.nombre = nombre
        autor.escribe = libro
        return autor
    }

}
