//
//  LibroTableViewController.swift
//  BuscadorLibroOpenLibrary
//
//  Created by Juan Jose Renteria on 05/06/16.
//  Copyright © 2016 Juan Jose Renteria. All rights reserved.
//

import UIKit

class LibroTableViewController: UITableViewController {
    

    var listaLibros: [Libro] = []
    var libro : Libro?
    var habilitarAgregar = false

    override func viewDidLoad() {
        super.viewDidLoad()
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
            let newIndexPath = NSIndexPath(forRow: listaLibros.count, inSection: 0)
            listaLibros.append(libro)
            tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
            
        }
    }
    
}
