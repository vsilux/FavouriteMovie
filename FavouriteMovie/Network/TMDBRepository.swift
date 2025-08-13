//
//  TMDBRepository.swift
//  FavouriteMovie
//
//  Created by Illia Suvorov on 13.08.2025.
//

import Foundation

class TMDBRepository {
    static let baseURL = "https://api.themoviedb.org/3"
    static let readToken = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJhNWZhZjlkMjc5YmM4YzY5OGYyYzgxOWE2ZGI5ZTNjMiIsIm5iZiI6MTc1NTAwODM1NC43ODcwMDAyLCJzdWIiOiI2ODliNGQ2MjllODFlNmU2M2IyNjg2YjYiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.qy6tq6lR7wXjXzgK13m1bNdNsTTNo15okh_ipkeJuo4"
    let urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func discoverMovies(
        adult: Bool = false,
        includeVideo: Bool = false,
        language: String = "en-US",
        page: Int = 1,
        sort: DiscoverEndpoint.Sort = .popularity(.descending)
    ) async throws -> DiscoverResponse {
        let request = try DiscoverEndpoint.movie(
            adult: adult,
            includeVideo: includeVideo,
            language: language,
            page: page,
            sort: sort
        ).request(baseUrl: Self.baseURL, apiKey: Self.readToken)
        
        do {
            let response = try await urlSession.data(for: request)
            return try DiscoverResponseMapper
                .map(response)
        } catch {
            print("Error fetching movies: \(error)")
            throw error
        }
    }
    
    func discoverTVShows(
        adult: Bool = false,
        includeVideo: Bool = false,
        language: String = "en-US",
        page: Int = 1,
        sort: DiscoverEndpoint.Sort = .popularity(.descending)
    ) async throws -> DiscoverResponse {
        let request = try DiscoverEndpoint.tv(
            adult: adult,
            language: language,
            page: page,
            sort: sort
        ).request(baseUrl: Self.baseURL, apiKey: Self.readToken)
        
        return try DiscoverResponseMapper
            .map(try await urlSession.data(for: request))
    }
}
