//
//  ViewController.swift
//  To-Do List (CoreData)
//
//  Created by Elbek Shaykulov on 9/11/20.
//  Copyright © 2020 Elbek Shaykulov. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UITableViewController{

    var items = [Item]()
    
    var selectedCategory : Category?
    {
        didSet{
            fetchData()
        }
    }
    
    
    let memory = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    override func viewDidLoad() {
        super.viewDidLoad()
          
    }

    
    //MARK: - DATASOURCE methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath)
        
        cell.textLabel?.text = items[indexPath.row].title
         cell.accessoryType = items[indexPath.row].done ? .checkmark : .none
        
        return cell
    }
    
    //MARK: - DELEGATE methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        items[indexPath.row].done = !items[indexPath.row].done
        tableView.deselectRow(at: indexPath, animated: true)
        save()
    }
    
    //MARK: - ADDing items
    
    
    @IBAction func addItem(_ sender: UIBarButtonItem)
    {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newItem = Item(context: self.memory)
            newItem.title = textField.text
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.items.append(newItem)
            
            self.save()
            
            
        }
        
        alert.addAction(action)
        alert.addTextField { (text) in
            textField = text
            textField.placeholder = "Add a new item"
        }
        
        present(alert,animated: true,completion: nil)
         
    }
    
    
    
    
    //MARK: - DATA saving AND fetching
    func save()
    {
        do{
            try memory.save()
        }catch{
        print("Error saving the data\(error)")
        }
        tableView.reloadData()
    }
    
    
    func fetchData(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil)
    {
          let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
          
          if let addtionalPredicate = predicate {
              request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, addtionalPredicate])
          } else {
              request.predicate = categoryPredicate
          }

          
          do {
              items = try memory.fetch(request)
          } catch {
              print("Error fetching data from context \(error)")
          }
          
          tableView.reloadData()
          
         
    }
    
    

}



//MARK: - SEARCH Bar


extension ViewController: UISearchBarDelegate
{
     func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

         let request : NSFetchRequest<Item> = Item.fetchRequest()
     
         let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
         
         request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
         
         fetchData(with: request, predicate: predicate)
         
     }
     
     func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
         if searchBar.text?.count == 0 {
             fetchData()
             
             DispatchQueue.main.async {
                 searchBar.resignFirstResponder()
             }
           
         }
     }
}
