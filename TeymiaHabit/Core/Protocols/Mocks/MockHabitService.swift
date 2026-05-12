import Foundation

#if DEBUG
final class MockHabitService: HabitServiceProtocol {
    var habits: [Habit] = []
    var temporaryProgress: [String: Int] = [:]
    var didCallDelete = false
    var didCallArchive = false

    // MARK: - CRUD
    func createHabit(with config: Habit.Configuration) { }
    func updateHabit(_ habit: Habit, with config: Habit.Configuration) { }
    func delete(_ habit: Habit) { didCallDelete = true }
    func archive(_ habit: Habit) { didCallArchive = true }
    func unarchive(_ habit: Habit) { }
    func reorderHabits(_ habits: [Habit]) { }

    // MARK: - Progress
    func effectiveProgress(for habit: Habit, on date: Date) -> Int { 0 }
    func addProgress(_ delta: Int, to habit: Habit, date: Date) -> Bool { true }
    func updateProgress(to newValue: Int, for habit: Habit, date: Date) -> Bool { true }
    func resetProgress(for habit: Habit, date: Date) { }
    func saveProgress(_ value: Int, for habit: Habit, date: Date) { }
    func completeHabit(for habit: Habit, date: Date) -> Bool { true }

    // MARK: - Temporary Progress
    func setTemporaryProgress(for habitId: UUID, date: Date, progress: Int) {
        temporaryProgress["\(habitId)"] = progress
    }
    func getTemporaryProgress(for habitId: UUID, date: Date) -> Int? {
        temporaryProgress["\(habitId)"]
    }
    func clearTemporaryProgress(for habitId: UUID, date: Date) {
        temporaryProgress.removeValue(forKey: "\(habitId)")
    }

    // MARK: - Skip
    func skipDate(_ date: Date, for habit: Habit) { }
    func unskipDate(_ date: Date, for habit: Habit) { }
}
#endif
