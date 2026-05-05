import SwiftUI

enum AppTintColor: String, CaseIterable, Identifiable {
    case primary
    case blue
    case brown
    case cyan
    case gray
    case green
    case indigo
    case mint
    case orange
    case pink
    case purple
    case red
    case teal
    case yellow

    var id: String { rawValue }

    var color: Color {
        switch self {
        case .primary: .appPrimary
        case .blue:    .appBlue
        case .brown:   .appBrown
        case .cyan:    .cyan
        case .gray:    .appGray
        case .green:   .appGreen
        case .indigo:  .appColorPicker
        case .mint:    .appMint
        case .orange:  .appOrange
        case .pink:    .appPink
        case .purple:  .appPurple
        case .red:     .appRed
        case .teal:    .teal
        case .yellow:  .appYellow
        }
    }

    var localizedName: LocalizedStringResource {
        LocalizedStringResource(stringLiteral: "tint_\(rawValue)")
    }
}
