import SwiftUI

struct ColorSelectionView: View {
    @Binding var selectedColor: HabitIconColor

    private let buttonSize = DS.IconSize.lg

    var body: some View {
        HStack(spacing: 0) {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: DS.Spacing.reg) {
                    ForEach(HabitIconColor.allCases, id: \.self) { iconColor in
                        colorButton(for: iconColor)
                    }
                }
                .padding(.horizontal, DS.Spacing.reg)
            }
        }
        .frame(height: buttonSize * 2)
        .glassEffect(.regular.interactive(false), in: .capsule)
        .sensoryFeedback(.selection, trigger: selectedColor)
        .clipShape(.capsule)
    }

    private func colorButton(for color: HabitIconColor) -> some View {
        let isSelected = selectedColor == color

        return Button {
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
                .scaleEffect(isSelected ? 1.1 : 1.0)
        }
        .buttonStyle(.plain)
        .contentShape(.circle)
    }
}

