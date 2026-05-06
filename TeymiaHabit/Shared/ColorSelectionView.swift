import SwiftUI

struct ColorSelectionView: View {
    @Binding var selectedColor: HabitIconColor
    private let buttonSize = DS.IconSize.lg
    private let fadeWidth: Double = 0.05

    var body: some View {
        HStack {
            GeometryReader { geo in
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: DS.Spacing.reg) {
                        ForEach(HabitIconColor.allCases, id: \.self) { iconColor in
                            colorButton(for: iconColor, in: geo)
                        }
                    }
                    .padding(.horizontal, DS.Spacing.reg)
                }
                .mask {
                    LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: .clear, location: 0),
                            .init(color: .black, location: fadeWidth),
                            .init(color: .black, location: 1 - fadeWidth),
                            .init(color: .clear, location: 1)
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                }
            }
        }
        .frame(height: buttonSize * 2)
        .glassEffect(.regular.interactive(false), in: .capsule)
        .sensoryFeedback(.selection, trigger: selectedColor)
        .clipShape(.capsule)
    }

    private func colorButton(for color: HabitIconColor, in geo: GeometryProxy) -> some View {
        let isSelected = selectedColor == color

        return GeometryReader { itemGeo in
            let midX = itemGeo.frame(in: .global).midX
            let leftEdge = geo.frame(in: .global).minX
            let rightEdge = geo.frame(in: .global).maxX
            let centerX = (leftEdge + rightEdge) / 2
            let distanceFromCenter = abs(midX - centerX)
            let maxDistance = (rightEdge - leftEdge) / 2
            let threshold: CGFloat = 0.8
            let normalized = distanceFromCenter / maxDistance
            let edgeFactor = normalized < threshold ? 0 : (normalized - threshold) / (1 - threshold)
            let scale = 1.0 - edgeFactor * 0.4
            let opacity = 1.0 - edgeFactor * 1.0

            Button {
                withAnimation(DS.Animations.spring) {
                    selectedColor = color
                }
            } label: {
                Circle()
                    .fill(color.baseColor)
                    .frame(width: buttonSize, height: buttonSize)
                    .overlay(
                        Circle()
                            .strokeBorder(DS.Colors.onPrimary, lineWidth: 2)
                            .frame(size: buttonSize * 0.9)
                            .opacity(isSelected ? 1 : 0)
                    )
                    .scaleEffect(isSelected ? scale * 1.15 : scale)
                    .opacity(opacity)
            }
            .buttonStyle(.plain)
            .contentShape(.circle)
        }
        .frame(width: buttonSize, height: buttonSize)
    }
}
