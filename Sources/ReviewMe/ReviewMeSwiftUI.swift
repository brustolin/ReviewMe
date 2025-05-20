#if canImport(SwiftUI)
import SwiftUI
import StoreKit

public struct ReviewIfNeededModifier: ViewModifier {
    let settings: ReviewMeSettings

// Removed unused `scenePhase` variable declaration.
    @State private var hasRunReviewCheck = false
    public func body(content: Content) -> some View {
        content
            .background(ReviewTriggerView(settings: settings, hasRunReviewCheck: $hasRunReviewCheck))
    }
}

private struct ReviewTriggerView: UIViewRepresentable {
    private class ProxyView : UIView {
        @Binding var hasRunReviewCheck: Bool
        let settings: ReviewMeSettings
        
        override var isHidden: Bool {
            get { true }
            set { }
        }
        
        init(settings: ReviewMeSettings, hasRunReviewCheck: Binding<Bool>) {
            _hasRunReviewCheck = hasRunReviewCheck
            self.settings = settings
            super.init(frame: .zero)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func didMoveToWindow() {
            guard !hasRunReviewCheck else { return }
            guard let window = self.window, let scene = window.windowScene else {
                return
            }
            ReviewMe.reviewIfNeeded(settings: settings, in: scene)
            hasRunReviewCheck = true
        }
        
    }
    
    let settings: ReviewMeSettings
    @Binding var hasRunReviewCheck: Bool

    
    @MainActor @preconcurrency func makeUIView(context: Self.Context) -> UIView {
        return ProxyView(settings: settings, hasRunReviewCheck: $hasRunReviewCheck)
    }

    @MainActor @preconcurrency func updateUIView(_ uiView: UIView, context: Self.Context) {
    }
}

public extension View {
    /// Attaches logic to automatically trigger App Store review prompts if conditions are met.
    /// - Parameter settings: Configuration for how and when to request a review.
    func requestReviewIfNeeded(settings: ReviewMeSettings = .init()) -> some View {
        modifier(ReviewIfNeededModifier(settings: settings))
    }
}
#endif
