import SwiftUI

@main
struct UniversityGradesTrackerApp: App {
    @StateObject private var viewModel = GradesViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
