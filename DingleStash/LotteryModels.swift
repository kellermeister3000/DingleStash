// Import SwiftUI for ObservableObject
import SwiftUI

// Environment object to manage shared lottery state
class LotteryStateManager: ObservableObject {
    @Published var selectedLotteryType = LotteryType.megaMillions
}

// Enum for lottery types with their specific requirements
enum LotteryType: String, CaseIterable {
    case megaMillions = "Mega Millions"
    case powerball = "Powerball"
    
    var mainNumbersRange: ClosedRange<Int> {
        switch self {
        case .megaMillions: return 1...70
        case .powerball: return 1...69
        }
    }
    
    var specialBallRange: ClosedRange<Int> {
        switch self {
        case .megaMillions: return 1...25 // Mega Ball
        case .powerball: return 1...26 // Power Ball
        }
    }
}

// Enum for ticket status
enum TicketStatus: String, CaseIterable {
    case all = "All"
    case pending = "Pending"
    case checked = "Checked"
    case winner = "Winner"
    case expired = "Expired"
}

// LotteryTicket model
struct LotteryTicket: Identifiable {
    let id = UUID()
    let mainNumbers: [Int]
    let specialBall: Int
    let drawDate: Date
    let type: LotteryType
    var status: TicketStatus = .pending
}
