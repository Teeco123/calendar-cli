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

func promptDay() -> String? {

    print("Enter starting day of event: ")
    guard let input = readLine(), !input.isEmpty else {
        print("Day cannot be empty. Please try again.")
        return promptDay()
    }

    guard regexMatch(input, "^(0?[1-9]|[12][0-9]|3[01])$") else {
        print("Input does not match pattern")
        return promptDay()
    }
    return input
}

func promptMonth() -> String? {

    print("Enter starting month of event: ")
    guard let input = readLine(), !input.isEmpty else {
        print("Month cannot be empty. Please try again.")
        return promptMonth()
    }

    guard regexMatch(input, "^(0?[1-9]|1[0-2])$") else {
        print("Input does not match pattern")
        return promptMonth()
    }
    return input
}

func promptYear() -> String? {

    print("Enter starting year of event: ")
    guard let input = readLine(), !input.isEmpty else {
        print("Year cannot be empty. Please try again.")
        return promptYear()
    }

    guard regexMatch(input, "^2\\d{3}$") else {
        print("Input does not match pattern")
        return promptYear()
    }
    return input
}

func promptForDate() -> Date {
    print("Creating new event (Step 3 of ?)")

    let day = promptDay()
    let month = promptMonth()
    let year = promptYear()

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "d-MMM-yyyy h:mm a"

    let dateString = day! + "-" + month! + "-" + year!

    guard let date = dateFormatter.date(from: dateString) else {
        print("Date is nil")
        return Date()
    }

    print(date)
    return Date()
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
