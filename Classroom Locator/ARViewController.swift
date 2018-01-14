//
//  ViewController.swift
//  Classroom Locator
//
//  Created by Xueheng Wan on 2018/1/12.
//  Copyright © 2018 Xueheng Wan. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import CoreLocation

class ARViewController: UIViewController, ARSKViewDelegate, ARSessionDelegate{
    
    var sceneView = SceneLocationView()
    @IBOutlet weak var back: UIButton!
    @IBOutlet weak var logoView: SCNView!
    @IBOutlet weak var returnBut: SCNView!
    var locManager:CLLocationManager!
    var uaLoc : UALocation!
    
    var isNavigating = false // represents status of navigation function
    
    // User Location
    var currentLocation : CLLocation!
    // Destenation Building Info
    var destLocation : CLLocation!
    var alt : Double = 730.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        sceneView.run()
        view.addSubview(sceneView)
        
        destLocation = CLLocation(coordinate: CLLocationCoordinate2D(latitude:Double(uaLoc.latitude!)!, longitude:Double(uaLoc.longitude!)!),altitude:alt)
        
        // Return
        let retBox = SCNBox(width: 2.805, height: 1.7, length: 1, chamferRadius: 0)
        let retNode = SCNNode(geometry: retBox)
        retNode.geometry?.materials.first?.diffuse.contents = UIColor.clear
        retNode.geometry?.materials.first?.diffuse.contents = UIImage(named:"return")
        retNode.position = SCNVector3(0.0, 0.0, -2.3)
        let moveLeft = SCNAction.moveBy(x: -0.5, y: 0, z: 0, duration: 2)
        moveLeft.timingMode = .easeInEaseOut
        let moveRight = SCNAction.moveBy(x: 0.5, y: 0, z: 0, duration: 2)
        moveRight.timingMode = .easeInEaseOut
        let moveSeq = SCNAction.sequence([moveLeft,moveRight])
        let moveL = SCNAction.repeatForever(moveSeq)
        retNode.runAction(moveL)
        //returnBut.pointOfView?.addChildNode(retNode)
        
        // Logo
        let logoBox = SCNBox(width: 2.805, height: 1.7, length: 1, chamferRadius: 0)
        let logoNode = SCNNode(geometry: logoBox)
        logoNode.geometry?.materials.first?.diffuse.contents = UIColor.clear
        logoNode.geometry?.materials.first?.diffuse.contents = UIImage(named:"logo_folo")
        logoNode.position = SCNVector3(0.0, 0.0, -3.5)
        let moveUp = SCNAction.moveBy(x: 0, y: 0.5, z: 0, duration: 2)
        moveUp.timingMode = .easeInEaseOut;
        let moveDown = SCNAction.moveBy(x: 0, y: -0.5, z: 0, duration: 2)
        moveDown.timingMode = .easeInEaseOut;
        let moveSequence = SCNAction.sequence([moveDown,moveUp])
        let moveLoop = SCNAction.repeatForever(moveSequence)
        logoNode.runAction(moveLoop)
        logoView.pointOfView?.addChildNode(logoNode)
        
        self.view.bringSubview(toFront: logoView)
        self.view.bringSubview(toFront: back)
    }
    // Put AR Tags On
    func populateNodes(){
        //
        sceneView.removeAllLocationNode()
        
        let distance = destLocation.distance(from: currentLocation)
        let buildingNode = LocationAnnotationNode(location: destLocation, text: uaLoc.locationName, room: uaLoc.roomNo, distance: distance) // For Building name tag
        let distanceNode = LocationAnnotationNode(location: destLocation, distance: distance) // For distance indicator
        let courseNode = LocationAnnotationNode(location: destLocation, course:uaLoc.courseCode + uaLoc.courseNum, distance: distance)
        sceneView.addLocationNodeWithConfirmedLocation(locationNode: buildingNode)
        sceneView.addLocationNodeWithConfirmedLocation(locationNode: distanceNode)
        sceneView.addLocationNodeWithConfirmedLocation(locationNode: courseNode)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        sceneView.frame = view.bounds
    }
    
    /// - Tag: StartARSession
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Check if the device supports ARKit
        guard ARWorldTrackingConfiguration.isSupported else {
            fatalError("""
                ARKit is not available on this device. For apps that require ARKit
                for core functionality, use the `arkit` key in the key in the
                `UIRequiredDeviceCapabilities` section of the Info.plist to prevent
                the app from installing. (If the app can't be installed, this error
                can't be triggered in a production scenario.)
                In apps where AR is an additive feature, use `isSupported` to
                determine whether to show UI for launching AR experiences.
            """) // For details, see https://developer.apple.com/documentation/arkit
        }
        
        
        /*
         Prevent the screen from being dimmed after a while as users will likely
         have long periods of interaction without touching the screen or buttons.
         */
        UIApplication.shared.isIdleTimerDisabled = true
        
        // Show debug UI to view performance metrics (e.g. frames per second).
        //sceneView.showsStatistics = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.pause()
        // Pause the view's AR session.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sceneView.run()
        determineMyCurrentLocation()
    }
    
    // Wan Added
    func determineMyCurrentLocation() {
        locManager = CLLocationManager()
        locManager.delegate = self
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        locManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locManager.startUpdatingLocation()
        }
    }
    
    
    @IBAction func goBack(_ sender: Any) {
        let tmpController :UIViewController! = self.presentingViewController;
        
        self.dismiss(animated: false, completion: {()->Void in
            print("done");
            tmpController.dismiss(animated: true, completion: nil);
        });
    }
    
}

extension ARViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        
        // manager.stopUpdatingLocation()
        self.currentLocation = userLocation
        self.alt = userLocation.altitude
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        print("user altitude = \(userLocation.altitude)")
        populateNodes()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
}

// There is nothing
// The world is about to be destroyed, and noone will get survived.

