import SwiftUI

#if !targetEnvironment(macCatalyst)
struct LanguageRow: View {
    var body: some View {
        Button(action: openAppSettings) {
            HStack {
                Label(
                    title: { Text("settings_language") },
                    icon: { RowIcon(iconName: "globe", color: .blue) }
                )
                Spacer()
                Text(currentLanguage)
                    .foregroundStyle(.secondary)
            }
        }
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
#endif
