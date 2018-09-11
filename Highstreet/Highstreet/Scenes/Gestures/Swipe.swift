
//
//  SwipeProtocol.swift
//  Highstreet
//
//  Created by Dario Langella on 09/09/2018.
//  Copyright © 2018 Dario Langella. All rights reserved.
//

import UIKit

//MARK: Protocol
protocol Swipe { }

//MARK: Protocol extension constrained to UIPanGestureRecognizer
extension Swipe where Self: UIPanGestureRecognizer {
    
    //MARK: Main function
    func swipeView(_ view: UIView, completion: (_ result: Bool) -> Void){
        
        switch state {
        case .began:
            self.resetTransform(view)
            break
        case .changed:
            let translation = self.translation(in: view.superview)
            view.transform = transform(view: view, for: translation)
        case .ended:
            touchEnded(in: view) { (finished) in
                completion(true)
            }
        default:
            break
        }
    }
    
    //MARK: Helper method that handles transformation
    private func transform(view: UIView, for translation: CGPoint) -> CGAffineTransform {
        
        let moveBy = CGAffineTransform(translationX: translation.x, y: translation.y)
        let rotation = -sin(translation.x / (view.frame.width * 4.0))
        return moveBy.rotated(by: rotation)
    }
    
    private func touchEnded(in view : UIView, dismissCompletion: (_ result: Bool) -> Void) {
        self.resetTransform(view)
        dismissCompletion(true)
    }
    
    private func resetTransform(_ view : UIView){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1.0, options: [], animations: {
            view.transform = .identity
        }, completion: nil)
    }
}



//MARK: UIPanGestureRecognizer conforming to Swipe
extension UIPanGestureRecognizer: Swipe {}

