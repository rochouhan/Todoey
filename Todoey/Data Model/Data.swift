//
//  Data.swift
//  Todoey
//
//  Created by Rohit Chouhan on 5/9/19.
//  Copyright © 2019 Rohit Chouhan. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object {
    // How to declare Realm properties 
    @objc dynamic var name: String = ""
}
