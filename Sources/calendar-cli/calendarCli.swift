import ArgumentParser
import EventKit
import Foundation

@main
struct CalendarCli: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "A CLI with multiple subcommands.",
        subcommands: [EventsList.self, EventCreate.self, CalendarsList.self]
    )
}

struct EventsList: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Lists user events."
    )

    @Flag(name: .shortAndLong, help: "Lists only today events.")
    var today: Bool = false

    @Option(name: .shortAndLong, help: ArgumentHelp("Number of days to list.", valueName: "n"))
    var days: Int = 7

    @Option(
        name: .shortAndLong,
        help: ArgumentHelp("Calendar to view events from", valueName: "calendar-id"))
    var calendar: Int?

    func run() throws {
        let eventManager = EventManager()
        try eventManager.listEvents(today, days, calendar)
    }
}

struct EventCreate: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Creates new event."
    )

    func run() throws {
        let eventManager = EventManager()
        try eventManager.createNewEvent()
    }
}

struct CalendarsList: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Lists all calendars."
    )

    @Flag(
        name: .shortAndLong, help: ArgumentHelp("View detailed info about calendars", valueName: "bool")
    )
    var detailed: Bool = false

    @Option(name: .shortAndLong, help: ArgumentHelp("Type of calendar to list.", valueName: "type"))
    var type: CalendarsTypeSearch?

    func run() throws {
        let calendarsManager = CalendarsManager()
        try calendarsManager.listCalendars(type, detailed)
    }
}
