//
//  ViewController.swift
//  Todoey
//
//  Created by Makwan BK on 5/8/20.
//  Copyright © 2020 Makwan BK. All rights reserved.
//

import UIKit
//import CoreData
import RealmSwift
import ChameleonFramework

class TodoListViewController: UITableViewController, UISearchControllerDelegate, UISearchBarDelegate {
    
    let realm = try! Realm()
    
    var items : Results<Item1>?
    
    var selectedCategory : Category1? {
        didSet {
            loadData()
        }
    }
    
    
    //    let defaults = UserDefaults.standard
    
    //    let manager = FileManager.default
    
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = selectedCategory!.name
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), landscapeImagePhone: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addItem))
        //        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "trash"), landscapeImagePhone: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(removeAll))
        
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.tableHeaderView = UIView(frame: .zero)
        tableView.separatorStyle = .none
        
        
        searchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
//        self.navigationController?.navigationBar.backgroundColor = UIColor(hexString: selectedCategory!.color)
        
        UINavigationBarAppearance().backgroundColor = UIColor(hexString: selectedCategory!.color)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.viewWillAppear(true)
        
//        self.navigationController?.navigationBar.backgroundColor = .white
        
        UINavigationBarAppearance().backgroundColor = .white
    }
    
    //MARK:- Table View data source methods:
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)
        
        
        if let item = items?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            cell.textLabel?.textColor = ContrastColorOf(UIColor(hexString: selectedCategory!.color)!.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(items!.count) - 0.2)!, returnFlat: false)
            
            cell.accessoryType = item.checkmark ? .checkmark : .none
            
            cell.backgroundColor = UIColor(hexString: selectedCategory!.color)!.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(items!.count) - 0.2)
            
            
            
        } else {
            cell.textLabel?.text = "Oops! There's no item here!"
        }
        
        cell.textLabel?.font = UIFont(name: "SF-Mono-Medium", size: 18)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        
        if let item = items?[indexPath.row] {
            do {
                try realm.write {
                    item.checkmark.toggle()
                    
                    cell.accessoryType = item.checkmark ? .checkmark : .none
                }
            } catch {
                print("item check.")
            }
        }
        
        
        tableView.reloadData()
        
        
//        items[indexPath.row].checkmark.toggle()
//        try? context.save()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    @objc func addItem() {
        let ac = UIAlertController(title: "Add Item", message: nil, preferredStyle: .alert)
        ac.addTextField { field in
            field.placeholder = "Type the new item here."
        }
        ac.addAction(UIAlertAction(title: "Add", style: .default, handler: { _ in
            guard let text = ac.textFields?[0].text else {return}
            
            if let currentCategory = self.selectedCategory {
                do {
                    
                    try self.realm.write {
                        
                        let newItem = Item1()
                        newItem.title = text
                        newItem.checkmark = false
                        newItem.createdDate = Date()
                        currentCategory.items.append(newItem)
                        
                    }
                    
                } catch {
                    print("")
                }
                
            }
            
            self.tableView.reloadData()
            
            
            
            ///Core Data
//            // UIApplication.shared.delegate is acts like AppDelegate
//            let item = Item(context: self.context)
//            item.title = text
//            item.parentCategory = self.selectedCategory
//            item.checkmark = false
//
//            do {
//                try self.context.save()
//                self.items.append(item)
//            } catch {
//                print("Got a error while saving the data to Core Data.")
//            }
            
            self.tableView.reloadData()
            
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
    }
    
    @objc func removeAll() {
        let ac = UIAlertController(title: "Remove All?", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { _ in
            
            
            
//            let deleteRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
//            let batch = NSBatchDeleteRequest(fetchRequest: deleteRequest)
//
//            self.items.removeAll()
//
//            do {
//                try self.context.execute(batch)
//                try self.context.save()
//            } catch {
//                print("error")
//            }
            
            self.tableView.reloadData()
            
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
    }
    
    ///Swipe to delete without an image:
    //    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    //
    //
    //        if editingStyle == .delete {
    //            self.items.remove(at: indexPath.row)
    //            self.tableView.deleteRows(at: [indexPath], with: .fade)
    //        }
    //    }
    
    ///Swipe to delete with an image:
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action =  UIContextualAction(style: .normal, title: "Delete") { (action, view, complication) in
            
            if let item = self.items?[indexPath.row] {
                do {
                    try self.realm.write {
                        self.realm.delete(item)
                    }
                } catch {
                   print("error!!!")
                }
            }
            
            self.tableView.reloadData()
            
            ///Core Data
//            self.context.delete(self.items[indexPath.row])
//            self.items.remove(at: indexPath.row)
//            try? self.context.save()
            
            
//            self.tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
        action.image = UIImage(systemName: "trash")
        action.backgroundColor = .red
        let configuration = UISwipeActionsConfiguration(actions: [action])
        
        return configuration
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    //MARK:- Core Data methods:
    
    func saveData(item: Item1) {
        
        
//        do {
//            try realm.write {
//                realm.add(item)
//            }
//        } catch {
//            print("error!")
//        }
//
//        tableView.reloadData()
        
//        do {
//            try context.save()
//        } catch {
//            print("Error while save data to Core Data.")
//        }
    }
    
    //    func loadData(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
    //
    //
    //        ///Core Data
    ////        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
    ////
    ////        if let additionalPredicate = predicate {
    ////            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
    ////        } else {
    ////            request.predicate = categoryPredicate
    ////        }
    ////
    ////
    ////        do {
    ////            items = try context.fetch(request)
    ////        } catch {
    ////            print("Error while fetch data from Core Data")
    ////        }
    //
    //        tableView.reloadData()
    //    }
    
    func loadData() {
        
        items = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
    //MARK:- Save data to the disk.
    //We don't neet this while we use Core Data.
//    func getsDocumentDirectory() -> URL {
//        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        return paths[0]
//    }
    
    //MARK:- Search bar method and delegates:
    
    func searchBar() {
        let searchbar = UISearchController(searchResultsController: nil)
        searchbar.searchBar.delegate = self
        searchbar.searchBar.placeholder = "Search for an item."
        navigationItem.searchController = searchbar
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        items = items?.filter("title CONTAINS %@", searchBar.text!).sorted(byKeyPath: "createdDate", ascending: true)
    
        tableView.reloadData()
        
        ///Core Data
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//
//        //NSPredicate is a class that provide filtering.
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        if searchBar.text != "" {
//            loadData(with: request, predicate: predicate)
//        }
    }
    
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//            let request : NSFetchRequest<Item> = Item.fetchRequest()
//
//            loadData(with: request)
//    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        loadData()
    }
    
}

