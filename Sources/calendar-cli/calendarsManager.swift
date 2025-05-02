import EventKit
import Foundation

class CalendarsManager {
    let eventStore = EKEventStore()

    func listCalendars(_ type: CalendarsTypeSearch?) throws {
        guard try requestAccess(eventStore) else { return }
        let calendars = fetchCalendars(eventStore)

        if type != nil {
            let match = calendars.filter { $0.calendar.type == type?.ekType }
            if !match.isEmpty {
                for calendar in match {
                    print(calendar.id, calendar.calendar.title)
                }
            } else {
                print("No calendas of this type found.")
            }
        } else {
            for calendar in calendars {
                print(calendar.id, calendar.calendar.title)
            }
        }
    }
}
