//
//  StackCardViewContainer.swift
//  Highstreet
//
//  Created by Dario Langella on 09/09/2018.
//  Copyright © 2018 Dario Langella. All rights reserved.
//

import UIKit

class StackCardViewContainer: UIView {
    weak var delegate: StackCardViewDelegate?
    
    let dataManager = DataManager()
    
    var datasource: StackCardViewDatasource? {
        didSet {
            reloadData()
        }
    }
    
    private var cardViews: [CardView] = []
    
    private var visibleCardViews: [CardView] {
        return subviews as? [CardView] ?? []
    }
    
    static let numberOfVisibleCards: Int = 1
    
    func reloadData() {
        removeAllCardViews()
        
        guard let datasource = datasource else {
            return
        }
        
        let numberOfCards = datasource.numberOfCards()
        
        
        for index in 0..<numberOfCards {
            addCardView(cardView: datasource.card(forItemAtIndex: index), atIndex: index)
        }

        setNeedsLayout()
    }
    
    private func addCardView(cardView: CardView, atIndex index: Int) {
        cardView.delegate = self
        setFrame(forCardView: cardView, atIndex: index)
        cardViews.append(cardView)
        insertSubview(cardView, at: 0)
    }
    
    private func removeAllCardViews() {
        for cardView in visibleCardViews {
            cardView.removeFromSuperview()
        }
        cardViews = []
    }
    
    private func setFrame(forCardView cardView: CardView, atIndex index: Int) {
        cardView.frame = .zero
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.isUserInteractionEnabled = true
        self.addSubview(cardView)
        NSLayoutConstraint.activate([
            cardView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            cardView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.75),
            cardView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            cardView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.55),
            ])
    }
}

//MARK : Functions
extension StackCardViewContainer {
    func didEndSwipe(on cardView : CardView) {
        self.sendSubview(toBack: cardView)
        cardView.resetTransform { (finished) in
            cardView.updateView()
            print("Back to position")
        }
    }
}

//MARK : CardView Delegates
extension StackCardViewContainer: CardViewDelegate {
    func didUpdate(rotationAngle: CGFloat, in card: CardObject) {
        dataManager.edit(card: card, withRotationAngle: rotationAngle)
    }
    
    func didUpdate(zoomScale: CGFloat, in card: CardObject) {
        dataManager.edit(card: card, withZoomScale: zoomScale)
    }
    
    func didDismiss(card: CardView) {
        didEndSwipe(on: card)
    }
    
    func didSelect(card: CardView) {
        self.delegate?.didSelect(card: card)
        print("Card tapped")
    }
}

