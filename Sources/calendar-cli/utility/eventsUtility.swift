import EventKit
import Foundation

func promptForEventName() -> String? {
    print("Creating new event (Step 1 of ?)")
    print("Enter event name: ")
    guard let input = readLine(), !input.isEmpty else {
        print("Name cannot be empty. Please try again.")
        return promptForEventName()
    }
    return input
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
