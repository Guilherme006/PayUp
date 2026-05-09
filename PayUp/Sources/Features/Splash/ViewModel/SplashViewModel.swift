//
//  SplashViewModel.swift
//  PayUp
//
//  Created by Arthur Rios on 23/04/25.
//

import Foundation

final class SplashViewModel {
    var onAnimationCompleted: (() -> Void)?
    
    func performInitialAnimation(completion: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            completion()
        }
    }
}
