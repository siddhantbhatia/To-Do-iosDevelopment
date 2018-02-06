//
//  Item.swift
//  To-Do
//
//  Created by Sid on 05/02/2018.
//  Copyright © 2018 Siddhant Bhatia. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    
    @objc dynamic var itemName : String = ""
    @objc dynamic var itemDone : Bool = false
    @objc dynamic var dateCreated : Date = Date()
     
}
