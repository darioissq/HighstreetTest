//
//  CardViewDelegate.swift
//  Highstreet
//
//  Created by Dario Langella on 09/09/2018.
//  Copyright © 2018 Dario Langella. All rights reserved.
//

import UIKit

protocol CardViewDelegate: class {
    func didSelect(card: CardView)
    func didDismiss(card : CardView)
    func didUpdate(rotationAngle : CGFloat, in card : CardObject)
    func didUpdate(zoomScale : CGFloat, in card : CardObject)
}

