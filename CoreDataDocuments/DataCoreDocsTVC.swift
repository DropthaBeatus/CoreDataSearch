//
//  DataCoreDocsTVC.swift
//  CoreDataDocuments
//
//  Created by Liam Flaherty on 9/21/18.
//  Copyright © 2018 Liam Flaherty. All rights reserved.
//

import UIKit
import CoreData

class DataCoreDocsTVC: UITableViewController {

    @IBOutlet var DocumentCell: UITableView!
    //so the search bar is not tied down by the UISearchController and results can be updated in the TabelViewController
    let searchBar = UISearchController(searchResultsController: nil)
    //turns out you only need one array
    var docData:[CoreData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        setupSearchController()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return docData.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DataCoreDocTableViewCell
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy h:mm"
        let dateCell = dateFormatter.string(from:docData[indexPath.row].dateModCD! as Date)
        let fileSizeCell = String(docData[indexPath.row].fileSizeCD)
        let docLabel = docData[indexPath.row].name

        cell.DateLabel.text = String(dateCell)

        cell.SizeLabel.text = fileSizeCell + " bytes"
        cell.DocumentLabel.text = docLabel
            
        return cell
    }

func deleteDocument(at indexPath: IndexPath) {
        let document = docData[indexPath.row]
        let row = indexPath.row
        if let managedObjectContext = document.managedObjectContext {
            managedObjectContext.delete(document)
            deleteData(index: row)
            do {
                try managedObjectContext.save()
                
                DocumentCell.deleteRows(at: [indexPath], with: .automatic)
            } catch {
                print("Could not delete row")
            }
            
        }
        DocumentCell.reloadData()
    }
    
    func deleteData(index: Int){
        docData.remove(at: index)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteDocument(at: indexPath)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<CoreData> = CoreData.fetchRequest()
        
        do{
            docData = try managedContext.fetch(fetchRequest)
            
            DocumentCell.reloadData()
        } catch {
            print("Could not fetch Documents")
        }
    }
        
        
//So I should not create a search bar in the UI controller statically
//This is important as a lot of people say statically creating it is bad
        func setupSearchController() {
            definesPresentationContext = true
            searchBar.dimsBackgroundDuringPresentation = false
            
            searchBar.searchResultsUpdater = self as UISearchResultsUpdating
            searchBar.searchBar.barTintColor = UIColor(white: 0.9, alpha: 0.9)
            //prevents nav bar from hiding during search
            searchBar.hidesNavigationBarDuringPresentation = false
            
            tableView.tableHeaderView = searchBar.searchBar
        }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     if segue.identifier == "Push", let destination = segue.destination as? TextViewViewController,
     let row = DocumentCell.indexPathForSelectedRow?.row {
        destination.document = docData[row]
     }
      
     }
    
    func filterRowsForSearchedText(_ searchText: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        if(!searchBar.isActive || searchBar.searchBar.text == ""){
            viewWillAppear(true)
        }
        else{
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<CoreData> = CoreData.fetchRequest()
        
        //okay this part was fun 
        fetchRequest.predicate = NSCompoundPredicate(type: .or, subpredicates: [NSPredicate(format: "content CONTAINS[cd] %@", searchText), NSPredicate(format: "name CONTAINS[cd] %@", searchText)])
        do{
            docData = try managedContext.fetch(fetchRequest)
        }
        catch{
            print("Could not filter results")
        }
        self.tableView.reloadData()
    }
    }
    
    
}

extension DataCoreDocsTVC : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let term = searchController.searchBar.text {
            filterRowsForSearchedText(term)
        }
    }
}
