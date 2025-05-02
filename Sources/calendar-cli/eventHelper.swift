import EventKit
import Foundation

extension EventManager {
    func requestAccess(_ eventStore: EKEventStore) throws -> Bool {
        let semaphore = DispatchSemaphore(value: 0)
        var accessGranted = false

        eventStore.requestFullAccessToEvents { granted, _ in
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

    func promptForEventName() -> String? {
        print("Creating new event (Step 1 of ?)")
        print("Enter event name: ")
        guard let input = readLine(), !input.isEmpty else {
            print("Name cannot be empty. Please try again.")
            return promptForEventName()
        }
        return input
    }

    func promptForCalendar() -> EKCalendar {
        print("Creating new event (Step 2 of ?)")
        print("Choose your calendar number: ")
        let calendars = fetchCalendars()
        for calendar in calendars {
            print(calendar.id, calendar.calendar.title)
        }

        guard let input = readLine(), !input.isEmpty else {
            print("You need to choose your calendar. Please try again.")
            return promptForCalendar()
        }

        if let foundIndex = calendars.first(where: { $0.id == Int(input) }) {
            return foundIndex.calendar
        } else {
            print("Select valid calendar. Please try again.")
            return promptForCalendar()
        }
    }

    func displayEvents(_ events: [EKEvent]) {
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

    func fetchCalendars() -> [MyCalendar] {
        let calendars = eventStore.calendars(for: .event)
        var arr: [MyCalendar] = []

        for (index, calendar) in calendars.enumerated() {
            let cal = MyCalendar(id: index + 1, calendar: calendar)
            arr.append(cal)
        }
        return arr
    }
}
