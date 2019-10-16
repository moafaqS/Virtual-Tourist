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

class PhotosViewController: UIViewController , MKMapViewDelegate  , UICollectionViewDelegate , UICollectionViewDataSource{
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var teSTIMAGE: UIImageView!
    var dataController : DataController!
    var pin : Pin!
    var photoes : [Photo] = []
    
    var photesInformation :Photos?
    

    override func viewDidLoad() {
        super.viewDidLoad()
       
        mapView.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        
    

        // Do any additional setup after loading the view.
        
        
        let annotation = MKPointAnnotation()
        annotation.coordinate.latitude = pin.latitude
        annotation.coordinate.longitude = pin.longitude
        
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: annotation.coordinate, span: span)
        mapView.setRegion(region, animated: true)
        
        
        
        let fetchResquest : NSFetchRequest<Photo> = Photo.fetchRequest()
        let predicate = NSPredicate(format: "pin == %@", pin)
        fetchResquest.predicate = predicate
        
       
        if let results = try? dataController.viewContext.fetch(fetchResquest){
            photoes = results
            collectionView.reloadData()
            
            if results.count == 0{
                API.getPhotoes(latitude: pin.latitude, longitude: pin.longitude , page: 1) { (photos, error) in

                    if error == nil{
                        self.photesInformation = photos
                        self.createPhotosURLS(object: photos!)
                    }else{
                        print(error?.localizedDescription)
                    }
                }
            }else{
                collectionView.reloadData()
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
                    
                    //TODO : SHOW IMAGE and SAVE TO coreData
                    //self.teSTIMAGE.image = UIImage(data: data)
                    
                    let photo = Photo(context: self.dataController.viewContext)
                    photo.image = data
                    photo.pin = self.pin
                    try? self.dataController.viewContext.save()
                    self.photoes.append(photo)
                    self.collectionView.reloadData()
                }
            }
        }
    
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! PhotoViewCell
            cell.photo.image = UIImage(data: self.photoes[indexPath.row].image!)
        return cell
    }
    
    
    
    @IBAction func newCollectionPressed(_ sender: Any) {
        
        API.getPhotoes(latitude: pin.latitude, longitude: pin.longitude, page: 1) { (photos, error) in
            
        }
        
    }
    
    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

    

  

    
    
}
