//
//  ContentView.swift
//  JsonSwiftDataImpoter
//
//  Created by Sazzadul Islam on 9/15/25.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \PhotoObject.id) private var photos: [PhotoObject]
    @StateObject private var vm = PhotosViewModel()   // ← uses the separated VM

    var body: some View {
        List(photos) { item in
            HStack(spacing: 12) {
                Text(item.id, format: .number)
                    .font(.subheadline).monospaced()
                Text(item.title)
                    .font(.subheadline).monospaced()
                Spacer(minLength: 8)

                if let url = URL(string: item.url) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(width: 60, height: 60)
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 60, height: 60)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        case .failure:
                            Image(systemName: "xmark.circle")
                                .foregroundStyle(.red)
                                .frame(width: 60, height: 60)
                        @unknown default:
                            EmptyView().frame(width: 60, height: 60)
                        }
                    }
                } else {
                    Image(systemName: "exclamationmark.triangle")
                        .foregroundStyle(.orange)
                        .frame(width: 60, height: 60)
                }
            }
            .padding(.vertical, 4)
        }
        .overlay {
            if vm.isLoading && photos.isEmpty { ProgressView() }
        }
        .task {
            if photos.isEmpty { await vm.sync(modelContext: modelContext) }
        }
        .refreshable {
            await vm.sync(modelContext: modelContext)
        }
        .navigationTitle("Photos")
    }
}



#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: PhotoObject.self, configurations: config)
        let sample = PhotoObject(
            albumId: 1,
            id: 1,
            title: "Sample",
            url: "https://via.placeholder.com/600/92c952",
            thumbnailUrl: "https://via.placeholder.com/150/92c952"
        )
        container.mainContext.insert(sample)
        return NavigationStack { ContentView() }.modelContainer(container)
    } catch {
        fatalError("Failed to create model container")
    }
}


