//
//  User.swift
//  classi
//
//  Created by Andrew Lawler on 23/03/2020.
//  Copyright © 2020 andrewlawler. All rights reserved.
//

import Foundation

struct User: Decodable {
    let avatarUrl: String?
    let favorites: [String]
    let _id: String
    let name: String
    let email: String
    let password: String
    let registerDate: String
    let __v: Int
}

