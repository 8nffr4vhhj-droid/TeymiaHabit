import SwiftUI
import SwiftData

struct HabitDetailView: View {
    @Environment(HabitService.self) private var habitService
    @Environment(TimerService.self) private var timerService
    @Environment(WidgetService.self) private var widgetService
    @Environment(NotificationManager.self) private var notificationManager
    @Environment(SoundManager.self) private var soundManager
    @Environment(HabitLiveActivityManager.self) private var habitLiveActivityManager
    
    let habit: Habit
    let date: Date
    let showStatsButton: Bool
    
    init(
        habit: Habit,
        date: Date,
        showStatsButton: Bool = true
    ) {
        self.habit = habit
        self.date = date
        self.showStatsButton = showStatsButton
    }
    
    var body: some View {
        HabitDetailContentView(
            habit: habit,
            date: date,
            viewModel: HabitDetailViewModel(
                habit: habit,
                initialDate: date,
                habitService: habitService,
                timerService: timerService,
                widgetService: widgetService,
                notificationManager: notificationManager,
                soundManager: soundManager,
                habitLiveActivityManager: habitLiveActivityManager
            ),
            showStatsButton: showStatsButton
        )
    }
}

struct HabitDetailContentView: View {
    let habit: Habit
    let date: Date
    let showStatsButton: Bool
    
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: HabitDetailViewModel
    @State private var showingStats = false
    @State private var isEditPresented = false
    
    init(
        habit: Habit,
        date: Date,
        viewModel: HabitDetailViewModel,
        showStatsButton: Bool = true
    ) {
        self.habit = habit
        self.date = date
        self.showStatsButton = showStatsButton
        _viewModel = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        @Bindable var vm = viewModel
        NavigationStack {
            mainContent(vm: viewModel)
            .toolbar {
                toolbarContent(vm: viewModel)
            }
            .deleteSingleHabitAlert(
                isPresented: $vm.alertState.isDeleteAlertPresented,
                habitName: habit.title,
                onDelete: {
                    viewModel.deleteHabit()
                    dismiss()
                }
            )
            .id(habit.uuid.uuidString)
            .onDisappear {
                viewModel.prepareForDeletion()
            }
            .onChange(of: date) { _, newDate in
                viewModel.updateDisplayedDate(newDate)
            }
            .sheet(isPresented: $isEditPresented) {
                NewHabitView(habit: habit)
            }
            .sheet(isPresented: $showingStats) {
                HabitStatisticsView(habit: habit)
            }
        }
        .presentationDetents([.fraction(0.7)])
        .presentationDragIndicator(.visible)
    }
    
    // MARK: - Content
    @ViewBuilder
    private func mainContent(vm: HabitDetailViewModel) -> some View {
        VStack(spacing: DS.Spacing.xxl) {
            headerView
                .padding(.horizontal, DS.Spacing.xl)
            
            HabitProgressView(vm: vm, habit: habit)
            
                actionButtonsSection(vm: vm)
            
                completeButtonView(vm: vm)
                    .disabled(vm.isAlreadyCompleted)
                    .padding(.horizontal, DS.Spacing.xl)
        }
        .padding(.horizontal, DS.Spacing.xl)
    }
    
    @ViewBuilder
    private var headerView: some View {
        VStack(spacing: DS.Spacing.xs) {
            Text(habit.title)
                .font(DS.Typography.largeTitle)
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.8)
                .lineLimit(2)
            Text("Goal: \(habit.formattedGoal)")
                .font(DS.Typography.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, DS.Spacing.xl)
    }
    
    @ToolbarContentBuilder
    private func toolbarContent(vm: HabitDetailViewModel) -> some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            if !Calendar.current.isDateInToday(date) {
                Text(date.formattedAsNavigationTitle())
                    .foregroundStyle(.tertiary)
                    .fixedSize(horizontal: true, vertical: false)
            }
        }
        .sharedBackgroundVisibility(.hidden)
        
        if showStatsButton {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showingStats = true
                } label: {
                    Image(systemName: "chart.bar.fill")
                }
                .tint(.primary)
            }
        }
        
        ToolbarItem(placement: .topBarTrailing) {
            menuButton(vm: vm)
        }
    }
    
    // MARK: - Buttons
    @ViewBuilder
    private func menuButton(vm: HabitDetailViewModel) -> some View {
        Menu {
            Button { isEditPresented = true } label: {
                Label("button_edit", systemImage: "pencil")
            }
            Button {
                vm.archiveHabit()
                dismiss()
            } label: {
                Label("archive", systemImage: "archivebox")
            }
            Divider()
            Button(role: .destructive) {
                vm.alertState.isDeleteAlertPresented = true
            } label: {
                Label("button_delete", systemImage: "trash")
            }
        } label: {
            Image(systemName: "ellipsis")
        }
        .tint(.primary)
    }
    
    private func actionButtonsSection(vm: HabitDetailViewModel) -> some View {
        ActionButtonsSection(
            habit: habit,
            date: date,
            isToday: Calendar.current.isDateInToday(date),
            isTimerRunning: vm.isTimerRunning,
            onReset: { vm.resetProgress() },
            onTimerToggle: { vm.toggleTimer() },
            onAddProgress: { value in vm.addProgress(value) }
        )
    }
    
    private func completeButtonView(vm: HabitDetailViewModel) -> some View {
        Button(action: {
            vm.completeHabit()
        }) {
            Text(viewModel.isAlreadyCompleted ? "completed" : "complete")
                .font(DS.Typography.headline)
                .foregroundStyle(DS.Colors.onPrimary)
                .frame(maxWidth: .infinity, minHeight: DS.TouchTarget.large)
                .contentShape(.capsule)
        }
        .buttonStyle(.plain)
        .glassEffect(.clear.interactive().tint(habit.actualColor), in: .capsule)
        .padding(.horizontal, DS.Spacing.xl)
    }
}
