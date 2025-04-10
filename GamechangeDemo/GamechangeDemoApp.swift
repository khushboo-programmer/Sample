//
//  GamechangeDemoApp.swift
//  GamechangeDemo
//
//  Created by Khushboo Motwani on 11/04/25.
//

import SwiftUI

@main
struct GamechangeDemoApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
