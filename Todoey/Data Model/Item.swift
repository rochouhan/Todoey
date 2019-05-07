//
//  Item.swift
//  Todoey
//
//  Created by Rohit Chouhan on 5/7/19.
//  Copyright © 2019 Rohit Chouhan. All rights reserved.
//

import Foundation

class Item : Encodable, Decodable {
    var done : Bool = false
    var title : String = ""
}
