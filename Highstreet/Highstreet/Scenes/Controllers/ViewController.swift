//
//  ViewController.swift
//  Highstreet
//
//  Created by Dario Langella on 09/09/2018.
//  Copyright © 2018 Dario Langella. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let dataManager = DataManager()

    private var datasource = [CardObject]() {
        didSet{
            stackCardView.reloadData()
        }
    }
    
    @IBOutlet var stackCardView: StackCardViewContainer!{
        didSet{
            stackCardView.delegate = self
            stackCardView.datasource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func checkData() {
        if let cards = dataManager.cards{
            if cards.count > 0 {
                datasource = cards
            } else {
                setData()
            }
        } else {
            setData()
        }
    }
    
    private func setData(){
        var index = 9
        while index != 0 {
            dataManager.saveCard(with: "\(index)", rotationAngle: CGFloat(index), zoomScale: 1.0)
            index -= 1
        }
        checkData()
    }
}

extension ViewController : StackCardViewDatasource, StackCardViewDelegate {
    func numberOfCards() -> Int {
        return datasource.count
    }
    
    func card(forItemAtIndex index: Int) -> CardView {
        let cardView = CardView.init(frame: .zero, with: datasource[index])
        return cardView
    }
    
    func didSelect(card: CardView) {
        print(card)
    }
}

extension ViewController {
    private func emptyView() -> UIView {
        let view = UIView.init()
        let label = UILabel.init(frame: .zero)
        label.textAlignment = .center
        view.addSubview(label)
        label.text = "No cards left"
        view.addEdgeConstrainedSubView(view: label)
        return view
    }
}

