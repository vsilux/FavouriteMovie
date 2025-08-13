//
//  SearchEndpoint.swift
//  FavouriteMovie
//
//  Created by Illia Suvorov on 13.08.2025.
//

import Foundation

enum SearchEndpoint: Endpoint {
    enum QueryKey: String {
        case query = "query"
        case adult = "include_adult"
        case language = "language"
        case prinaryReleaseYear = "primary_release_year"
        case page = "page"
        case region = "region"
        case year = "year"
    }
    
    case movie(qury: String, adult: Bool, language: String, page: Int)
    
    static var subpath: String = "/search"
    
    func url(baseUrl: String) -> URL {
        URL(string: {
            let path = "\(baseUrl)\(Self.subpath)"
            switch self {
            case .movie:
                return "\(path)/movie"
            }
        }())!
    }
    
    func urlComponents(components: inout URLComponents) {
        switch self {
        case let .movie(qury, adult, language, page):
            components.queryItems = [
                URLQueryItem(
                    key: QueryKey.query,
                    value: qury
                ),
                URLQueryItem(
                    key: QueryKey.adult,
                    value: adult
                ),
                URLQueryItem(
                    key: QueryKey.language,
                    value: language
                ),
                URLQueryItem(
                    key: QueryKey.page,
                    value: "\(page)"
                )
            ]
        }
    }
    
    func urlRequest(urlRequest: inout URLRequest) {
        urlRequest.httpMethod = "GET"
    }
}

// MARK: - Response Mapping
