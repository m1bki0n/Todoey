//
//  Category.swift
//  Todoey
//
//  Created by Philipp Muellauer on 29/11/2019.
//  Copyright © 2019 Philipp Muellauer. All rights reserved.
//

import Foundation
import RealmSwift

class Category1: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""
    let items = List<Item1>()
}
