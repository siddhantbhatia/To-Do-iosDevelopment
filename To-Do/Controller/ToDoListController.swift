//
//  ToDoListController.swift
//  To-Do
//
//  Created by Sid on 30/01/2018.
//  Copyright © 2018 Siddhant Bhatia. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListController: UITableViewController {
    
    var todoItems : Results<Item>?
    
    let realm = try! Realm()
    
    var selectedCategory : Category?
    {
        didSet{
            loadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
   }

    // MARK: - Table view data source

    // TODO: function to set the number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return todoItems?.count ?? 1
    }
    
    // TODO: setting the content of each cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row]
        {
            cell.textLabel?.text = item.itemName
            
            //TODO: Setting checkmark Using ternary operation
            
            cell.accessoryType = item.itemDone ? .checkmark : .none
        }
        else{
            cell.textLabel?.text = "No item added yet"
        }
        
        return cell
    }
    
    
    // MARK: - Table view delegate methods
    
    // function responsible for actions when a row is touched
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if let item = todoItems?[indexPath.row]
        {
            do{
                try realm.write {
                    
                    // realm.delete(item)
                    item.itemDone = !item.itemDone
                }
            }catch{
                print("Error updating the done status of item: \(error)")
            }
        }
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add items to the to do list
    @IBAction func addItems(_ sender: UIBarButtonItem)
    {
        var textFieldFromAlert = UITextField()
        
        //TODO: adding an alert
        let alert = UIAlertController(title: "Add item", message: "Please enter the item you would like to add", preferredStyle: .alert)
        
        // creating action for that alert
        let additionAction = UIAlertAction(title: "Add", style: .default)
        { (action) in
            
            if let currentCategory = self.selectedCategory{
                do{
                    try self.realm.write
                    {
                        let item = Item()
                        item.itemName = textFieldFromAlert.text!
                        currentCategory.items.append(item)
                    }
                }
                catch{
                    print("Error saving item to category \(error)")
                }
            }
            
            // relaod the tableview to display the new contents of the array
            self.tableView.reloadData()
        }
        
        //TODO: adding textfield to that alert
        alert.addTextField { (addItmeTextField) in
            
            //the text that appears in gray when the text box is not selected
            addItmeTextField.placeholder = "Type in your item"
            
            textFieldFromAlert = addItmeTextField
            
        }
        
        //add action to alert
        alert.addAction(additionAction)
        
        //presenting the action
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: Save and Restoring Method
    
    func loadData()
    {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "itemName", ascending: true)
    }
    
}

//MARK: - Search bar methods

extension ToDoListController : UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("itemName CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)

        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchBar.text?.count == 0
        {
            loadData()
            tableView.reloadData()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}




    
 