
//
//  Tap.swift
//  Highstreet
//
//  Created by Dario Langella on 10/09/2018.
//  Copyright © 2018 Dario Langella. All rights reserved.
//

import UIKit

//MARK: Protocol
protocol Tap { }

//MARK: Protocol extension constrained to UIPanGestureRecognizer
extension Tap where Self: UITapGestureRecognizer {
    
    //MARK: Main function
    func tapView(_ view: UIView, completion: (_ result: Bool) -> Void){
        
        switch state {
        case .ended:
            completion(true)
        default:
            break
        }
    }
}



//MARK: UITapGestureRecognizer conforming to Tap
extension UITapGestureRecognizer: Tap {}

