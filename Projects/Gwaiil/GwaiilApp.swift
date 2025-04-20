//
//  GwaiilApp.swift
//  Gwaiil
//
//  Created by 석민솔 on 4/16/25.
//

import SwiftUI
import SwiftData

@main
struct GwaiilApp: App {
    var body: some Scene {
        WindowGroup {
            Home()
        }
        .modelContainer(for: FruitData.self)
    }
}
