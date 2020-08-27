//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Makwan BK on 5/8/20.
//  Copyright © 2020 Makwan BK. All rights reserved.
//

import UIKit
//import CoreData
import RealmSwift
import ChameleonFramework

class CategoryTableViewController: UITableViewController {
    
    var categories : Results<Category1>?
    
    let realm = try! Realm()
    
    //    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), landscapeImagePhone: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addItem))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "trash"), landscapeImagePhone: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(removeAll))
        
        
        
        config(largeTitleColor: .black, backgoundColor: .white, tintColor: UIColor(red: 0.06, green: 0.67, blue: 0.52, alpha: 1.00), title: "Category", preferredLargeTitle: true)
        
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.tableHeaderView = UIView(frame: .zero)
        tableView.separatorStyle = .none
        
        
    }
    
    @objc func addItem() {
        let ac = UIAlertController(title: "Add Category", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Add", style: .default, handler: { _ in
            
            guard let text = ac.textFields?[0].text else {return}
            
            let new = Category1()
            new.name = text
            new.color = UIColor.randomFlat().hexValue()
            
            self.saveData(category: new)
            
            //            let new = Category(context: self.context)
            //            new.name = text
            
            //            self.saveData()
            //            self.loadData()
        }))
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
    }
    
    @objc func removeAll() {
        let ac = UIAlertController(title: "Delete all categories", message: "Are you sure of that?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { _ in
            
            ///Core Data:
            //            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Category")
            //            let batch = NSBatchDeleteRequest(fetchRequest: request)
            //
            //            do {
            //                try self.context.execute(batch)
            //                self.saveData()
            //                self.loadData()
            //            } catch {
            //                print("error")
            //            }
            
            do {
                try self.realm.write {
                    self.realm.deleteAll()
                    self.tableView.reloadData()
                }
            } catch {
                print("error")
            }
            
            
            
            
        }))
        
        ac.addAction(UIAlertAction(title: "No", style: .cancel))
        present(ac, animated: true)
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "NO CATEGORIES"
        
        cell.textLabel?.textColor = ContrastColorOf(UIColor(hexString: categories![indexPath.row].color)!.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(categories!.count) - 0.2)!, returnFlat: false)
        
        cell.backgroundColor = UIColor(hexString: categories![indexPath.row].color)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        performSegue(withIdentifier: K.segue, sender: self)
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "TodoListView") as? TodoListViewController {
            
            vc.selectedCategory = categories?[indexPath.row]
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func loadData() {
        
        categories = realm.objects(Category1.self)
        
        self.tableView.reloadData()
        
        
        ///Core Data
        //        let request : NSFetchRequest<Category> = Category.fetchRequest()
        //
        //        do {
        //            categories = try context.fetch(request)
        //        } catch {
        //            print("Error while request the fetch.")
        //        }
        
    }
    
    func saveData(category: Category1) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Save REALM")
        }
        
        ///Core Data
        //        do {
        //            try context.save()
        //        } catch {
        //            print("Error while saving data.")
        //        }
        
        self.tableView.reloadData()
    }
    
    func config(largeTitleColor: UIColor, backgoundColor: UIColor, tintColor: UIColor, title: String, preferredLargeTitle: Bool) {
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            
            navBarAppearance.configureWithDefaultBackground()
            navBarAppearance.backgroundColor = backgoundColor
            
            navigationController?.navigationBar.standardAppearance = navBarAppearance
            navigationController?.navigationBar.compactAppearance = navBarAppearance
            navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
            
            navigationController?.navigationBar.prefersLargeTitles = preferredLargeTitle
            navigationController?.navigationBar.isTranslucent = false
            
            navigationController?.navigationBar.tintColor = tintColor
            navigationController?.navigationItem.largeTitleDisplayMode = .always
            navigationItem.title = title
            
        } else {
            // Fallback on earlier versions
            navigationController?.navigationBar.barTintColor = backgoundColor
            navigationController?.navigationBar.tintColor = tintColor
            navigationController?.navigationBar.isTranslucent = false
            navigationItem.title = title
        }
    }
    
}
