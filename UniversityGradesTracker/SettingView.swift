import SwiftUI

struct SettingsView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false

    var body: some View {
        Form {
            Section(header: Text("Aspetto")) {
                Toggle(isOn: $isDarkMode) {
                    Text("Modalità Scura")
                }
            }
        }
        .navigationTitle("Impostazioni")
    }
}
