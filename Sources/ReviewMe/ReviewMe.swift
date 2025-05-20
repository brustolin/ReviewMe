import UIKit
import Foundation
import StoreKit

@MainActor
/// Utility that handles logic to request an App Store review when conditions are met.
public struct ReviewMe {
    
    /// Main function to be called when the app launches or reaches an appropriate state.
    /// This will decide whether to ask the user for a review.
    public static func reviewIfNeeded(settings: ReviewMeSettings = .init(), in scene: UIWindowScene) {
        let userDefaults = UserDefaults.standard

        let now = Date()
        let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0.0"

        let lastReviewDate = userDefaults.object(forKey: ReviewStorageKey.lastReviewDate) as? Date
        let lastReviewVersion = userDefaults.string(forKey: ReviewStorageKey.lastReviewAppVersion)
        var checkCount = userDefaults.integer(forKey: ReviewStorageKey.reviewCheckCount)

        // Check if version changed
        let isNewVersion = shouldPromptForVersionChange(oldVersion: lastReviewVersion, newVersion: currentVersion, allowHotFix: settings.allowPromptOnHotFix)

        if isNewVersion {
            checkCount = 0
            userDefaults.set(currentVersion, forKey: ReviewStorageKey.lastReviewAppVersion)
        }

        // Increment the count
        checkCount += 1
        userDefaults.set(checkCount, forKey: ReviewStorageKey.reviewCheckCount)

        // Determine if we should request a review
        let enoughInteractions = checkCount >= settings.minimumAppInteractions
        let enoughTimePassed = lastReviewDate.map { now.timeIntervalSince($0) / 86400 >= Double(settings.minimumDaysBetweenReviews) } ?? true

        if isNewVersion && enoughInteractions && enoughTimePassed {
            SKStoreReviewController.requestReview(in: scene)
            
            userDefaults.set(now, forKey: ReviewStorageKey.lastReviewDate)
            userDefaults.set(0, forKey: ReviewStorageKey.reviewCheckCount)
        }
    }

    /// Determines whether a new version should allow a review request, optionally considering hotfix versions.
    private static func shouldPromptForVersionChange(oldVersion: String?, newVersion: String, allowHotFix: Bool) -> Bool {
        guard let oldVersion = oldVersion else { return true }

        let oldComponents = oldVersion.split(separator: ".").compactMap { Int($0) }
        let newComponents = newVersion.split(separator: ".").compactMap { Int($0) }

        guard oldComponents.count >= 2 && newComponents.count >= 2 else {
            return false
        }

        // Major or minor version has changed
        if oldComponents[0] != newComponents[0] || oldComponents[1] != newComponents[1] {
            return true
        }

        // Check patch version if hotfix prompting is allowed
        if allowHotFix && oldComponents.count >= 3 && newComponents.count >= 3 {
            return oldComponents[2] != newComponents[2]
        }

        return false
    }
}
