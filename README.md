# ReviewMe

**ReviewMe** is a lightweight Swift library that intelligently prompts users to review your iOS app using the native `SKStoreReviewController`. It helps ensure that review requests are shown at the right time — not too early, not too often, and only when appropriate based on app version, usage count, and time interval.

## ✨ Features

- Automatically tracks how many times the app was launched or used
- Limits review requests to a configurable number of uses
- Ensures a minimum number of days between requests
- Supports version-aware prompts, with optional hotfix (patch) review support
- Tiny footprint — all Swift, no dependencies

## 📦 Installation

### Swift Package Manager

Add this line to your `Package.swift`:

```swift
.package(url: "https://github.com/brustolin/ReviewMe.git", from: "1.0.0")
```

Or use Xcode:
1. File → Add Packages…
2. Enter the URL of your repository
3. Add ReviewMe to your target

## 🚀 Usage

### 1. Import and Configure

```swift
import ReviewMe
```

### 2. Call reviewIfNeeded at an appropriate time


**SwiftUI Integration** 

If you’re using SwiftUI, simply attach the .requestReviewIfNeeded() view modifier to a top-level view (like your main screen). The modifier will automatically determine the correct UIWindowScene and decide whether to prompt for a review.
A good place is when the app becomes active or after a significant user action:

```swift
import SwiftUI
import ReviewMe

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .requestReviewIfNeeded()
        }
    }
}
```

**UIKit Integration**

In UIKit apps, call the static method manually from anywhere you have access to a UIWindowScene — 
usually during app launch in your scene delegate, or when a major action is completed:

```swift
import UIKit
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    func sceneDidBecomeActive(_ scene: UIScene) {
        guard let windowScene = scene as? UIWindowScene else { return }
        ReviewMe.reviewIfNeeded(in: windowScene)
    }
}
```

### 3. (Optional) Customize the settings

```swift
let settings = ReviewMeSettings(
    minimumAppInteractions: 3,          // Default: 2
    minimumDaysBetweenReviews: 14,      // Default: 10
    allowPromptOnHotFix: true           // Default: false
)

ReviewMe.reviewIfNeeded(settings: settings, in: windowScene)
```

## ⚙️ Settings Explained

|Property|Description|
|-|-|
|minimumAppInteractions|How many times reviewIfNeeded must be called before a review is shown|
|minimumDaysBetweenReviews|Minimum number of days between two review prompts|
|allowPromptOnHotFix|Allows prompts on hotfix version changes (e.g., 1.0.0 → 1.0.1)|

> 💡 It’s best to call `reviewIfNeeded` only once per app launch or significant screen (e.g., home screen).

## ✅ Requirements

- iOS 14.0+
- tvOS 14.0+

⸻

Enjoy smart review prompts, and may your app get lots of 5-star ratings ⭐️⭐️⭐️⭐️⭐️!
