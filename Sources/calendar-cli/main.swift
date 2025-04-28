import ArgumentParser
import EventKit
import Foundation

struct MyCalendar {
    var id: Int
    var calendar: EKCalendar
}

@main
struct CalendarCli: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "A CLI with multiple subcommands.",
        subcommands: [List.self, Create.self]
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

struct Create: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Creates new event."
    )

    func run() throws {
        let eventManager = EventManager()
        try eventManager.createNewEvent()
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

    func createNewEvent() throws {
        guard try requestAccess() else { return }
        let newEvent = EKEvent(eventStore: eventStore)
        let calendar: EKCalendar

        name()

        func name() {
            print("Creating new event (Step 1 of ?)")
            print("Enter event name: ")
            guard let input = readLine(), !input.isEmpty else {
                print("Name cannot be empty. Please try again.")
                name()
                return
            }
            newEvent.title = input
            chooseCalendar()
        }

        func chooseCalendar() {
            print("Creating new event (Step 2 of ?)")
            print("Choose your calendar number: ")
            let calendars = listCalendars()
            for calendar in calendars {
                print(calendar.id, calendar.calendar.title)
            }
            guard let input = readLine(), !input.isEmpty else {
                print("You need to choose your calendar. Please try again.")
                chooseCalendar()
                return
            }
            if let foundIndex = calendars.first(where: { $0.id == Int(input) }) {
                print("Found calendar: \(foundIndex)")
            }
        }

        guard let defaultCalendar = eventStore.defaultCalendarForNewEvents else {
            print("⚠️ No default calendar available")
            return
        }
        calendar = defaultCalendar

        newEvent.startDate = Date()
        newEvent.endDate = Date()
        newEvent.calendar = calendar

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

    private func listCalendars() -> [MyCalendar] {
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
