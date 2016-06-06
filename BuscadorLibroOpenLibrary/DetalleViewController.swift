//
//  DetalleViewController.swift
//  BuscadorLibroOpenLibrary
//
//  Created by Juan Jose Renteria on 05/06/16.
//  Copyright © 2016 Juan Jose Renteria. All rights reserved.
//

import UIKit

class DetalleViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var barraBusqueda: UISearchBar!
    @IBOutlet weak var tituloLibro: UILabel!
    @IBOutlet weak var autoresText: UITextView!
    @IBOutlet weak var imagenLibro: UIImageView!
    @IBOutlet weak var botonGuardar: UIBarButtonItem!
    
    var libro: Libro?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        botonGuardar.enabled = false
        if libro != nil {
            tituloLibro.text = libro?.titulo
            autoresText.text = libro?.listaAutores()
            if let url = NSURL( string: (libro?.urlImagen)! ) {
                if let dataImage = NSData(contentsOfURL: url ) {
                    imagenLibro.image = UIImage(data: dataImage)
                }
            }
        } else {
            limpiarGui()
        }
    
    }


    
    // MARK: - Navigation

    @IBAction func cancelar(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
/*
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if botonGuardar === sender {
            let titulo = tituloLibro.text ?? ""
            let autores = autoresText.text
            //let imgUrl =
            // crear un nuevo libro
            
        }
 
    }
    
*/
    
    func limpiarGui() {
        tituloLibro.text = nil
        autoresText.text = nil
        imagenLibro.image = UIImage(named: "sin_portada.png")
    }

    // MARK: - SearchBar
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            limpiarGui()
        }
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        buscarLibro(searchBar.text)
    }
    
    //Efectua la busqueda por ISBN
    func buscarLibro(isbn: String?) {

        var msgError = ""
        var autores = ""
        limpiarGui()
        if isbn != nil {
            
            let urlConsulta = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=\(isbn!)"
            let url = NSURL(string: urlConsulta )
            let datos = NSData(contentsOfURL: url!)
            if datos != nil {
                do {
                                        
                    let json = try NSJSONSerialization.JSONObjectWithData(datos!, options: .MutableLeaves)
                    let llave = "\(isbn!)"
                
                    
                    // objeto principal
                    let dicRaiz = json as! NSDictionary as NSDictionary
                    if dicRaiz.count == 0 {
                        msgError = "No se encontro información el libro"
                        
                    } else {
                        
                        let dicLibro = dicRaiz.objectForKey( llave ) as! NSDictionary
                        
                        if dicLibro.count == 0 {
                            
                            msgError = "No se encontro información el libro"
                            
                        } else {
                            // Asignar titulo del libro
                            botonGuardar.enabled = true
                            if let titulo = dicLibro[ "title"] {
                                self.tituloLibro.text = titulo as? String
                            }
                            
                            libro = Libro(isbn: isbn!, titulo: self.tituloLibro.text!)
                            
                            // Asignar autores
                            if let listaAutores = dicLibro[ "authors" ]  {
                                
                                for autor in listaAutores as! NSArray {
                                    autores += autor[ "name" ] as! String
                                    autores += "\n"
                                    libro?.autores.append(autor["name"] as! String)
                                }
                                autoresText.text = autores
                                
                            }
                            
                            // Asignar portada de libroe
                            if let portadas = dicLibro[ "cover" ] as! NSDictionary? {
                                if let url = NSURL(string: portadas["small"] as! String) {
                                    let dataImage = NSData(contentsOfURL: url)
                                    libro!.urlImagen = portadas["small"] as? String
                                    imagenLibro.image = UIImage(data: dataImage!)
                                    
                                }
                            }
                        }
                    }
                    
                } catch  {
                    msgError = "Ocurrio al realizar la busqueda del libro"
                }
                
                
            } else {
                msgError = "Ocurrio al realizar la busqueda del libro"
            }
            
            // mostrar mensaje de error
            if !msgError.isEmpty {
                botonGuardar.enabled = false
                let alert = UIAlertController(title: "Error", message: msgError, preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                
            }
            
        }
        
    }


}
