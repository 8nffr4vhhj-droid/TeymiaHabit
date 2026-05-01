import SwiftUI

struct SettingsView: View {
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    AppearanceRow()
                    SoundRow()
                    ArchiveRow()
                    NotificationsRow()
                    
#if !targetEnvironment(macCatalyst)
                    AppIconRow()
                    LanguageRow()
#endif
                }
                .rowBackground()
                
                AboutSection()
                    .rowBackground()
            }
            .secondaryBackground()
            .navigationTitle("settings")
        }
    }
    
    private struct LanguageRow: View {
        var body: some View {
            Button(action: openAppSettings) {
                HStack {
                    Label(
                        title: { Text("settings_language") },
                        icon: { RowIcon(iconName: "globe.americas.fill") }
                    )
                    Spacer()
                    Text(currentLanguage).foregroundStyle(.secondary)
                }
            }
            .foregroundStyle(.primary)
        }
        
        private func openAppSettings() {
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(url)
        }
        
        private var currentLanguage: String {
            let languageCode = Bundle.main.preferredLocalizations.first ?? "en"
            return Locale.current.localizedString(forLanguageCode: languageCode)?.capitalized ?? languageCode
        }
    }
}
