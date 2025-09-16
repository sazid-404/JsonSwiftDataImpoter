////
////  NetworkService.swift
////  JsonSwiftDataImpoter
////
////  Created by Sazzadul Islam on 9/15/25.
////

import Foundation

enum NetworkError: LocalizedError {
    case badUrl, badResponse, badStatus(Int), failedToDecodeResponse, transport(Error)

    var errorDescription: String? {
        switch self {
        case .badUrl:                         return "Invalid URL."
        case .badResponse:                    return "No HTTP response."
        case .badStatus(let code):            return "Unexpected status: \(code)"
        case .failedToDecodeResponse:         return "Failed to decode response."
        case .transport(let err):             return "Network error: \(err.localizedDescription)"
        }
    }
}

struct NetworkService {
    var session: URLSession = .shared

    /// Fetches an array of `PhotoDTO` from the given endpoint.
    func fetchPhotos(from urlString: String = "https://jsonplaceholder.typicode.com/albums/1/photos") async throws -> [PhotoDTO] {
        guard let url = URL(string: urlString) else { throw NetworkError.badUrl }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        do {
            let (data, response) = try await session.data(for: request)
            guard let http = response as? HTTPURLResponse else { throw NetworkError.badResponse }
            guard (200...299).contains(http.statusCode) else { throw NetworkError.badStatus(http.statusCode) }
            do {
                return try JSONDecoder().decode([PhotoDTO].self, from: data)
            } catch {
                throw NetworkError.failedToDecodeResponse
            }
        } catch {
            throw NetworkError.transport(error)
        }
    }
}



