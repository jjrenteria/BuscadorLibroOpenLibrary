//
//  LibroTableViewController.swift
//  BuscadorLibroOpenLibrary
//
//  Created by Juan Jose Renteria on 05/06/16.
//  Copyright © 2016 Juan Jose Renteria. All rights reserved.
//

import UIKit
import CoreData

class LibroTableViewController: UITableViewController {
    

    var listaLibros: [Libro] = []
    var libro : Libro?
    var habilitarAgregar = false
    var managedObjectContext: NSManagedObjectContext?

    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        managedObjectContext = appDelegate.managedObjectContext
        listaLibros = obtenerLibros()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaLibros.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CeldaLibro", forIndexPath: indexPath)
        
        cell.textLabel?.text = listaLibros[indexPath.row].titulo
        return cell
    }
 
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
       let vc = (segue.destinationViewController as! UINavigationController).topViewController as! DetalleViewController
        if segue.identifier == "MostrarLibroSegue" {
            // Se pasa el libro seleccionado
            vc.libro = listaLibros[ tableView.indexPathForSelectedRow!.row]
        }
 
    }
    
    @IBAction func unwindToLibrolLista(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? DetalleViewController, libro = sourceViewController.libro {
            let existe = Book.buscaLibro(libro.isbn, managedContext: managedObjectContext!)
          
            if !existe {
                let newIndexPath = NSIndexPath(forRow: listaLibros.count, inSection: 0)
            // Agrega el libro y sus datos 
                let book = Book.inserta(libro.isbn, titulo: libro.titulo, portada: libro.imagen!, managedContext: managedObjectContext!)
                for aut in libro.autores {
                    let autor = Autor.inserta(aut, libro: book, managedContext: managedObjectContext!)
                }
                do {
                    try managedObjectContext?.save()
                } catch {
                    print("error al guardar el libro")
                }

                listaLibros.append(libro)
            
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
            }
            
        }
    }
    
    //Obtiene los libros almacenados en la entidad Book
    
    func obtenerLibros() -> [Libro] {
        var lista: [Libro] = []
        
        let entity: NSEntityDescription = NSEntityDescription.entityForName("Book", inManagedObjectContext: managedObjectContext! )!
        let fetchRequest: NSFetchRequest = NSFetchRequest()
        fetchRequest.entity = entity
        
        do {
            let libros = try managedObjectContext!.executeFetchRequest(fetchRequest) as! [Book]
            
            for book in libros {
                var autorList:[String] = []
                for autor in book.autores! {
                    let nombre = (autor as! Autor).nombre
                    autorList.append( nombre! )
                }
                
                let libro = Libro(isbn: book.isbn!, titulo: book.titulo! )
                libro.imagen = book.portada
                libro.autores = autorList
                lista.append( libro )
            }
            
        } catch {
            print( "Error al ejecutar el query" )
        }
        return lista
    }
    
}
