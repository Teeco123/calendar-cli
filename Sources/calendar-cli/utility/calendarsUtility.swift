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
