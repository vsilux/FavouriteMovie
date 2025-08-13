//
//  ContentView.swift
//  FavouriteMovie
//
//  Created by Illia Suvorov on 12.08.2025.
//

import SwiftUI

struct ContentView: View {
    let repository = TMDBRepository()
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            Button("Press me") {
                Task {
                    do {
                        let movies = try await repository.discoverMovies()
                        print("Fetched \(movies.results.count) movies.")
                    } catch {
                        print("Error fetching movies: \(error.localizedDescription)")
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
