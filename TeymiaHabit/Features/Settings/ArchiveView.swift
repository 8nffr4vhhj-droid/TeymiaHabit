import SwiftUI
import SwiftData

struct ArchiveRow: View {
    var body: some View {
        NavigationLink(destination: ArchiveView()) {
            Label(
                title: { Text("settings_archived_habits") },
                icon: { RowIcon(iconName: "archivebox.fill", color: .gray) }
            )
        }
    }
}

struct ArchiveView: View {
    @Environment(AppDependencyContainer.self) private var appContainer

    @Query(
        filter: #Predicate<Habit> { $0.isArchived },
        sort: [SortDescriptor(\Habit.createdAt, order: .reverse)]
    )
    private var archivedHabits: [Habit]

    @State private var habitToDelete: Habit?
    @State private var isDeleteSingleAlertPresented = false

    var body: some View {
        Form {
            listContent
        }
        .formStyle(.grouped)
        .navigationTitle("settings_archived_habits")
        .deleteSingleHabitAlert(
            isPresented: $isDeleteSingleAlertPresented,
            habitName: habitToDelete?.title ?? "",
            onDelete: {
                if let habit = habitToDelete {
                    appContainer.habitService.delete(habit)
                }
                habitToDelete = nil
            }
        )
    }

    // MARK: - Content

    @ViewBuilder
    private var listContent: some View {
        if archivedHabits.isEmpty {
            Section {
                VStack(spacing: 16) {
                    Spacer()
                    Image(systemName: "archivebox.fill")
                        .font(.system(size: 70))
                        .foregroundStyle(Color.secondary.opacity(0.3))
                    Text("No archived habits")
                        .foregroundStyle(.secondary)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            }
            .listRowBackground(Color.clear)
        } else {
            Section {
                ForEach(archivedHabits) { habit in
                    archivedHabitRow(habit)
                }
            }
        }
    }

    @ViewBuilder
    private func archivedHabitRow(_ habit: Habit) -> some View {
        HStack(spacing: 12) {
            HabitIconView(iconName: habit.iconName, color: habit.actualColor)

            VStack(alignment: .leading, spacing: 2) {
                Text(habit.title)
                    .lineLimit(1)
                    .foregroundStyle(Color.primary)
                Text("goal \(habit.formattedGoal)")
                    .font(.caption)
                    .foregroundStyle(Color.secondary)
            }

            Spacer()

            // Unarchive
            Button {
                appContainer.habitService.unarchive(habit)
            } label: {
                Image(systemName: "arrow.uturn.backward.circle.fill")
                    .resizable()
                    .frame(width: 28, height: 28)
                    .foregroundStyle(.blue.gradient)
                    .padding(4)
            }
            .buttonStyle(.plain)

            // Delete
            Button {
                habitToDelete = habit
                isDeleteSingleAlertPresented = true
            } label: {
                Image(systemName: "trash.circle.fill")
                    .resizable()
                    .frame(width: 28, height: 28)
                    .foregroundStyle(.red.gradient)
                    .padding(4)
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 4)
    }
}
