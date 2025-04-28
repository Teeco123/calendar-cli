import ArgumentParser
import EventKit
import Foundation

@main
struct CLI: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "A CLI with multiple subcommands.",
        subcommands: [List.self]
    )
}

struct List: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Lists user events."
    )

    @Flag(name: .shortAndLong, help: "Lists only today events.")
    var today: Bool = false

    func run() throws {
        let eventManager = EventManager()
        try eventManager.listTodayEvents(today: today)
    }
}

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
}

