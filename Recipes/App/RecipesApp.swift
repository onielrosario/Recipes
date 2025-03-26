import SwiftUI

@main
struct RecipesApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModelFactory: {
                ContentViewModel()
            })
        }
    }
}
