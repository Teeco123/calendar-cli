import EventKit
import Foundation

class EventManager {
  let eventStore = EKEventStore()

  func requestAccess() throws -> Bool {
    let semaphore = DispatchSemaphore(value: 0)
    var accessGranted = false

    eventStore.requestAccess(to: .event) { granted, error in
      accessGranted = granted
      semaphore.signal()
    }

    _ = semaphore.wait(timeout: .distantFuture)

    if !accessGranted {
      print("⚠️ Calendar access denied. Please enable in System Settings.")
      return false
    }
    return true
  }

  func listTodayEvents(today: Bool) throws {
    guard try requestAccess() else { return }

    let startDate = Date()
    var endDate = Date()
    if today {
      endDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate)!
    } else {
      endDate = Calendar.current.date(byAdding: .day, value: 7, to: startDate)!
    }

    let predicate = eventStore.predicateForEvents(
      withStart: startDate, end: endDate, calendars: nil)
    let events = eventStore.events(matching: predicate)

    displayEvents(events)
  }

  func createNewEvent() throws {
    guard try requestAccess() else { return }
    let newEvent = EKEvent(eventStore: eventStore)

    newEvent.title = promptForEventName()
    newEvent.calendar = promptForCalendar()
    newEvent.startDate = Date()
    newEvent.endDate = Date()

    try eventStore.save(newEvent, span: .thisEvent, commit: true)
  }

  private func displayEvents(_ events: [EKEvent]) {
    print("\nEvents")
    print("------------------------------")

    if events.isEmpty {
      print("No events found.")
      return
    }

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "d-MMM-yyyy h:mm a"

    for event in events {
      let startTime = dateFormatter.string(from: event.startDate)
      let endTime = dateFormatter.string(from: event.endDate)

      print("📅 \(event.title!)")
      print("   Calendar: \(event.calendar.title)")
      print("   From: \(startTime)")
      print("   To: \(endTime)")

      if let location = event.location, !location.isEmpty {
        print("   Location: \(location)")
      }
      print("------------------------------")
    }
  }

  func listCalendars() -> [MyCalendar] {
    let calendars = eventStore.calendars(for: .event)
    var arr: [MyCalendar] = []

    var i = 1
    for calendar in calendars {
      let cal = MyCalendar(id: i, calendar: calendar)
      arr.append(cal)
      i += 1
    }
    return arr
  }
}

