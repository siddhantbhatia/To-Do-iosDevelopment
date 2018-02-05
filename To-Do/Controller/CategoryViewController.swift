//
//  CategoryViewController.swift
//  To-Do
//
//  Created by Sid on 03/02/2018.
//  Copyright © 2018 Siddhant Bhatia. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        
    }

    ////////////////////////////////////////////////////////////////////////
    // MARK: - Table view data source
    ////////////////////////////////////////////////////////////////////////

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)

        cell.textLabel?.text = categoryArray[indexPath.row].categoryName

        return cell
    }
    
    ////////////////////////////////////////////////////////////////////////
    // MARK: - Tableview Delegate Methods
    ////////////////////////////////////////////////////////////////////////
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItem", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    

    ////////////////////////////////////////////////////////////////////////
    // MARK: - Add new categories
    ////////////////////////////////////////////////////////////////////////
    
    @IBAction func addButtonPressed(_ sender: Any)
    {
        var textFieldFromAlert = UITextField()
        
        //TODO: adding an alert
        let alert = UIAlertController(title: "Add item", message: "Enter a new Category", preferredStyle: .alert)
        
        // creating action for that alert
        let additionAction = UIAlertAction(title: "Add", style: .default)
        { (action) in
            
            //add item to the array of items
            let category = Category(context: self.context)
            category.categoryName = textFieldFromAlert.text!
            
            self.categoryArray.append(category)
            
            //saving data
            self.saveData()
            
        }
        //TODO: adding textfield to that alert
        alert.addTextField { (addCategoryTextField) in
            
            //the text that appears in gray when the text box is not selected
            addCategoryTextField.placeholder = "Type in your item"
            
            textFieldFromAlert = addCategoryTextField
        }
        
        //add action to alert
        alert.addAction(additionAction)
        
        //presenting the action
        present(alert, animated: true, completion: nil)
        
    }
    
    ////////////////////////////////////////////////////////////////////////
    // MARK: - Saving and Restoring Data
    ////////////////////////////////////////////////////////////////////////
    
    func saveData()
    {
        do{
            try context.save()
        }
        catch{
            print("\n\nError saving data to Category Entity : \(error)")
        }
        
        // relaod the tableview to display the new contents of the array
        self.tableView.reloadData()
    }
    
    func loadData(with request: NSFetchRequest<Category> = Category.fetchRequest())
    {
        do{
            categoryArray = try context.fetch(request)
        }
        catch{
            print("\n\nError retrieving from Category Entity: \(error)")
        }
    }
    
}
