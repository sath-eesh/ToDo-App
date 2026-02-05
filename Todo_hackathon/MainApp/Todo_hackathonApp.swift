import SwiftUI
import SwiftData

@main
struct Todo_hackathonApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: TodoItem.self)
    }
}
