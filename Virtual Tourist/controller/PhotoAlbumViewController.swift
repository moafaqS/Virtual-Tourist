//
//  PhotosViewController.swift
//  Virtual Tourist
//
//  Created by moafaq waleed simbawa on 16/02/1441 AH.
//  Copyright © 1441 moafaq. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class PhotoAlbumViewController: UIViewController , MKMapViewDelegate  , UICollectionViewDelegate , UICollectionViewDataSource{
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var newCollectionButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var noImagesLabel: UILabel!
  
    var dataController : DataController!
    var pin : Pin!
    var photoes : [Photo] = []
    var selectedItemToDelete = [Photo]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = true
        newCollectionButton.isEnabled = false
        deleteButton.isHidden = true
        addAnnotationToMap()
        requestData()
     }
    
    fileprivate func addAnnotationToMap() {
         // Do any additional setup after loading the view.
         let annotation = MKPointAnnotation()
         annotation.coordinate.latitude = pin.latitude
         annotation.coordinate.longitude = pin.longitude
         
         mapView.addAnnotation(annotation)
         let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
         let region = MKCoordinateRegion(center: annotation.coordinate, span: span)
         mapView.setRegion(region, animated: true)
     }
     

    @IBAction func newCollectionPressed(_ sender: Any) {
 
        let number = Int.random(in: 1..<Int(pin.totalPages))
        
        API.getPhotoes(latitude: pin.latitude, longitude: pin.longitude, page: number) { (photos, error) in
            if error == nil{
                for item in self.photoes{
                    self.RemoveImege(img: item)
                }
                self.photoes.removeAll()
                self.createPhotosURLS(object: photos!)
            }else{
                print(error?.localizedDescription)
            }

        }

    }
    
    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    func RemoveImege(img : Photo){
        dataController.viewContext.delete(img)
        try? dataController.viewContext.save()
    }
    

    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        
        for item in selectedItemToDelete{
            // delete from presistence store
            let imgToDelete = item
            dataController.viewContext.delete(imgToDelete)
            try? dataController.viewContext.save()
            // update the collection view items
            photoes = photoes.filter({$0 != item})
    
        }
        deleteButton.isHidden = true
        if photoes.count == 0 {
                   newCollectionButton.isEnabled = true
        }
               
        
        collectionView.reloadData()

        
    }
    

}

extension PhotoAlbumViewController{
    
       func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           noImagesLabel.isHidden = photoes.count == 0 ? false : true
           return photoes.count
       }
       
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! PhotoViewCell
               cell.photo.image = UIImage(data: self.photoes[indexPath.row].image!)
               cell.layer.borderWidth = 2.0
               cell.layer.borderColor = UIColor.black.cgColor
           return cell
       }
       
       
       
       func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           selectedItemToDelete.append(photoes[indexPath.row])
           
           let cell = collectionView.cellForItem(at: indexPath)
           cell?.layer.borderWidth = 2.0
           cell?.layer.borderColor = UIColor.gray.cgColor
           
           deleteButton.isHidden = false
           newCollectionButton.isEnabled = false
       }
       
       func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
           
           selectedItemToDelete = selectedItemToDelete.filter { $0 != photoes[indexPath.row] }
           
           let cell = collectionView.cellForItem(at: indexPath)
           cell?.layer.borderWidth = 2.0
           cell?.layer.borderColor = UIColor.black.cgColor
    
           deleteButton.isHidden = selectedItemToDelete.count != 0  ? false : true
           newCollectionButton.isEnabled = selectedItemToDelete.count != 0  ? false : true
           
       }
}

