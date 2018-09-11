//
//  Rotate.swift
//  Highstreet
//
//  Created by Dario Langella on 09/09/2018.
//  Copyright © 2018 Dario Langella. All rights reserved.
//

import UIKit

//MARK: Protocol
protocol Rotate { }

//MARK: Protocol extension constrained to UIPanGestureRecognizer
extension Rotate where Self: UIRotationGestureRecognizer {
    
    //MARK: Main function
    func rotateView(_ view : UIView, completion: @escaping (_ result: Bool, _ rotation : CGFloat) -> Void) {
        var rotation = self.rotation
        switch state {
        case .began :
            UIView.animate(withDuration: 0.25, animations: {
                self.view?.transform = CGAffineTransform.identity
            })
            break
        case .changed:
            rotation = self.rotation
            view.transform = CGAffineTransform(rotationAngle: rotation)
            break
        case .ended :
            UIView.animate(withDuration: 0.25, animations: {
                self.view?.transform = CGAffineTransform.identity
            }) { (finished) in
                if finished {
                    completion(true, rotation)
                }
            }
            break
        default:
            break
        }
    }
}

//MARK: UIRotationGestureRecognizer conforming to Rotate
extension UIRotationGestureRecognizer: Rotate {}
