//
//  DiscoverEndpoint.swift
//  FavouriteMovie
//
//  Created by Illia Suvorov on 12.08.2025.
//

import Foundation

enum DiscoverEndpoint: Endpoint {
    enum QueryKey: String {
        case adult = "include_adult"
        case language = "language"
        case page = "page"
        case sortBy = "sort_by"
        case includeVideo = "include_video"
    }
    
    enum Sort {
        enum Direction: String {
            case ascending = "asc"
            case descending = "desc"
        }
        case popularity(Direction)
        case firstAirDate(Direction)
        case name(Direction)
        case originalName(Direction)
        case voteAverage(Direction)
        case voteCount(Direction)
        
        var stringify: String {
            switch self {
            case let .popularity(direction):
                return "popularity.\(direction.rawValue)"
            case let .firstAirDate(direction):
                return "first_air_date.\(direction.rawValue)"
            case let .name(direction):
                return "name.\(direction.rawValue)"
            case let .originalName(direction):
                return "original_name.\(direction.rawValue)"
            case let .voteAverage(direction):
                return "vote_average.\(direction.rawValue)"
            case let .voteCount(direction):
                return "vote_count.\(direction.rawValue)"
            }
        }
    }
    
    
    case movie(
        adult: Bool,
        includeVideo: Bool,
        language: String,
        page: Int,
        sort: Sort
    )
    case tv(
        adult: Bool,
        language: String,
        page: Int,
        sort: Sort,
    )
    
    static var subpath: String = "/discover"
    
    func url(baseUrl: String) -> URL {
        URL(string: {
            let path = "\(baseUrl)\(Self.subpath)"
            switch self {
            case .movie:
                return "\(path)/movie"
            case .tv:
                return "\(path)/tv"
            }
        }())!
    }
    
    func urlComponents(components: inout URLComponents) {
        switch self {
        case let .movie(adult, includeVideo, language, page, sort):
            components.queryItems = [
                URLQueryItem(
                    key: QueryKey.adult,
                    value: adult
                ),
                URLQueryItem(
                    key: QueryKey.includeVideo,
                    value: includeVideo
                ),
                URLQueryItem(
                    key: QueryKey.language,
                    value: language
                ),
                URLQueryItem(
                    key: QueryKey.page,
                    value: "\(page)"
                ),
                URLQueryItem(
                    key: QueryKey.sortBy,
                    value: sort.stringify
                ),
            ]
        case let .tv(adult, language, page, sort):
            components.queryItems = [
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
                ),
                URLQueryItem(
                    key: QueryKey.sortBy,
                    value: sort.stringify
                ),
            ]
        }
    }
    
    func urlRequest(urlRequest: inout URLRequest) {
        urlRequest.httpMethod = "GET"
    }
}

// MARK: - Response Mapping

enum DiscoverResponseMapper {
    static func map(_ response: (data: Data, response: URLResponse)) throws -> DiscoverResponse {
        let data = response.data
        guard let response = response.response as? HTTPURLResponse else {
            throw RequestError(
                message: "Invalid response",
                code: "INVALID_RESPONSE"
            )
        }
        
        let decoder = JSONDecoder()

        guard response.statusCode == 200 else {
            throw try decoder.decode(RequestError.self, from: data)
        }
        
        do {
            let object = try decoder.decode(DiscoverResponse.self, from: data)
            return object
        }
        catch {
            throw error
        }
    }
}

// MARK: - Model

struct DiscoverResponse: Codable {
    let page: Int
    let results: [Film]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct Film: Codable {
    let adult: Bool
    let backdropPath: String
    let genreIDS: [Int]
    let id: Int
    let originalLanguage: OriginalLanguage
    let originalTitle, overview: String
    let popularity: Double
    let posterPath, releaseDate, title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

enum OriginalLanguage: String, Codable {
    case en = "en"
    case ja = "ja"
    case zh = "zh"
}
