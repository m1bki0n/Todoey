//
//  Item.swift
//  Todoey
//
//  Created by Makwan BK on 5/8/20.
//  Copyright © 2020 Makwan BK. All rights reserved.
//

import Foundation
import RealmSwift

//--> Item name is already exist on the core data model, so we can't use the same name here again.
class Item1: Object {
    
    @objc dynamic var title : String = ""
    @objc dynamic var checkmark: Bool = false
    @objc dynamic var createdDate : Date?
    
    //LinkingObjects is like one-to-one relationship.
    var parentCategory = LinkingObjects(fromType: Category1.self, property: "items")
}
