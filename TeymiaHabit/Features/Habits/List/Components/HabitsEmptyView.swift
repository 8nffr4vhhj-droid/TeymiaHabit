import SwiftUI

struct HabitsEmptyView: View {
    let action: () -> Void

    private static let iconSize = DS.IconSize.reg

    var body: some View {
        VStack(spacing: DS.Spacing.lg) {
            iconsRow
            titleAndMessage
            actionButton
        }
        .padding(.horizontal, DS.Spacing.xxl)
    }

    private var iconsRow: some View {
        HStack(spacing: DS.Spacing.md) {
            Icon(name: "book.person.fill")
            Icon(name: "massage.fill")
            Icon(name: "person.swimmer.fill")
        }
    }

    private var titleAndMessage: some View {
        VStack(spacing: DS.Spacing.xs) {
            Text("No habits yet")
                .font(DS.AppFont.title3)
                .fontWeight(.bold)
                .foregroundStyle(DS.Colors.primary)

            Text(message)
                .font(DS.AppFont.subheadline)
                .foregroundStyle(DS.Colors.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(3)
        }
    }

    private var actionButton: some View {
        VStack(spacing: DS.Spacing.xs) {
            Button {
                action()
            } label: {
                Text("Build new Habit")
                    .font(DS.AppFont.headline)
                    .foregroundStyle(DS.Colors.onPrimary)
                    .padding(.horizontal, DS.Spacing.xl)
                    .padding(.vertical, DS.Spacing.sm)
                    .frame(maxWidth: .infinity, maxHeight: DS.TouchTarget.minimum)
            }
            .buttonStyle(.glassProminent)

            Text("Join millions building better habits")
                .font(DS.AppFont.footnote)
                .foregroundStyle(DS.Colors.secondary.opacity(0.8))
        }
    }

    private var message: String {
           "Start small: add a habit like 'Read a book 15 minutes' or 'Morning walk'. " +
           "Watch how consistency creates real change over time."
       }

    @ViewBuilder
    private func Icon(name: String) -> some View {
        Image(name)
            .resizable()
            .frame(size: Self.iconSize)
            .frame(size: Self.iconSize * 1.8)
            .foregroundStyle(DS.Colors.secondary)
            .background {
                Circle()
                    .fill(DS.Colors.tertiary)
            }
    }
}
