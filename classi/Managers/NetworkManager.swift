//
//  NetworkManager.swift
//  classi
//
//  Created by Andrew Lawler on 22/03/2020.
//  Copyright © 2020 andrewlawler. All rights reserved.
//

import Foundation

enum ClassiError: String, Error {
    case errorSearching    = "There has been an error while searching. Please try again."
}

class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    
    let baseURL = "https://classi-server.herokuapp.com/api/"
    
    func getAllListings(completed: @escaping (Result<[Listing], ClassiError>) -> Void) {
        
        let endpoint = baseURL + "listings"

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
                
                let listingArray = try decoder.decode([Listing].self, from: data)
                completed(.success(listingArray))
                
            } catch {
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
    
    func listCar(token: String, title: String, price: Int, location: String, description: String?, phone: String?, email: String?, make: String?, model: String?, year: Int?, mileage: Int?, completed: @escaping (Result<Listing, ClassiError>) -> Void) {
        
        let endpoint = baseURL + "listings"

        guard let url = URL(string: endpoint) else {
            return
        }

        var authRequest = URLRequest(url: url)
        authRequest.httpMethod = "POST"
        authRequest.setValue("\(token)", forHTTPHeaderField: "X-Auth-Token")
        
        let postData = """
        {
            "title": "\(title)",
            "price": \(price),
            "location": {
                "postcode": "\(location)"
            },
            "description": "\(description!)",
            "phone": "\(phone!)",
            "email": "\(email!)",
            "car": {
                "make": "\(make!)",
                "model": "\(model!)",
                "year": \(year!),
                "mileage": \(mileage!)
            }
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
    
    // somehow do form data
    func postUserAvatar(token: String, user: String, completed: @escaping (Result<Listing, ClassiError>) -> Void) {
        
        let endpoint = baseURL + "images/avatars/:" + user

        guard let url = URL(string: endpoint) else {
            return
        }
        var authRequest = URLRequest(url: url)
        authRequest.httpMethod = "POST"
        authRequest.setValue("\(token)", forHTTPHeaderField: "X-Auth-Token")
        
        let postData = """
        {
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
                
                let listingAuth = try decoder.decode(Listing.self, from: data)
                completed(.success(listingAuth))
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
        
        let endpoint = baseURL + "listings/popular/:1"

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
                completed(.success(topListing))
                
            } catch {
                completed(.failure(.errorSearching))
            }
            
        }
        
        task.resume()
    }
    
}
