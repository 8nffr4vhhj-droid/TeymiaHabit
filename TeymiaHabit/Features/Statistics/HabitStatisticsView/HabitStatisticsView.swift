import SwiftUI

struct HabitStatisticsView: View {
    let habit: Habit
    @Environment(\.dismiss) private var dismiss
    @State private var vm: HabitStatisticsViewModel

    init(habit: Habit) {
        self.habit = habit
        self._vm = State(wrappedValue: HabitStatisticsViewModel(habit: habit))
    }

    var body: some View {
        @Bindable var vm = vm

        NavigationStack {
            Form {
                Section {
                    HStack {
                        Text("Total all time")
                            .foregroundStyle(Color.primary)

                        Spacer()

                        Text(vm.formattedTotal)
                            .contentTransition(.numericText())
                            .fontWeight(.semibold)
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color(#colorLiteral(red: 0.9961017966, green: 0.4863132238, blue: 0.1490832567, alpha: 1)), Color(#colorLiteral(red: 0.9961031079, green: 0.2039290071, blue: 0.01577392034, alpha: 1))],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                    }
                }

                Section {
                    HStack(spacing: 0) {
                        Spacer(minLength: 0)

                        MonthlyCalendarView(
                            habit: habit,
                            selectedDate: $vm.selectedDate
                        )
                        .frame(maxWidth: 500)

                        Spacer(minLength: 0)
                    }
                }
                .listRowInsets(EdgeInsets())

                Section {
                    VStack(spacing: Spacing.md) {
                        TimeRangePicker(selection: $vm.barChartTimeRange)
                        BarChartView(habit: habit, range: vm.barChartTimeRange)
                            .id("\(habit.uuid.uuidString)-\(vm.barChartTimeRange.rawValue)")
                    }
                    .padding(.top, Spacing.reg)
                } footer: {
                    HStack(spacing: Spacing.xxs) {
                        Image(systemName: "hand.tap")
                        Text("Press and hold bars for details")
                    }
                    .foregroundStyle(Color.secondary)
                    .padding(.leading, Spacing.reg)
                }
                .listRowInsets(EdgeInsets())
            }
            .formStyle(.grouped)
            .navigationTitle(habit.title)
            .navigationSubtitle("Goal: \(habit.formattedGoal)")
            .toolbar { DismissToolbarButton() }
            .onChange(of: habit.completions) { _, _ in
                vm.refresh()
            }
        }
    }
}
