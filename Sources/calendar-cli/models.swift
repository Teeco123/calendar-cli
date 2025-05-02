import ArgumentParser
import EventKit
import Foundation

struct MyCalendar {
    var id: Int
    var calendar: EKCalendar
}

enum CalendarsTypeSearch: String, CaseIterable, ExpressibleByArgument {
    case local
    case calDav
    case exchange
    case subscription
    case birthday

    var ekType: EKCalendarType {
        switch self {
        case .local: return .local
        case .calDav: return .calDAV
        case .exchange: return .exchange
        case .subscription: return .subscription
        case .birthday: return .birthday
        }
    }
}
