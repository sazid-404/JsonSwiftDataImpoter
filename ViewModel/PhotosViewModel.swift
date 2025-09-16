//
//  PhotosViewModel.swift
//  JsonSwiftDataImpoter
//
//  Created by Sazzadul Islam on 9/15/25.
//

import Foundation
import SwiftData

@MainActor
final class PhotosViewModel: ObservableObject {
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?

    private let service: NetworkService
    init(service: NetworkService = .init()) {
        self.service = service
    }

    // Downloads photos and inserts them into SwiftData.
    func sync(modelContext: ModelContext, url: String = "https://jsonplaceholder.typicode.com/albums/1/photos") async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let items = try await service.fetchPhotos(from: url)
            for dto in items {
                let obj = PhotoObject(item: dto)   // your existing initializer
                modelContext.insert(obj)
            }
        } catch {
            errorMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
        }
    }
}

