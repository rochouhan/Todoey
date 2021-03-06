//
//  ViewController.swift
//  Todoey
//
//  Created by Rohit Chouhan on 5/6/19.
//  Copyright © 2019 Rohit Chouhan. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift
import ChameleonFramework
class TodoListViewController: SwipeTableViewController {
    var toDoItems : Results<Item>?
    //Declare path to all user data found in the user domain mask (user's home directory for this app).
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    
    let realm = try! Realm()
    
    @IBOutlet weak var searchBar: UISearchBar!

    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.separatorStyle = .none
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let colorHex = selectedCategory?.color else {fatalError()}
        title = selectedCategory?.name
        updateNavBar(withHexCode: colorHex)
        
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        updateNavBar(withHexCode: "1D9BF6")
    }
    
    // MARK: - Nav Bar Setup Code
    
    func updateNavBar(withHexCode colorHexCode: String) {
        guard let navBar = navigationController?.navigationBar else {fatalError("Navbar is nil")}
        guard let navBarColor = UIColor(hexString: colorHexCode) else { fatalError() }
        navBar.barTintColor = navBarColor
        navBar.tintColor = UIColor(contrastingBlackOrWhiteColorOn: navBarColor, isFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : navBar.tintColor!]
        searchBar.barTintColor = navBarColor
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = toDoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            if let colorValue = selectedCategory?.color  {
                cell.backgroundColor = UIColor.init(hexString: colorValue).darken(byPercentage: CGFloat(indexPath.row) / CGFloat(toDoItems!.count))
            }
            cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn: cell.backgroundColor!, isFlat: true)
            cell.accessoryType = item.done ? .checkmark : .none
        }
        else {
            cell.textLabel?.text = "No items added"
        }
        return cell
    }
    
    // MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        toDoItems[indexPath.row].done = !toDoItems[indexPath.row].done
////        context.delete(itemArray[indexPath.row])
////        itemArray.remove(at: indexPath.row)
//        saveItems()
        
        if let item = toDoItems?[indexPath.row] {
            do {
                try realm.write {
//                    realm.delete(item)
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status, \(error)")
            }
            tableView.reloadData()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            //What will happen when user clicks the Add Item button on the UI Alert
            if (!textField.text!.isEmpty) {
                if let currentCategory = self.selectedCategory {
                    do {
                        try self.realm.write {
                            //Create and write item 
                            let newItem = Item()
                            newItem.title = textField.text!
                            newItem.dateCreated = Date()
                            // Don't need to call realm.add because the category object has already been added.
                            currentCategory.items.append(newItem)
                        }
                    } catch {
                        print("Error with saving categories, \(error)")
                    }
                }
                self.tableView.reloadData()
            }
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Model Manipulation Methods
    func save(item : Item) {
        
        do {
            try realm.write {
                realm.add(item)
            }
        } catch {
            print("Error with saving categories, \(error)")
        }
        tableView.reloadData()
    }
    
    func loadItems() {
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        super.updateModel(at: indexPath)
        if let items = self.toDoItems?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(items)
                    
                }
            } catch {
                print("Error deleting item, \(error)")
            }
            
        }
    }
}

// MARK: - Search Bar methods
extension TodoListViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchData(for: searchBar.text!)

    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchBar.text!.isEmpty) {
            loadItems()
            // Dismisses keyboard and active search bar and puts it back in previous state.
            // Run this on the main queue/thread.
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
        else {
            searchData(for: searchText)
        }
    }

    func searchData(for searchText : String) {
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchText).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    
    
}

