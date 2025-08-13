//
//  Endpoint.swift
//  FavouriteMovie
//
//  Created by Illia Suvorov on 12.08.2025.
//

import Foundation

protocol Endpoint {
    static var subpath: String { get }
    func url(baseUrl: String) -> URL
    func urlComponents(components: inout URLComponents)
    func urlRequest(urlRequest: inout URLRequest)
    func request(baseUrl: String, apiKey: String) -> URLRequest
}

extension Endpoint {
    func request(baseUrl: String, apiKey: String) -> URLRequest {
        let url = url(baseUrl: baseUrl)
        
        var components = URLComponents(
            url: url,
            resolvingAgainstBaseURL: false
        )!
        
        urlComponents(components: &components)
        
        var request = URLRequest(url: components.url!)
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue("Bearer " + apiKey, forHTTPHeaderField: "Authorization")
        
        urlRequest(urlRequest: &request)
        
        return request
    }
}
