//
//  Listing.swift
//  classi
//
//  Created by Andrew Lawler on 22/03/2020.
//  Copyright © 2020 andrewlawler. All rights reserved.
//

import Foundation

struct Listing: Decodable {
    let location: Location
    let car: Car
    let _id: String
    let title: String
    let price: Int
    let description: String
    let userId: String
    let phone: String
    let email: String
    let timesViewed: Int
    let creationDate: String
    let __v: Int
}

struct Location: Decodable {
    let postcode: String
}

struct Car: Decodable {
    let make: String
    let model: String
    let year: Int
    let mileage: Int
}
