//
//  InAppPurchaseTutorialApp.swift
//  InAppPurchaseTutorial
//
//  Created by Toni Nichev on 1/2/24.
//

import SwiftUI

@main
struct InAppPurchaseTutorialApp: App {
    @Environment(\.scenePhase) private var sceneParse
    @StateObject private var store = Store()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
                .task(id: sceneParse) {
                    if sceneParse == .active {
                        await store.fetchActiveTransactions()
                    }
                }
        }
    }
}
