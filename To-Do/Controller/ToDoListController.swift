//
//  ToDoListController.swift
//  To-Do
//
//  Created by Sid on 30/01/2018.
//  Copyright © 2018 Siddhant Bhatia. All rights reserved.
//

import UIKit
import CoreData

class ToDoListController: UITableViewController {
    
    var itemArray = [Item]()
    
    var selectedCategory : Category?{
        didSet{
            loadData()
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
   }

    // MARK: - Table view data source

    // TODO: function to set the number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }
    
    // TODO: setting the content of each cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)

        cell.textLabel?.text = itemArray[indexPath.row].itemName
        
        //TODO: Setting checkmark Using ternary operation
        
        cell.accessoryType = itemArray[indexPath.row].itemDone ? .checkmark : .none
        
        return cell
    }
    
    
    // MARK: - Table view delegate methods
    
    // function responsible for actions when a row is touched
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        // TODO: return a reference to the cell at indexpath i.e the cell that is selected by user
        //     ^|---> tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
//        if itemArray[indexPath.row].itemDone == false
//        {
//            itemArray[indexPath.row].itemDone = true
//        }
//        else
//        {
//            itemArray[indexPath.row].itemDone = false
//        }
        
//        //deleting items
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        // replacement of above code ^^
        itemArray[indexPath.row].itemDone = !itemArray[indexPath.row].itemDone
        
        //saving data when the done property that is checkmark is changed.
        self.saveData()
        
        // we do the below step to make table view run the above method so that TODO setting checkmark can be done.
        // This method will set the property of class item to be false but does not set the property of cell to display checkmark
        // thus reloading table to view to run all its functions and put checkmark for the cells which are touched.
        tableView.reloadData()


        // TODO:  to remove the gray highlight like a flash
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
            
            //add item to the array of items
            let item = Item(context: self.context)
            item.itemName = textFieldFromAlert.text!
            item.itemDone = false
            item.parentCategory = self.selectedCategory
            
            self.itemArray.append(item)
            
            //saving data
            self.saveData()
            
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
    
    func saveData()
    {
        do{
            try context.save()
        }
        catch{
            print("\n\nError saving: \(error)")
        }
    }
    
    func loadData(with request : NSFetchRequest<Item> = Item.fetchRequest(), andPredicate predicate: NSPredicate? = nil)
    {
        let categoryPredicate = NSPredicate(format: "parentCategory.categoryName MATCHES %@ ", selectedCategory!.categoryName!)
        
        // because of the paramter predicate can be optional we need to do optional binding of the predicate recieved from function caller
        
        if let additionalPredicate = predicate{
            let compundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
            
            request.predicate = compundPredicate
        }
        else{
            request.predicate = categoryPredicate
        }
        
        
        do{
            itemArray = try context.fetch(request)
        }
        catch{
            print("\n\nError retrieving: \(error)")
        }
    }
    
}

//MARK: - Search bar methods

extension ToDoListController : UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "itemName CONTAINS[cd] %@", searchBar.text!)
        
        request.predicate = predicate
        
        let sortDescriptor = NSSortDescriptor(key: "itemName", ascending: true)
        
        request.sortDescriptors = [sortDescriptor]
        
        loadData(with: request, andPredicate: predicate)
        
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
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

