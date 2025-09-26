import Foundation
import UIKit

final class SessionService {
    var sessionCount: Int = 0
    var totalForegroundTime: TimeInterval = .zero
    var currentSessionStart: Date?
    var lastTimeForeground: Date?
    
    init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appWillResignActive),
            name: UIApplication.willResignActiveNotification,
            object: nil
        )
    }
    
    @objc func appDidBecomeActive() {
        takeDataFromUserDefault()
        if let lastTimeForeground = lastTimeForeground {
            if Date().timeIntervalSince(lastTimeForeground) > 60*60 {
                sessionCount += 1
            }
        } else {
            sessionCount = 0
        }
        currentSessionStart = Date()
    }
    
    @objc func appWillResignActive() {
        guard let currentSessionStart = currentSessionStart else { return }
        let foregroundTime = Date().timeIntervalSince(currentSessionStart)
        totalForegroundTime += foregroundTime
        lastTimeForeground = Date()
        saveDataToUserDefaults()
    }
    
    private func takeDataFromUserDefault() {
        sessionCount = UserDefaults.standard.integer(forKey: Keys.sessionCount.rawValue)
        totalForegroundTime = UserDefaults.standard.double(forKey: Keys.totalForegroundTime.rawValue)
        currentSessionStart = UserDefaults.standard.object(forKey: Keys.currentSessionStart.rawValue) as? Date
        lastTimeForeground = UserDefaults.standard.object(forKey: Keys.lastTimeForeground.rawValue) as? Date
    }
    
    private func saveDataToUserDefaults() {
        UserDefaults.standard.set(sessionCount, forKey: Keys.sessionCount.rawValue)
        UserDefaults.standard.set(totalForegroundTime, forKey: Keys.totalForegroundTime.rawValue)
        UserDefaults.standard.set(currentSessionStart, forKey: Keys.currentSessionStart.rawValue)
        UserDefaults.standard.set(lastTimeForeground, forKey: Keys.lastTimeForeground.rawValue)
    }
}

private extension SessionService {
    enum Keys: String {
        case sessionCount = "session_count"
        case totalForegroundTime = "total_foreground_time"
        case currentSessionStart = "current_session_start"
        case lastTimeForeground  = "last_time_foreground"
    }
}
