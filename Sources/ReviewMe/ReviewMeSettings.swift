import UIKit
import Foundation
import StoreKit

/// Configuration settings for how and when to prompt the user for a review.
public struct ReviewMeSettings {
    /// Number of app interactions required before attempting to show a review prompt.
    /// This counter is reset when the app version changes.
    public let minimumAppInteractions: Int

    /// Minimum number of days required between two review prompts.
    public let minimumDaysBetweenReviews: Int

    /// Whether to allow prompting on hotfix (patch) version changes (e.g., 1.0.0 -> 1.0.1).
    public let allowPromptOnHotFix: Bool

    public init(minimumAppInteractions: Int = 2, minimumDaysBetweenReviews: Int = 10, allowPromptOnHotFix: Bool = false) {
        self.minimumAppInteractions = minimumAppInteractions
        self.minimumDaysBetweenReviews = minimumDaysBetweenReviews
        self.allowPromptOnHotFix = allowPromptOnHotFix
    }
}
