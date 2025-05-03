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

    print("Enter day: ")
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

    print("Enter month: ")
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

    print("Enter year: ")
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

func promptHour() -> String? {
    print("Enter hour: ")
    guard let input = readLine(), !input.isEmpty else {
        print("Hour cannot be empty. Please try again.")
        return promptHour()
    }

    guard regexMatch(input, "^(0?[1-9]|1[0-2])$") else {
        print("Input does not match pattern")
        return promptHour()
    }
    return input
}

func promptMinutes() -> String? {
    print("Enter minutes: ")
    guard let input = readLine(), !input.isEmpty else {
        print("Mintes cannot be empty. Please try again.")
        return promptMinutes()
    }

    guard regexMatch(input, "^[0-5][0-9]$") else {
        print("Input does not match pattern")
        return promptMinutes()
    }
    return input
}

func promptAmPm() -> String? {
    print("Is event PM or AM: ")
    guard let input = readLine(), !input.isEmpty else {
        print("This cannot be empty. Please try again.")
        return promptAmPm()
    }

    guard regexMatch(input, "^(AM|PM|am|pm)$") else {
        print("Input does not match pattern")
        return promptAmPm()
    }
    return input
}

func promptForDate(isStarting: Bool) -> Date {
    print("Creating new event (Step 3 of ?)")
    if isStarting {
        print("Input starting date")
    } else {
        print("Input ending date")
    }

    let day = promptDay()
    let month = promptMonth()
    let year = promptYear()

    let hour = promptHour()
    let minutes = promptMinutes()
    let ampm = promptAmPm()

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "d-MM-yyyy hh:mm a"

    let dateString = day! + "-" + month! + "-" + year! + " " + hour! + ":" + minutes! + " " + ampm!

    guard let date = dateFormatter.date(from: dateString) else {
        print("Date is nil")
        return Date()
    }

    return date
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
