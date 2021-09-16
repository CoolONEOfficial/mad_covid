//
//  mad_covidApp.swift
//  mad_covid
//
//  Created by Nickolay Truhin on 16.09.2021.
//

import SwiftUI

@main
struct mad_covidApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
