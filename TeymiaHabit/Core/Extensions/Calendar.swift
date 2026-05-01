import Foundation

extension Calendar {
    static var userPreferred: Calendar {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        return calendar
    }
}

extension Date {
    func formattedAsNavigationTitle() -> String {
        if Calendar.current.isDateInToday(self) { return "today".capitalized }
        if Calendar.current.isDateInYesterday(self) { return "yesterday".capitalized }
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM"
        return formatter.string(from: self).capitalized
    }
}
