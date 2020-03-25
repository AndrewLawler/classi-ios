//
//  Auth.swift
//  classi
//
//  Created by Andrew Lawler on 23/03/2020.
//  Copyright © 2020 andrewlawler. All rights reserved.
//

import Foundation

struct Auth: Decodable {
    let token: String
    let user: UserAuth
}

struct UserAuth: Decodable {
    let id: String
    let name: String
    let email: String
}
