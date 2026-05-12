import SwiftUI

extension Calendar {
    static var userPreferred: Calendar {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        return calendar
    }
}

extension Date {

    func formattedAsNavigationTitle() -> String {
        let calendar = Calendar.current

        if calendar.isDateInToday(self) {
            return String(localized: "Today").capitalized
        }

        if calendar.isDateInYesterday(self) {
            return String(localized: "Yesterday").capitalized
        }

        return self.formatted(.dateTime.day().month(.wide)).capitalized
    }
}

extension Date {
    func nominativeMonthYear() -> String {
        self.formatted(.dateTime.month(.wide).year()).capitalizingFirstLetter()
    }

    func nominativeMonth() -> String {
        self.formatted(.dateTime.month(.wide)).capitalizingFirstLetter()
    }
}

private extension String {
    func capitalizingFirstLetter() -> String {
        guard !isEmpty else { return self }
        return prefix(1).uppercased() + dropFirst()
    }
}
