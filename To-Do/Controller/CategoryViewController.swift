//
//  CategoryViewController.swift
//  To-Do
//
//  Created by Sid on 03/02/2018.
//  Copyright © 2018 Siddhant Bhatia. All rights reserved.
//

import UIKit
import RealmSwift
class CategoryViewController: UITableViewController {
    
    var categories : Results<Category>?
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        
    }

    ////////////////////////////////////////////////////////////////////////
    // MARK: - Table view data source
    ////////////////////////////////////////////////////////////////////////

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)

        cell.textLabel?.text = categories?[indexPath.row].categoryName ?? "No category added yet"

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
            destinationVC.selectedCategory = categories?[indexPath.row]
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
            let newCategory = Category()
            newCategory.categoryName = textFieldFromAlert.text!
            
            
            //saving data
            self.saveData(category: newCategory)
            
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
    
    func saveData(category : Category)
    {
        do{
            try realm.write {
                realm.add(category)
            }
        }
        catch{
            print("\n\nError saving data to Realm : \(error)")
        }
        
        // relaod the tableview to display the new contents of the array
        self.tableView.reloadData()
    }
    
    func loadData()
    {
        categories = realm.objects(Category.self)
        
    }
    
}
