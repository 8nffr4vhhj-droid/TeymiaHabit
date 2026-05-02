import Foundation
import SwiftData

// MARK: - AppDependencyContainer
//
// Single composition root for all shared, app-wide dependencies.
// Injected once at the root via .environment(appContainer) and read
// wherever needed with @Environment(AppDependencyContainer.self).
//
// Rules for what belongs here:
//   ✅ Shared infrastructure used across multiple features
//   ✅ Services with complex initialization order (e.g. HabitService needs modelContext)
//   ❌ Feature-specific services (HabitWidgetService, future TodoWidgetService)
//   ❌ UI state — that belongs in individual ViewModels

@Observable @MainActor
final class AppDependencyContainer {

    // MARK: - Shared Managers

    let navManager               = NavigationManager()
    let notificationManager      = NotificationManager()
    let timerService             = TimerService()
    let habitLiveActivityManager = HabitLiveActivityManager()
    let soundManager             = SoundManager()
    let iconManager              = AppIconManager()
    let widgetService            = WidgetService()

    // MARK: - Services

    // HabitService is shared because both Habits and future Widgets
    // need to mutate the same ModelContext through the same debounced save.
    let habitService: HabitService

    // MARK: - Init

    init(modelContext: ModelContext) {
        self.habitService = HabitService(
            modelContext: modelContext,
            widgetService: widgetService,
            notificationManager: notificationManager
        )
    }
}
