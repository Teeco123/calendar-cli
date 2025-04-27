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

func listEvents(today: Bool) {
    let calendars = eventStore.calendars(for: .event)

    let startDate = Date()
    var endDate = Date()

    if today == true {
        endDate = Calendar.current.date(
            bySettingHour: 23, minute: 23, second: 23, of: startDate)!
    } else {
        endDate = Calendar.current.date(byAdding: .year, value: 1, to: startDate)!
    }

    let predicate = eventStore.predicateForEvents(
        withStart: startDate, end: endDate, calendars: calendars)
    let events = eventStore.events(matching: predicate)

    if events.isEmpty {
        print("No events found.")
    } else {
        for event in events {
            print(
                "📅 \(event.title ?? "No Title") at \(event.startDate.formatted(date: .abbreviated, time: .shortened))"
            )
        }
    }
}

func handleCommand(arguments: [String]) {
    guard arguments.count > 1 else {
        print("Usage: calendarcli <command>")
        print("Commands: list")
        return
    }

    let command = arguments[1]
    let options = Array(arguments.dropFirst(2))
    requestCalendarAccess { granted in
        if granted {
            switch command {
            case "list":
                let today = options.contains("--today")
                listEvents(today: today)
            default:
                print("Unknown command: \(command)")
            }
            CFRunLoopStop(CFRunLoopGetMain())
        } else {
            print("Access to calendar was not granted.")
            CFRunLoopStop(CFRunLoopGetMain())
        }
    }
}

// Start here
handleCommand(arguments: CommandLine.arguments)
CFRunLoopRun()
