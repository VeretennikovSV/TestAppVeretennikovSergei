//
//  ChildModel.swift
//  TestAppVeretennikovSergei
//
//  Created by Сергей Веретенников on 25/10/2022.
//

import Foundation

struct Child {
    var name: String
    var age: Int
    
    init() {
        name = ""
        age = 0
    }
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}
