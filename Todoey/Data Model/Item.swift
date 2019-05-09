//
//  Item.swift
//  Todoey
//
//  Created by Rohit Chouhan on 5/9/19.
//  Copyright © 2019 Rohit Chouhan. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    // inverse relationship
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
