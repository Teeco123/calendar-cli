import ArgumentParser
import Foundation

struct List: ParsableCommand {
  static let configuration = CommandConfiguration(
    abstract: "Lists user events."
  )

  @Flag(name: .shortAndLong, help: "Lists only today events.")
  var today: Bool = false

  func run() throws {
    let eventManager = EventManager()
    try eventManager.listEvents(today: today)
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
