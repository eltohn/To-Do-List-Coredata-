//
//  CategoryViewController.swift
//  To-Do List (CoreData)
//
//  Created by Elbek Shaykulov on 9/11/20.
//  Copyright © 2020 Elbek Shaykulov. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categories = [Category]()
    
    let memory = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        fetchData()
        
        print( NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true))
    }
    
    
    //MARK: - DATASOURCE
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Category", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        return cell
        
    }
    
    
    
    
    
    
    //MARK: - DELEGATE
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let destinationVC = segue.destination as! ViewController
        
        if let indexPath = tableView.indexPathForSelectedRow
        {
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }
 
    
    
    
    
    
    // ADD BUTTON
    
    @IBAction func addCategory(_ sender: UIBarButtonItem)
    {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
         
            
            let newCategory = Category(context: self.memory)
            newCategory.name = textField.text
            self.categories.append(newCategory)
            self.save()
            
        }
        
        alert.addAction(action)
        alert.addTextField { (alertText) in
            textField = alertText
            textField.placeholder = "Add a new Category"
             
         
        }
        
        present(alert,animated: true,completion: nil)
        
        
    }
    
    
    
    
    
    
    
    //MARK: - SAVING and FETCHING categories
    
    func save()
    {
        do{
            try memory.save()
        }catch{
        print("Error saving : \(error)")
        }
        tableView.reloadData()
    }
    
    func fetchData()
    {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        
        do{
            categories = try memory.fetch(request)
        }catch{
             print("Error loading categories \(error)")
        }
         
         tableView.reloadData()
    }
    
    
}





 
