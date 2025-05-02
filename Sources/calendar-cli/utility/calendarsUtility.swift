import EventKit
import Foundation

func fetchCalendars(_ eventStore: EKEventStore) -> [MyCalendar] {
    let calendars = eventStore.calendars(for: .event)
    var arr: [MyCalendar] = []

    for (index, calendar) in calendars.enumerated() {
        let cal = MyCalendar(id: index + 1, calendar: calendar)
        arr.append(cal)
    }
    return arr
}
func promptForCalendar(_ eventStore: EKEventStore) -> EKCalendar {
    print("Creating new event (Step 2 of ?)")
    print("Choose your calendar number: ")
    let calendars = fetchCalendars(eventStore)
    for calendar in calendars {
        print(calendar.id, calendar.calendar.title)
    }

    guard let input = readLine(), !input.isEmpty else {
        print("You need to choose your calendar. Please try again.")
        return promptForCalendar(eventStore)
    }

    if let foundIndex = calendars.first(where: { $0.id == Int(input) }) {
        return foundIndex.calendar
    } else {
        print("Select valid calendar. Please try again.")
        return promptForCalendar(eventStore)
    }

}

extension EKCalendarType {
    var displayName: String {
        switch self {
        case .local: return "Local"
        case .calDAV: return "CalDAV"
        case .exchange: return "Exchange"
        case .subscription: return "Subscription"
        case .birthday: return "Birthday"
        @unknown default: return "Unknown"
        }
    }
}

extension EKCalendarEventAvailabilityMask {
    var displayNames: String {
        var names: [String] = []
        if contains(.busy) {
            names.append("Busy")
        }
        if contains(.free) {
            names.append("Free")
        }
        if contains(.tentative) {
            names.append("Tentative")
        }
        if contains(.unavailable) {
            names.append("Unavailable")
        }
        if names.isEmpty {
            names.append("None")
        }
        return names.joined(separator: ", ")
    }
}

func detailedCalendarDisplay(_ calendar: MyCalendar) {
    print("📅 \(calendar.calendar.title)")
    print("   ID: \(calendar.id)")
    print("   Title: \(calendar.calendar.title)")
    print("   Type: \(calendar.calendar.type.displayName)")
    print("   Is immutable: \(calendar.calendar.isImmutable)")
    print("   Availabilities: \(calendar.calendar.supportedEventAvailabilities.displayNames)")
    print("------------------------------")
}
