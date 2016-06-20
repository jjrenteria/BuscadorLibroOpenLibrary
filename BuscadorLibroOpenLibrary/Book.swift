//
//  Book.swift
//  BuscadorLibroOpenLibrary
//
//  Created by Juan Jose Renteria on 17/06/16.
//  Copyright © 2016 Juan Jose Renteria. All rights reserved.
//

import Foundation
import CoreData


class Book: NSManagedObject {
    
    class func inserta( isbn:String , titulo:String, portada: NSData, managedContext :NSManagedObjectContext   ) -> Book {
        let book = NSEntityDescription.insertNewObjectForEntityForName("Book", inManagedObjectContext: managedContext) as! Book
        book.isbn = isbn
        book.titulo = titulo
        book.portada = portada
        return book
    }

    
    class func buscaLibro( isbn: String, managedContext :NSManagedObjectContext ) -> Bool {
        var existe = false
        let entity = NSEntityDescription.entityForName("Book", inManagedObjectContext: managedContext )!
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = entity
        fetchRequest.predicate = NSPredicate(format: "isbn == %@", isbn )
        do {
            let libros = try managedContext.executeFetchRequest(fetchRequest) as! [Book]
            existe =  libros.count > 0
        } catch {
            print( "error al ejecutar el query")
        }
        
        return existe
    }

}
