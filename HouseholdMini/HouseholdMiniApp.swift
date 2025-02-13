//
//  HouseholdMiniApp.swift
//  HouseholdMini
//
//  Created by 長橋和敏 on 2025/02/13.
//

import SwiftUI

@main
struct HouseholdMiniApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
