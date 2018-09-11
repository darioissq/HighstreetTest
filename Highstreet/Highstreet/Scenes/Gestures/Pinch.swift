//
//  Pinch.swift
//  Highstreet
//
//  Created by Dario Langella on 09/09/2018.
//  Copyright © 2018 Dario Langella. All rights reserved.
//

import UIKit

//MARK: Protocol
protocol Pinch { }

//MARK: Protocol extension constrained to UIPinchGestureRecognizer
extension Pinch where Self: UIPinchGestureRecognizer {
    
    //MARK : Main function
    func pinchView(_ view : UIView, completion: @escaping (_ finished: Bool, _ zoomScale : CGFloat) -> Void) {
        let currentScale = Float(self.view?.layer.value(forKeyPath: "transform.scale.x") as! Double)
        let minScale: CGFloat = 1.0
        let zoomSpeed: CGFloat = 0.5
        
        switch state {
        case .failed:
            break
        case .possible:
            break
        case .began:
            UIView.animate(withDuration: 0.25, animations: {
                self.view?.transform = CGAffineTransform.identity
            })
            break
        case .changed:
            var deltaScale = scale
            deltaScale = ((deltaScale - 1) * zoomSpeed) + 1
            deltaScale = max(deltaScale, minScale / CGFloat(currentScale))
            
            var pinchCenter = location(in: self.view)
            pinchCenter.x -= (self.view?.bounds.midX)!
            pinchCenter.y -= (self.view?.bounds.midY)!
            
            var transform = self.view?.transform
            transform = transform?.translatedBy(x: pinchCenter.x, y: pinchCenter.y)
            transform = transform?.scaledBy(x: deltaScale, y: deltaScale)
            transform = transform?.translatedBy(x: -pinchCenter.x, y: -pinchCenter.y)
            self.view?.transform = transform!
            self.scale = 1.0
        case .ended, .cancelled:
            UIView.animate(withDuration: 0.25, animations: {
                self.view?.transform = CGAffineTransform.identity
            }) { (finished) in
                if finished {
                    completion(true, self.scale)
                }
            }
        }
    }
}


//MARK: UIPinchGestureRecognizer conforming to Pinch
extension UIPinchGestureRecognizer: Pinch {}
