import SwiftUI

struct HabitIconView: View {
    let iconName: String?
    let color: Color
    var size: CGFloat = DS.IconSize.sm
    var showBackground: Bool = true

    private static let backgroundScale: CGFloat  = 2.0
    private static let backgroundOpacity: Double = 0.15
    private let fallbackIcon = "book"

    var body: some View {
        ZStack {
            if showBackground {
                Circle()
                    .fill(color.opacity(Self.backgroundOpacity))
            }
            resolvedImage
        }
        .frame(size: size * Self.backgroundScale)
    }

    private var resolvedImage: some View {
        let name = iconName ?? fallbackIcon
        let isAsset = UIImage(named: name) != nil

        return (isAsset ? Image(name) : Image(systemName: name))
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: size, height: size)
            .foregroundStyle(color.gradient)
    }
}
