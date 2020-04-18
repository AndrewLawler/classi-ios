//
//  NetworkManager.swift
//  classi
//
//  Created by Andrew Lawler on 22/03/2020.
//  Copyright © 2020 andrewlawler. All rights reserved.
//

import UIKit

enum ClassiError: String, Error {
    case errorSearching    = "There has been an error while searching. Please try again."
}

class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    
    let baseURL = "https://classi-server.herokuapp.com/api/"
    
    func getAllUsers(completed: @escaping (Result<[User], ClassiError>) -> Void) {
        
        let endpoint = baseURL + "users"

        guard let url = URL(string: endpoint) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let _ = error {
                completed(.failure(.errorSearching))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.errorSearching))
                return
            }
            
            guard let data = data else {
                completed(.failure(.errorSearching))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let listingArray = try decoder.decode([User].self, from: data)
                completed(.success(listingArray))
                
            } catch {
                completed(.failure(.errorSearching))
            }
            
        }
        
        task.resume()
        
    }
    
    
    func getAllListings(completed: @escaping (Result<[Listing], ClassiError>) -> Void) {
        
        let endpoint = baseURL + "listings"

        guard let url = URL(string: endpoint) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let _ = error {
                print("here 1")
                completed(.failure(.errorSearching))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("here 2")
                completed(.failure(.errorSearching))
                return
            }
            
            guard let data = data else {
                print("here 3")
                completed(.failure(.errorSearching))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let listingArray = try decoder.decode([Listing].self, from: data)
                completed(.success(listingArray))
                
            } catch {
                print("here 4")
                completed(.failure(.errorSearching))
            }
            
        }
        
        task.resume()
        
    }
    
    func authoriseUser(email: String, password: String, completed: @escaping (Result<Auth, ClassiError>) -> Void) {
        
        let endpoint = baseURL + "auth"

        guard let url = URL(string: endpoint) else {
            return
        }

        var authRequest = URLRequest(url: url)
        authRequest.httpMethod = "POST"

        let postData = """
        {
            "email": "\(email)",
            "password": "\(password)"
        }
        """.data(using: .utf8)
        
        authRequest.httpBody = postData
        authRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
        let task = URLSession.shared.dataTask(with: authRequest) { data, response, error in
            
            if let _ = error {
                completed(.failure(.errorSearching))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.errorSearching))
                return
            }
            
            guard let data = data else {
                completed(.failure(.errorSearching))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let authToken = try decoder.decode(Auth.self, from: data)
                completed(.success(authToken))
            } catch {
                completed(.failure(.errorSearching))
            }
            
        }
        task.resume()
    }
    
    func createUser(name: String, email: String, password: String, completed: @escaping (Result<Auth, ClassiError>) -> Void) {
        
        let endpoint = baseURL + "users"

        guard let url = URL(string: endpoint) else {
            return
        }

        var authRequest = URLRequest(url: url)
        authRequest.httpMethod = "POST"
        
        let postData = """
        {
            "name": "\(name)",
            "email": "\(email)",
            "password": "\(password)"
        }
        """.data(using: .utf8)
        
        authRequest.httpBody = postData
        authRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
        let task = URLSession.shared.dataTask(with: authRequest) { data, response, error in
            
            if let _ = error {
                completed(.failure(.errorSearching))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.errorSearching))
                return
            }
            
            guard let data = data else {
                completed(.failure(.errorSearching))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let authToken = try decoder.decode(Auth.self, from: data)
                completed(.success(authToken))
            } catch {
                completed(.failure(.errorSearching))
            }
            
        }
        task.resume()
    }
    
    func getUser(id: String, completed: @escaping (Result<User, ClassiError>) -> Void) {
        
        let endpoint = baseURL + "users/" + id

        guard let url = URL(string: endpoint) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let _ = error {
                completed(.failure(.errorSearching))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.errorSearching))
                return
            }
            
            guard let data = data else {
                completed(.failure(.errorSearching))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let user = try decoder.decode(User.self, from: data)
                completed(.success(user))
                
            } catch {
                completed(.failure(.errorSearching))
            }
            
        }
        
        task.resume()
    }
    
    func getUsersCars(user: String, completed: @escaping (Result<[Listing], ClassiError>) -> Void) {
        
        let endpoint = baseURL + "listings/?user_id=" + user

        guard let url = URL(string: endpoint) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let _ = error {
                completed(.failure(.errorSearching))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.errorSearching))
                return
            }
            
            guard let data = data else {
                completed(.failure(.errorSearching))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let listing = try decoder.decode([Listing].self, from: data)
                completed(.success(listing))
                
            } catch {
                completed(.failure(.errorSearching))
            }
            
        }
        
        task.resume()
    }
    
    func listCar(token: String, title: String, price: Int, description: String, make: String, model: String, year: Int, mileage: Int, postcode: String, completed: @escaping (Result<Listing, ClassiError>) -> Void) {
        
        let endpoint = baseURL + "listings"

        guard let url = URL(string: endpoint) else {
            return
        }

        var authRequest = URLRequest(url: url)
        authRequest.httpMethod = "POST"
    
        let postData = """
        {"title": "\(title)", "price": \(price), "description": "\(description)", "car": {"make": "\(make)", "model": "\(model)", "year": \(year), "mileage": \(mileage)}, "location": {"postcode": "\(postcode)"}}
        """.data(using: .utf8)
        
        authRequest.httpBody = postData
        authRequest.setValue("\(token)", forHTTPHeaderField: "X-Auth-Token")
        authRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
        let task = URLSession.shared.dataTask(with: authRequest) { data, response, error in
            
            if let _ = error {
                completed(.failure(.errorSearching))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.errorSearching))
                return
            }
            
            guard let data = data else {
                completed(.failure(.errorSearching))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let listingAuth = try decoder.decode(Listing.self, from: data)
                completed(.success(listingAuth))
            } catch {
                completed(.failure(.errorSearching))
            }
            
        }
        task.resume()
    }
    
    func getUsersAvatar(user: String, completed: @escaping (Result<Data, ClassiError>) -> Void) {
        
        let endpoint = baseURL + "images/avatars/" + user

        guard let url = URL(string: endpoint) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let _ = error {
                completed(.failure(.errorSearching))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.errorSearching))
                return
            }
            
            guard let data = data else {
                completed(.failure(.errorSearching))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let userAvatar = try decoder.decode(Data.self, from: data)
                completed(.success(userAvatar))
                
            } catch {
                completed(.failure(.errorSearching))
            }
            
        }
        
        task.resume()
    }
    
    func deleteListing(token: String, id: String, completed: @escaping (Result<String, ClassiError>) -> Void) {
        
        let endpoint = baseURL + "listings/" + id

        guard let url = URL(string: endpoint) else {
            return
        }

        var authRequest = URLRequest(url: url)
        authRequest.httpMethod = "DELETE"
        authRequest.setValue("\(token)", forHTTPHeaderField: "X-Auth-Token")
    
        let task = URLSession.shared.dataTask(with: authRequest) { data, response, error in
            
            if let _ = error {
                completed(.failure(.errorSearching))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.errorSearching))
                return
            }
            
            completed(.success("Success"))
            
        }
        task.resume()
    }
    
    func getTopListing(completed: @escaping (Result<[Listing], ClassiError>) -> Void) {
        
        let endpoint = baseURL + "listings/popular"

        guard let url = URL(string: endpoint) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let _ = error {
                completed(.failure(.errorSearching))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.errorSearching))
                return
            }
            
            guard let data = data else {
                completed(.failure(.errorSearching))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let topListing = try decoder.decode([Listing].self, from: data)
                completed(.success([topListing.first!]))
                
            } catch {
                completed(.failure(.errorSearching))
            }
            
        }
        
        task.resume()
    }
    
    func favoriteListing(token: String, listing: String, completed: @escaping (Result<Favorite, ClassiError>) -> Void) {
        
        let endpoint = baseURL + "users/favorites/" + listing

        guard let url = URL(string: endpoint) else {
            return
        }

        var authRequest = URLRequest(url: url)
        authRequest.httpMethod = "PUT"
        authRequest.setValue("\(token)", forHTTPHeaderField: "X-Auth-Token")
    
        let task = URLSession.shared.dataTask(with: authRequest) { data, response, error in
            
            if let _ = error {
                completed(.failure(.errorSearching))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.errorSearching))
                return
            }
            
            guard let data = data else {
                completed(.failure(.errorSearching))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let listingAuth = try decoder.decode(Favorite.self, from: data)
                completed(.success(listingAuth))
            } catch {
                completed(.failure(.errorSearching))
            }
            
        }
        task.resume()
    }
    
    func unFavoriteListing(token: String, listing: String, completed: @escaping (Result<Favorite, ClassiError>) -> Void) {
        
        let endpoint = baseURL + "users/favorites/" + listing

        guard let url = URL(string: endpoint) else {
            return
        }

        var authRequest = URLRequest(url: url)
        authRequest.httpMethod = "DELETE"
        authRequest.setValue("\(token)", forHTTPHeaderField: "X-Auth-Token")
    
        let task = URLSession.shared.dataTask(with: authRequest) { data, response, error in
            
            if let _ = error {
                completed(.failure(.errorSearching))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.errorSearching))
                return
            }
            
            guard let data = data else {
                completed(.failure(.errorSearching))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let listingAuth = try decoder.decode(Favorite.self, from: data)
                completed(.success(listingAuth))
            } catch {
                completed(.failure(.errorSearching))
            }
        }
        
        task.resume()
    }
    
    func reportListing(listing: String, completed: @escaping (Result<Favorite, ClassiError>) -> Void) {
        
        let endpoint = baseURL + "listings/report/" + listing

        guard let url = URL(string: endpoint) else {
            return
        }

        var authRequest = URLRequest(url: url)
        authRequest.httpMethod = "PUT"
    
        let task = URLSession.shared.dataTask(with: authRequest) { data, response, error in
            
            if let _ = error {
                completed(.failure(.errorSearching))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.errorSearching))
                return
            }
            
            guard let data = data else {
                completed(.failure(.errorSearching))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let serverResponse = try decoder.decode(Favorite.self, from: data)
                completed(.success(serverResponse))
            } catch {
                completed(.failure(.errorSearching))
            }
        }
        task.resume()
    }
    
    func editName(user: String, name: String, token: String, completed: @escaping (Result<User, ClassiError>) -> Void) {
        
        let endpoint = baseURL + "users/" + user

        guard let url = URL(string: endpoint) else {
            return
        }

        var authRequest = URLRequest(url: url)
        authRequest.httpMethod = "PUT"
        authRequest.setValue("\(token)", forHTTPHeaderField: "X-Auth-Token")
        authRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let postData = """
        {
            "name": "\(name)"
        }
        """.data(using: .utf8)
        
        authRequest.httpBody = postData
    
        let task = URLSession.shared.dataTask(with: authRequest) { data, response, error in
            
            if let _ = error {
                completed(.failure(.errorSearching))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.errorSearching))
                return
            }
            
            guard let data = data else {
                completed(.failure(.errorSearching))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let serverResponse = try decoder.decode(User.self, from: data)
                completed(.success(serverResponse))
            } catch {
                completed(.failure(.errorSearching))
            }
        }
        task.resume()
    }
    
}
