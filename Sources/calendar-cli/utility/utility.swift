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
