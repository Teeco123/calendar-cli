import EventKit
import Foundation

class EventManager {
  let eventStore = EKEventStore()

  func listEvents(_ today: Bool, _ days: Int) throws {
    guard try requestAccess(eventStore) else { return }

    let startDate = Date()
    var endDate = Date()
    if today {
      endDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate)!
    } else {
      endDate = Calendar.current.date(byAdding: .day, value: days, to: startDate)!
    }

    let predicate = eventStore.predicateForEvents(
      withStart: startDate, end: endDate, calendars: nil)
    let events = eventStore.events(matching: predicate)

    displayEvents(events)
  }

  func createNewEvent() throws {
    guard try requestAccess(eventStore) else { return }
    let newEvent = EKEvent(eventStore: eventStore)

    newEvent.title = promptForEventName()
    newEvent.calendar = promptForCalendar()
    newEvent.startDate = Date()
    newEvent.endDate = Date()

    try eventStore.save(newEvent, span: .thisEvent, commit: true)
  }

}
