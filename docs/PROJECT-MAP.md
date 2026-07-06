# PROJECT-MAP.md — карта кодовой базы

Обновляется в конце каждой сессии. Источник правды по фичам — `planner-spec-v1.md`.

> **Статус:** форк TeymiaHabit. Текущая функциональность — трекер привычек (habits).
> Планировщик задач (TaskItem / LifeArea / Today / NagEngine) ещё НЕ реализован —
> это предмет сессий 2+. Ниже карта того, что есть сейчас.

## Стек
SwiftUI + SwiftData + WidgetKit-ready, iOS 26 SDK (таргет 18+). Хранение локальное,
CloudKit отключён (`cloudKitDatabase: .none`). Язык UI — английский (хардкод
`LocalizedStringKey`), русификация — позже. Xcode project с
`PBXFileSystemSynchronizedRootGroup` — файлы подхватываются из ФС автоматически,
править `project.pbxproj` при добавлении/удалении .swift не нужно.

## Точки входа
- `TeymiaHabit/App/TeymiaHabitApp.swift` — `@main`. Инъекция сервисов в environment:
  `HabitService`, `NotificationManager`, `SoundManager`, `TimerService`,
  `HealthKitManager`. Онбординг через `.sheet` (сейчас форсится через
  `hasCompletedOnboarding = false` — есть `// TODO: remove for production`).
- `TeymiaHabit/App/AppTabView.swift` — корневой TabView. 3 таба: **Habits**
  (`HabitsView`), **Statistics** (`StatisticsView`), **Settings** (`SettingsView`).
- `TeymiaHabit/App/DatabaseContainer.swift` — singleton `ModelContainer`.
  Schema = `[Habit, HabitCompletion]`. В DEBUG база в Documents, в RELEASE — в
  app group `group.com.amanbayserkeev.teymiahabit`. Есть авто-recovery при сбое схемы.

## Модели данных — `TeymiaHabit/Core/Models/`
- `Habit.swift` — основная @Model. Заголовок, цель, активные дни (bitmask),
  `reminderTimes: [Date]?`, старт-дата, архивность, порядок, иконка/цвет.
- `HabitCompletion.swift` — отметки выполнения (связь с Habit).
- `HabitType.swift`, `HabitSource.swift`, `HabitTemplate.swift`,
  `HabitIconColor.swift`, `ChartDataPoint.swift`.
- `AppIcon.swift` — альтернативные иконки приложения (есть флаг `isFree` — оставлен,
  но больше нигде не гейтит, см. «Что удалено»).
- `CompletionSound.swift`, `NotificationSound.swift` — звуки; протокол
  `HabitSoundProtocol` с `isFree` (флаг оставлен, гейтинг снят).
- `HealthKitMetric.swift`.

## Сервисы и менеджеры
- `Core/Services/HabitService.swift` — CRUD привычек, дергает NotificationManager/TimerService.
- `Core/Services/TimerService.swift` — таймеры (для habit-типа «время»).
- `Core/Managers/NotificationManager.swift` — **вся текущая notification-логика**.
  `UNCalendarNotificationTrigger`, `repeats: true`, id вида
  `"<habitUUID>-<weekday>-<index>"`. Планирование по активным дням недели из bitmask,
  до нескольких `reminderTimes` на привычку. Есть авторизация, отмена, полный
  ре-скан (`updateAllNotifications`). ⚠️ Notification actions, 3 класса нага,
  лимит 64, эскалация — НЕ реализованы (сессия 3).
- `Core/Managers/SoundManager.swift`, `AppIconManager.swift`, `HeathKitManager.swift` (sic).

## Экраны — `TeymiaHabit/Features/`
- `Habits/` — список привычек (`HabitsView`, `HabitsViewModel`, `HabitCard`,
  `WeeklyCalendarView`). Кнопка «+» открывает `TemplatesView`.
- `Create/` — создание/редактирование привычки (`NewHabitView` + компоненты-строки:
  `RemindersRow`, `GoalRow`, `ActiveDaysRow`, `StartDateRow`, `IconPickerView`, …).
- `Detail/` — карточка привычки (`HabitDetailView` + `HabitDetailViewModel`).
- `Statistics/` — сводная (`StatisticsView`) + детальная по привычке
  (`HabitStatisticsView`: календарь, бар-чарт, стрики). ⚠️ `StreaksView` существует —
  по спеке стрики запрещены (А1), но это отдельная задача, не трогаем в сессии 1.
- `Settings/` — настройки (`SettingsView` + секции: тема, иконка приложения `AppIconView`,
  язык, архив, звуки `SoundsView`, уведомления, about).
- `Onboarding/OnboardingView.swift`.

## Общее / дизайн-система — `TeymiaHabit/Shared/`
`DesignSystem/` (`AppFont`, `ComponentTokens` — Spacing/IconSize/Radius/TouchTarget,
`DesignSystem`, `RowIconStyle`), фоны (`Backgrounds/`), эффекты (шиммер, blur, morph),
`AnimatedTabView`, `EmptyStateView` и пр.

## Ресурсы — `TeymiaHabit/Resources/`
`Assets.xcassets`, `Colors.xcassets` (в т.ч. неиспользуемые теперь `PremiumBlue`/
`PremiumPink` colorset — оставлены как безвредные), `AppIcons/`, `Sounds/`, `Videos/`.

## Что удалено в сессии 1 (RevenueCat / подписки / пейволл)
**RevenueCat в проекте не было** — монетизация была на нативном StoreKit 2.
Удалено полностью:
- `Core/Services/StoreKitService.swift` — сервис подписок + `isPremium`.
- `Features/Premium/` целиком: `PremiumFeatures.swift` (лимиты `maxHabitsCount`/
  `maxRemindersCount`/`canUseSounds`/`canUseIcon`), `PremiumLocks.swift`
  (бейджи-замки), `PremiumColors.swift`, `Paywall/` (View/ViewModel/Feature).
- `Features/Settings/Sections/PremiumRow.swift` — строка «Premium» в настройках.
- `Teymia Habit.storekit` — конфиг StoreKit + ссылка на него в `.xcscheme`.

Все ранее платные фичи теперь безусловны: неограниченно привычек и напоминаний,
все звуки и иконки, полная статистика без блюра. См. список изменённых файлов ниже.
Флаги `isFree` в моделях оставлены (не мешают), геймплейно ни на что не влияют.

## Известные хвосты (не относятся к сессии 1, на будущее)
- `TeymiaHabitApp`: `hasCompletedOnboarding = false` в `.onAppear` — временный форс онбординга.
- `Statistics/HabitStatisticsView/Components/StreaksView.swift` — стрики (конфликт с А1).
- Английский хардкод строк.
