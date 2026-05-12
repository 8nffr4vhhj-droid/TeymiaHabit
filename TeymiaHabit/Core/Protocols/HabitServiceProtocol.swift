import Foundation

@MainActor
protocol HabitServiceProtocol: AnyObject {

    // MARK: - CRUD
    func createHabit(with config: Habit.Configuration)
    func updateHabit(_ habit: Habit, with config: Habit.Configuration)
    func delete(_ habit: Habit)
    func archive(_ habit: Habit)
    func unarchive(_ habit: Habit)
    func reorderHabits(_ habits: [Habit])

    // MARK: - Progress
    func effectiveProgress(for habit: Habit, on date: Date) -> Int
    @discardableResult
    func addProgress(_ delta: Int, to habit: Habit, date: Date) -> Bool
    @discardableResult
    func updateProgress(to newValue: Int, for habit: Habit, date: Date) -> Bool
    func resetProgress(for habit: Habit, date: Date)
    func saveProgress(_ value: Int, for habit: Habit, date: Date)
    @discardableResult
    func completeHabit(for habit: Habit, date: Date) -> Bool

    // MARK: - Temporary Progress (UI cache)
    func setTemporaryProgress(for habitId: UUID, date: Date, progress: Int)
    func getTemporaryProgress(for habitId: UUID, date: Date) -> Int?
    func clearTemporaryProgress(for habitId: UUID, date: Date)

    // MARK: - Skip
    func skipDate(_ date: Date, for habit: Habit)
    func unskipDate(_ date: Date, for habit: Habit)
}
