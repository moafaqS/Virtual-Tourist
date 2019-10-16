//
//  DataController.swift
//  Virtual Tourist
//
//  Created by moafaq waleed simbawa on 16/02/1441 AH.
//  Copyright © 1441 moafaq. All rights reserved.
//

import Foundation
import CoreData

class DataController{
    let presistenceContainer : NSPersistentContainer
    
    var viewContext :NSManagedObjectContext{
        return presistenceContainer.viewContext
    }
    
    init(modelName : String) {
        presistenceContainer = NSPersistentContainer(name: modelName)
    }
    
    func load( completion:(() -> Void)? = nil){
        presistenceContainer.loadPersistentStores { (storeDescripition, error) in
            guard error == nil else{
                fatalError(error!.localizedDescription)
            }
            completion?()
        }
    }
}

