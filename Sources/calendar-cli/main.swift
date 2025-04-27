import ArgumentParser
import EventKit
import Foundation

@main
struct CLI: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "A CLI with multiple subcommands.",
        subcommands: [List.self]
    )
}

struct List: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Lists user events."
    )

    @Flag(name: .shortAndLong, help: "Lists only today events.")
    var option: Bool = false

    func run() throws {
        print("Today only")
    }
}
