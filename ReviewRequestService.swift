import Foundation
import StoreKit
import UIKit

final class ReviewRequestService {
    
    func requestReview() {
        let lastReviewTime = UserDefaults.standard.object(forKey: Keys.lastReviewTime.rawValue) as? Date
        if let lastReviewTime = lastReviewTime, Date().timeIntervalSince(lastReviewTime) < Constants.minLastReviewTime { return }
        
        let sessionCount = Services.sessionTracking.sessionCount
        let totalTime = Services.sessionTracking.totalForegroundTime
        
        guard sessionCount >= Constants.minSessionsRequired, totalTime >= Constants.minForegroundTime else { return }
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        SKStoreReviewController.requestReview(in: windowScene)
        
        UserDefaults.standard.set(Date(), forKey: Keys.lastReviewTime.rawValue)
    }
}

private extension ReviewRequestService {
    enum Constants {
        static let minSessionsRequired = 2
        static let minForegroundTime: TimeInterval = 10 * 60
        static let minLastReviewTime: TimeInterval = 3 * 24 * 60 * 60
    }
    
    private enum Keys: String {
        case lastReviewTime = "last_review_request"
    }
}
