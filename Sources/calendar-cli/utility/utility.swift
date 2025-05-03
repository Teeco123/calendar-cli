import EventKit
import Foundation

func requestAccess(_ eventStore: EKEventStore) throws -> Bool {
    let semaphore = DispatchSemaphore(value: 0)
    var accessGranted = false

    eventStore.requestFullAccessToEvents { granted, _ in
        accessGranted = granted
        semaphore.signal()
    }

    _ = semaphore.wait(timeout: .distantFuture)

    if !accessGranted {
        print("⚠️ Calendar access denied. Please enable in System Settings.")
        return false
    }
    return true
}

func createRegex(_ pattern: String) throws -> NSRegularExpression {
    return try NSRegularExpression(
        pattern: pattern,
        options: [.caseInsensitive]
    )
}

func regexMatch(_ input: String, _ pattern: String) -> Bool {
    do {
        let regex = try createRegex(pattern)

        let range = NSRange(location: 0, length: input.count)
        let matches = regex.matches(in: input, options: [], range: range)
        return matches.first != nil
    } catch {
        print("Failed to create regex: \(error.localizedDescription)")
        return true
    }
}
