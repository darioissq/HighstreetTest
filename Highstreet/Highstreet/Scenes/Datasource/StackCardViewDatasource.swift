//
//  StackCardViewDatasource.swift
//  Highstreet
//
//  Created by Dario Langella on 09/09/2018.
//  Copyright © 2018 Dario Langella. All rights reserved.
//

import UIKit

protocol StackCardViewDatasource: class {
    func numberOfCards() -> Int
    func card(forItemAtIndex index: Int) -> CardView
}
