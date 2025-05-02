import EventKit
import Foundation

class CalendarsManager {
    let eventStore = EKEventStore()

    func listCalendars() throws {
        guard try requestAccess(eventStore) else { return }
        let calendars = fetchCalendars(eventStore)

        for calendar in calendars {
            print(calendar.id, calendar.calendar.title)
        }
    }
}
