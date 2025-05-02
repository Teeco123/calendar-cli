import ArgumentParser
import EventKit
import Foundation

@main
struct CalendarCli: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "A CLI with multiple subcommands.",
        subcommands: [EventsList.self, Create.self]
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

struct Create: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Creates new event."
    )

    func run() throws {
        let eventManager = EventManager()
        try eventManager.createNewEvent()
    }
}
