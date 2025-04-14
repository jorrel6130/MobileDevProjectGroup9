import SwiftUI

@main
struct PrototypeScreensApp: App {
    @StateObject private var dataController = DataController() // Creates live state of data controller
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
