//
//  PhotoAlbumViewController+Extension.swift
//  Virtual Tourist
//
//  Created by moafaq waleed simbawa on 18/02/1441 AH.
//  Copyright © 1441 moafaq. All rights reserved.
//

import UIKit
import CoreData


extension PhotoAlbumViewController{
    
    
    fileprivate func requestData() {
           let fetchResquest : NSFetchRequest<Photo> = Photo.fetchRequest()
           let predicate = NSPredicate(format: "pin == %@", pin)
           fetchResquest.predicate = predicate
           
           
           if let results = try? dataController.viewContext.fetch(fetchResquest){
               photoes = results
               
               if results.count == 0{
                   API.getPhotoes(latitude: pin.latitude, longitude: pin.longitude , page: 1) { (photos, error) in
                       
                       if error == nil{
                           let fetchResquest : NSFetchRequest<Pin> = Pin.fetchRequest()
                           let predicate = NSPredicate(format: "latitude == %@ AND longitude == %@", argumentArray: [self.pin.latitude, self.pin.longitude])
                           
                           fetchResquest.predicate = predicate
                           
                           if let currentPin = try? self.dataController.viewContext.fetch(fetchResquest){
                               currentPin[0].setValue(Int64(photos!.page), forKey: "currentPage")
                               currentPin[0].setValue(Int64(photos!.pages), forKey: "totalPages")
                               try? self.dataController.viewContext.save()
                           }
                           self.createPhotosURLS(object: photos!)
                       }else{
                           print(error?.localizedDescription)
                       }
                   }
               }else{
                   collectionView.reloadData()
                   newCollectionButton.isEnabled = true
                   
               }
               
           }
       }
    
    
    
         func createPhotosURLS(object : Photos){
             for item in object.photo{
                 let urlString = "https://farm\(item.farm).staticflickr.com/\(item.server)/\(item.id)_\(item.secret).jpg"
                 let imgUrl = URL(string: urlString)
                 print(imgUrl)
                 downloadImage(from: imgUrl!)
                 
             }
         }
         
         
         func downloadImage(from url: URL) {
             API.getImage(from: url) { data, response, error in
                 guard let data = data, error == nil else {
                     print(error?.localizedDescription)
                     return
                     
                 }
                 print(response?.suggestedFilename ?? url.lastPathComponent)
                 DispatchQueue.main.async() {
                     
                     let photo = Photo(context: self.dataController.viewContext)
                     photo.image = data
                     photo.pin = self.pin
                     try? self.dataController.viewContext.save()
                     self.photoes.append(photo)
                     self.collectionView.reloadData()
                     self.newCollectionButton.isEnabled = true
                 }
             }
         }

}

