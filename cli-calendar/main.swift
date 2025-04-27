import EventKit
import Foundation

let eventStore = EKEventStore()

func requestCalendarAccess(completion: @escaping (Bool) -> Void) {
    if #available(macOS 14.0, *) {
        eventStore.requestFullAccessToEvents { granted, error in
            if let error = error {
                print("Error requesting access: \(error.localizedDescription)")
                completion(false)
            } else {
                completion(granted)
            }
        }
    } else {
        eventStore.requestAccess(to: .event) { granted, error in
            if let error = error {
                print("Error requesting access: \(error.localizedDescription)")
                completion(false)
            } else {
                completion(granted)
            }
        }
    }
}

func listEvents() {
    let calendars = eventStore.calendars(for: .event)

    let now = Date()
    let oneYearFromNow = Calendar.current.date(byAdding: .year, value: 1, to: now)!

    let predicate = eventStore.predicateForEvents(
        withStart: now, end: oneYearFromNow, calendars: calendars)
    let events = eventStore.events(matching: predicate)

    if events.isEmpty {
        print("No events found.")
    } else {
        for event in events {
            print("📅 \(event.title ?? "No Title") at \(event.startDate)")
        }
    }
}

requestCalendarAccess { granted in
    if granted {
        listEvents()
        // Keep the program alive long enough for async operations
        CFRunLoopStop(CFRunLoopGetMain())
    } else {
        print("Access to calendar was not granted.")
        CFRunLoopStop(CFRunLoopGetMain())
    }
}

CFRunLoopRun()

