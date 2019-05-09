//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Rohit Chouhan on 5/8/19.
//  Copyright © 2019 Rohit Chouhan. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class CategoryViewController: UITableViewController {
    var categories : Results<Category>!
    
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            if !textField.text!.isEmpty {
                let category = Category()
                category.name = textField.text!
                self.save(category: category)
            }
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Category"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source methods


    // MARK: - Table view delegate methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet"
        return cell 
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    //MARK: - Data manipulation methods
    func loadCategories() {
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    func save(category : Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error with saving categories, \(error)")
        }
        tableView.reloadData()
    }

}
