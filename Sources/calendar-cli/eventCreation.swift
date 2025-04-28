import EventKit
import Foundation

extension EventManager {
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
    let calendars = listCalendars()
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
}
