
import Foundation

final class SplashViewModel {
    var onAnimationCompleted: (() -> Void)?
    
    func performInitialAnimation(completion: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            completion()
        }
    }
}
