//
//  Libro.swift
//  BuscadorLibroOpenLibrary
//
//  Created by Juan Jose Renteria on 05/06/16.
//  Copyright © 2016 Juan Jose Renteria. All rights reserved.
//

import Foundation

class Libro {
    
    var isbn: String
    var titulo: String
    var autores: [String] = []
    var urlImagen: String?
    
    init(isbn:String, titulo:String) {
        self.isbn = isbn
        self.titulo = titulo
    }
    
    func listaAutores() -> String {
        var cadena = ""
        for a in autores {
            cadena += a + "\r"
        }
        return cadena
    }

}

