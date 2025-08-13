//
//  URLQueryItem+RawRepresentable.swift
//  FavouriteMovie
//
//  Created by Illia Suvorov on 13.08.2025.
//

import Foundation

extension URLQueryItem {
    init(key: any RawRepresentable<String>, value: String) {
        self.init(name: key.rawValue, value: value)
    }
    
    init(key: any RawRepresentable<String>, value: Bool) {
        self.init(name: key.rawValue, value: value ? "true" : "false")
    }
}
