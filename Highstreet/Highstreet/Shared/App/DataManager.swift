//
//  Datamanager.swift
//  Highstreet
//
//  Created by Dario Langella on 10/09/2018.
//  Copyright © 2018 Dario Langella. All rights reserved.
//

import UIKit
import CoreData

class DataManager {
    var appDelegate : AppDelegate
    var context : NSManagedObjectContext
    var entity : NSEntityDescription
        
    init(){
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        entity = NSEntityDescription.entity(forEntityName: "CardObject", in: context)!
    }
    
    public func saveCard(with image : String, rotationAngle : CGFloat, zoomScale : CGFloat){
        
        let newCard = NSManagedObject(entity: entity, insertInto: context)
        
        newCard.setValue(image, forKey: "image")
        newCard.setValue(rotationAngle, forKey: "rotationAngle")
        newCard.setValue(zoomScale, forKey: "zoomScale")
        do {
            try self.context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    public func edit(card : CardObject, withRotationAngle : CGFloat) {
        card.setValue(withRotationAngle, forKey: "rotationAngle")
        do {
            try self.context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    public func edit(card : CardObject, withZoomScale : CGFloat) {
        card.setValue(withZoomScale, forKey: "zoomScale")
        do {
            try self.context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    var cards : [CardObject]? {
        return readCards()
    }
    
    private func readCards() -> [CardObject]?{
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CardObject")
        request.returnsObjectsAsFaults = false
        
        var datas = [CardObject]()
        
        do {
            let result = try context.fetch(request)
            datas = result as! [CardObject]
            return datas
            
        } catch {
            print("Failed")
            return nil
        }
    }
}
