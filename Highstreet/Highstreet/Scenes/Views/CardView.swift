//
//  CardView.swift
//  Highstreet
//
//  Created by Dario Langella on 09/09/2018.
//  Copyright © 2018 Dario Langella. All rights reserved.
//

import UIKit

class CardView: UIView, NibView {
    weak var delegate: CardViewDelegate?
    
    var rotationAngle : Float = 0.0
    var zoomScale : Float = 0.0
    
    var image : UIImage?
    
    var cardObject : CardObject?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    init(frame: CGRect, with cardObject : CardObject){
        super.init(frame: frame)
        
        if let img = cardObject.image {
            self.image = UIImage.init(named: img)
        }
        
        self.rotationAngle = cardObject.rotationAngle
        self.zoomScale = cardObject.zoomScale
        self.cardObject = cardObject
        
        commonInit()
    }
    
    public func updateView(){
        if let card = cardObject {
            if self.zoomScale != card.zoomScale {
                self.zoomScale = card.zoomScale
                prepareZoom()
            }
            
            if self.rotationAngle != card.rotationAngle {
                self.rotationAngle = card.rotationAngle
                prepareAngle()
            }
        }
    }
    
    private func commonInit(){
        prepareGestures()
        prepareImage()
        prepareAngle()
    }
    
    private func prepareImage(){
        guard let img = image else {
            return
        }
        
        let imageView = UIImageView.init(frame: .zero)
        self.addSubview(imageView)
        self.edgeConstrain(subView: imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.image = img
        imageView.isUserInteractionEnabled = true
    }
    
    private func prepareAngle(){
        self.transform = self.transform.rotated(by: CGFloat(self.rotationAngle))
    }
    
    private func prepareZoom(){
        self.transform = self.transform.scaledBy(x: CGFloat(self.zoomScale), y: CGFloat(self.zoomScale))
    }
    
    private func prepareGestures(){
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tapCard(sender:)))
        tapGesture.delegate = self
        
        let pinchGesture = UIPinchGestureRecognizer.init(target: self, action: #selector(pinchCard(sender:)))
        pinchGesture.delegate = self
        
        let panGesture = UIPanGestureRecognizer.init(target: self, action: #selector(swipeCard(sender:)))
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 1
        
        let rotateGesture = UIRotationGestureRecognizer.init(target: self, action: #selector(rotateCard(sender:)))
        rotateGesture.delegate = self
        
        self.isMultipleTouchEnabled = true
        
        addGestureRecognizer(tapGesture)
        addGestureRecognizer(pinchGesture)
        addGestureRecognizer(panGesture)
        addGestureRecognizer(rotateGesture)
    }
}

//MARK : Animations
extension CardView {
    public func resetTransform(completion: @escaping (_ result: Bool) -> Void){
        UIView.animate(withDuration: 0.5, animations: {
            self.transform = .identity
            self.prepareAngle()
        }) { (finished) in
            completion(true)

        }
    }
}

//MARK : Gestures
extension CardView {
    @objc func swipeCard(sender: UIPanGestureRecognizer) {
        sender.swipeView(self) { (finished) in
            self.dismiss()
        }
    }
    
    @objc func pinchCard(sender: UIPinchGestureRecognizer) {
        sender.pinchView(self) { finished, zoomScale  in
            self.dismiss()
        }
    }
    
    @objc func rotateCard(sender : UIRotationGestureRecognizer) {
        sender.rotateView(self) { finished ,rotationAngle  in
            self.dismiss()
        }
    }
    
    @objc func tapCard(sender : UITapGestureRecognizer) {
        sender.tapView(self) { (finished) in
            self.delegate?.didSelect(card: self)
        }
    }
    
    func dismiss(){
        let originalTransform = self.transform
        if let superview = self.superview {
            let centerTraslationX = superview.center.x - (self.frame.width / 2)
            UIView.animate(withDuration: 1.25, delay: 0.0, usingSpringWithDamping: 0.75, initialSpringVelocity: 5, options: .curveEaseOut, animations: {
                self.transform = originalTransform.translatedBy(x: centerTraslationX, y: superview.frame.size.height)
            }) { (finished) in
                if finished {
                    self.delegate?.didDismiss(card: self)
                }
            }
        }
    }
}

extension CardView : UIGestureRecognizerDelegate {
    func gestureRecognizer(_: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith shouldRecognizeSimultaneouslyWithGestureRecognizer:UIGestureRecognizer) -> Bool {
        return true
    }
}
