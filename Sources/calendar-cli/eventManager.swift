import EventKit
import Foundation

class EventManager {
    let eventStore = EKEventStore()

    func listEvents(_ today: Bool, _ days: Int, _ calendar: Int?) throws {
        guard try requestAccess(eventStore) else { return }

        let startDate = Date()
        var endDate = Date()
        if today {
            endDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate)!
        } else {
            endDate = Calendar.current.date(byAdding: .day, value: days, to: startDate)!
        }

        var predicate: NSPredicate
        if calendar != nil {
            let calendars = fetchCalendars(eventStore)

            if let foundIndex = calendars.first(where: { $0.id == Int(calendar!) }) {
                let calendars: [EKCalendar] = [foundIndex.calendar]

                predicate = eventStore.predicateForEvents(
                    withStart: startDate, end: endDate, calendars: calendars)
            } else {
                print("Select valid calendar. Please try again.")
                return
            }
        } else {
            predicate = eventStore.predicateForEvents(
                withStart: startDate, end: endDate, calendars: nil)
        }

        let events = eventStore.events(matching: predicate)
        displayEvents(events)
    }

    func createNewEvent() throws {
        guard try requestAccess(eventStore) else { return }
        let newEvent = EKEvent(eventStore: eventStore)

        newEvent.title = promptForEventName()
        newEvent.calendar = promptForCalendar(eventStore)
        newEvent.startDate = Date()
        newEvent.endDate = Date()

        try eventStore.save(newEvent, span: .thisEvent, commit: true)
    }

}
