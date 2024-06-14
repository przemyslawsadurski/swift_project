//
//  swift_projectApp.swift
//  swift_project
//
//  Created by przet on 08/06/2024.
//

import SwiftUI

@main
struct swift_projectApp: App {
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
