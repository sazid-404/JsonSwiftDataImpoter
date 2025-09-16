//
//  JsonSwiftDataImpoterApp.swift
//  JsonSwiftDataImpoter
//
//  Created by Sazzadul Islam on 9/15/25.
//

import SwiftData
import SwiftUI

@main
struct JsonSwiftDataImpoterApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        // Injects a ModelContainer and a modelContext into the environment
        .modelContainer(for: [PhotoObject.self])
    }
}
