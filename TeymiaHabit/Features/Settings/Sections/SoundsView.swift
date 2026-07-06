import SwiftUI
import SwiftData

struct SoundsRow: View {

    var body: some View {
        NavigationLink {
            SoundsView()
        } label: {
            SettingsRow(item: .sounds)
        }
    }
}

struct SoundsView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(SoundManager.self) private var soundManager
    @Environment(NotificationManager.self) private var notificationManager
    @State private var selectedTab: SoundTab = .completion

    enum SoundTab: String, CaseIterable {
        case completion, notification

        var localizedName: LocalizedStringKey {
            switch self {
            case .completion:   "Completion"
            case .notification: "Notifications"
            }
        }
    }

    var body: some View {
        List {
            Section {
                HStack {
                    Spacer()

                    Picker("", selection: $selectedTab.animation(.smooth)) {
                        ForEach(SoundTab.allCases, id: \.self) { tab in
                            Text(tab.localizedName).tag(tab)
                        }
                    }
                    .pickerStyle(.segmented)
                    .frame(maxWidth: 500)

                    Spacer()
                }
            }
            .listRowBackground(Color.clear)

            if selectedTab == .completion {
                completionSection
            } else {
                notificationSection
            }
        }
        .formStyle(.grouped)
        .navigationTitle("Sounds")
    }

    // MARK: - Sections

    private var completionSection: some View {
        Group {
            Section {
                Toggle("Enable Sounds", isOn: Binding(
                    get: { soundManager.isSoundEnabled },
                    set: { newValue in
                        withAnimation(.snappy) { soundManager.setSoundEnabled(newValue) }
                    }
                ))
            }

            if soundManager.isSoundEnabled {
                Section {
                    ForEach(CompletionSound.allCases) { sound in
                        SoundSelectionRowView(
                            sound: sound,
                            isSelected: soundManager.selectedSound == sound,
                            onPlay: {
                                soundManager.playSound(sound)
                            },
                            onSelect: {
                                soundManager.playSound(sound)
                                soundManager.setSelectedSound(sound)
                            }
                        )
                    }
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }

    private var notificationSection: some View {
        Section {
            ForEach(NotificationSound.allCases) { sound in
                SoundSelectionRowView(
                    sound: sound,
                    isSelected: notificationManager.selectedNotificationSound == sound,
                    onPlay: {
                        soundManager.playNotificationPreview(sound)
                    },
                    onSelect: {
                        soundManager.playNotificationPreview(sound)
                        Task {
                            await notificationManager.setSelectedNotificationSound(
                                sound,
                                modelContext: modelContext
                            )
                        }
                    }
                )
            }
        }
        .transition(.opacity.combined(with: .move(edge: .top)))
    }
}

private struct SoundSelectionRowView<T: HabitSoundProtocol>: View {
    let sound: T
    let isSelected: Bool
    let onPlay: () -> Void
    let onSelect: () -> Void

    @State private var animateTrigger: Int = 0

    var body: some View {
        HStack(spacing: Spacing.sm) {
            Button {
                onPlay()
                animateTrigger += 1
            } label: {
                Image(systemName: "speaker.wave.2.fill")
                    .foregroundStyle(.primary)
                    .symbolEffect(.variableColor.iterative.nonReversing, value: animateTrigger)
                    .frame(size: IconSize.md)
                    .background(.appTertiary, in: .circle)
                    .contentShape(.rect)
            }
            .buttonStyle(.plain)

            HStack {
                Text(sound.displayName)
                    .foregroundStyle(.primary)
                Spacer()
                if isSelected { SelectionCheckmark() }
            }
            .contentShape(.rect)
            .onTapGesture {
                animateTrigger += 1
                onSelect()
            }
        }
    }
}
