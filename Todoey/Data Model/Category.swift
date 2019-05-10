//
//  Category.swift
//  Todoey
//
//  Created by Rohit Chouhan on 5/9/19.
//  Copyright © 2019 Rohit Chouhan. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    @objc dynamic var name : String = ""
    @objc dynamic var color : String? 
    let items = List<Item>()
}
