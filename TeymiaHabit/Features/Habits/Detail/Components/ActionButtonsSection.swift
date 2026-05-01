import SwiftUI

struct ActionButtonsSection: View {
    @Environment(HabitService.self) private var habitService
    @State private var isShowingPopover = false
    
    let habit: Habit
    let date: Date
    let isToday: Bool
    let isTimerRunning: Bool
    
    var onReset: () -> Void
    var onTimerToggle: () -> Void
    var onAddProgress: (Int) -> Void
    
    var body: some View {
        HStack(spacing: DS.Spacing.lg) {
            if habit.type == .time && isToday {
                resetButton
                playPauseButton
                manualEntryButton
            } else {
                Spacer()
                resetButton
                manualEntryButton
                Spacer()
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Button Components
    
    @ViewBuilder
    private var resetButton: some View {
        Button(action: onReset) {
            Image(systemName: "arrow.uturn.backward")
                .font(.system(size: DS.IconSize.reg, weight: .medium))
                .foregroundStyle(DS.Colors.appPrimary)
                .frame(width: DS.TouchTarget.comfortable, height: DS.TouchTarget.comfortable)
        }
        .buttonStyle(.plain)
        .contentShape(.circle)
    }
    
    @ViewBuilder
    private var playPauseButton: some View {
        Button {
            onTimerToggle()
        } label: {
            Image(systemName: isTimerRunning ? "pause.fill" : "play.fill")
                .font(.system(size: DS.IconSize.xl))
                .contentTransition(.symbolEffect(.replace, options: .speed(1.3)))
                .foregroundStyle(DS.Colors.appPrimary)
                .frame(width: DS.TouchTarget.comfortable, height: DS.TouchTarget.comfortable)
        }
        .buttonStyle(.plain)
        .contentShape(.circle)
    }
    
    @ViewBuilder
    private var manualEntryButton: some View {
        Button {
            isShowingPopover = true
        } label: {
            Image(systemName: "plus.arrow.trianglehead.clockwise")
                .font(.system(size: DS.IconSize.reg, weight: .medium))
                .foregroundStyle(DS.Colors.appPrimary)
                .frame(width: DS.TouchTarget.comfortable, height: DS.TouchTarget.comfortable)
        }
        .buttonStyle(.plain)
        .contentShape(.circle)
        .popover(isPresented: $isShowingPopover) {
            DayProgressPopover(habit: habit, date: date, onAddProgress: onAddProgress)
                .presentationCompactAdaptation(.popover)
        }
    }
}
