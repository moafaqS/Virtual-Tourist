//
//  MapViewController.swift
//  Virtual Tourist
//
//  Created by moafaq waleed simbawa on 16/02/1441 AH.
//  Copyright © 1441 moafaq. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController , MKMapViewDelegate {
    
    let dataController = DataController(modelName: "Virtual_Tourist")
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var EditButton: UIButton!
    @IBOutlet weak var labelEdit: UILabel!
    
    var edit : Bool = false
    
    var pins : [Pin] = []
   
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        dataController.load()
        EditButton.layer.cornerRadius = 0.5 * EditButton.bounds.size.width
        labelEdit.isHidden = !edit
        
        let fetchResquest : NSFetchRequest<Pin> = Pin.fetchRequest()
               if let results = try? dataController.viewContext.fetch(fetchResquest){
                   pins = results
                   loadPins()
               }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        loadPins()
    }
    
    
    // to add pin
    
    @IBAction func HoldGesture(_ sender: UILongPressGestureRecognizer) {
        
        if sender.state == .ended{
            let locationInView = sender.location(in: mapView)
            let tappedCordinate = mapView.convert(locationInView, toCoordinateFrom: mapView)
            
            if !edit{
    
                // add the cordinate to core data
                let pin = Pin(context: dataController.viewContext)
                pin.latitude = tappedCordinate.latitude
                pin.longitude = tappedCordinate.longitude
                try? dataController.viewContext.save()
                
                pins.append(pin)
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = tappedCordinate
                mapView.addAnnotation(annotation)
            }
        }
        
    }
    

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        let selectedPin = pins.first { (pin) -> Bool in
                       pin.latitude == (view.annotation?.coordinate.latitude)! && pin.longitude == (view.annotation?.coordinate.longitude)!
                        }
        
        if edit{
            // perfoem deletion
            dataController.viewContext.delete(selectedPin!)
            try? dataController.viewContext.save()
            mapView.removeAnnotation(view.annotation!)
            
        }else{
            // perform segue
            performSegue(withIdentifier: "toPhotoViewController", sender: selectedPin)
        }
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.destination is PhotoAlbumViewController{
            let vc = segue.destination as? PhotoAlbumViewController
            vc!.pin = sender as? Pin
            vc?.dataController = dataController
        }
        
    }
    

    @IBAction func EditButtonPressed(_ sender: Any) {
        labelEdit.isHidden = edit
        edit = !edit
    }
    
    
    
    
    func loadPins(){
        
        // to avoid repetition of annotations
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        
        var annotations = [MKPointAnnotation]()
        for pin in pins{
            let annotation = MKPointAnnotation()
            annotation.coordinate.latitude = pin.latitude
            annotation.coordinate.longitude = pin.longitude
            annotations.append(annotation)
        }
        self.mapView.addAnnotations(annotations)
    }
    
    
    
    
}
