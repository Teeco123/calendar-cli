import ArgumentParser
import EventKit
import Foundation

@main
struct CalendarCli: ParsableCommand {
  static let configuration = CommandConfiguration(
    abstract: "A CLI with multiple subcommands.",
    subcommands: [List.self, Create.self]
  )
}


