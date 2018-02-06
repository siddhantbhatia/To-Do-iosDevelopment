//
//  Category.swift
//  To-Do
//
//  Created by Sid on 05/02/2018.
//  Copyright © 2018 Siddhant Bhatia. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var categoryName : String = ""
    
    let items = List<Item>()
}
