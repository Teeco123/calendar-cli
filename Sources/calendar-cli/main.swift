import ArgumentParser
import EventKit
import Foundation

@main
struct calendarCli: ParsableCommand {
    @Flag(help: "Display only today events.")
    var today = false

    @Argument(help: "Command.")
    var command: String
}
