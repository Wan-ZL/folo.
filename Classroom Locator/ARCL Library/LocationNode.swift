//
//  LocationNode.swift
//  ARKit+CoreLocation
//
//  Created by Andrew Hart on 02/07/2017.
//  Copyright © 2017 Project Dent. All rights reserved.
//

import Foundation
import SceneKit
import CoreLocation

///A location node can be added to a scene using a coordinate.
///Its scale and position should not be adjusted, as these are used for scene layout purposes
///To adjust the scale and position of items within a node, you can add them to a child node and adjust them there
open class LocationNode: SCNNode {
    ///Location can be changed and confirmed later by SceneLocationView.
    public var location: CLLocation!
    
    ///Whether the location of the node has been confirmed.
    ///This is automatically set to true when you create a node using a location.
    ///Otherwise, this is false, and becomes true once the user moves 100m away from the node,
    ///except when the locationEstimateMethod is set to use Core Location data only,
    ///as then it becomes true immediately.
    public var locationConfirmed = false
    
    ///Whether a node's position should be adjusted on an ongoing basis
    ///based on its' given location.
    ///This only occurs when a node's location is within 100m of the user.
    ///Adjustment doesn't apply to nodes without a confirmed location.
    ///When this is set to false, the result is a smoother appearance.
    ///When this is set to true, this means a node may appear to jump around
    ///as the user's location estimates update,
    ///but the position is generally more accurate.
    ///Defaults to true.
    public var continuallyAdjustNodePositionWhenWithinRange = true
    
    ///Whether a node's position and scale should be updated automatically on a continual basis.
    ///This should only be set to false if you plan to manually update position and scale
    ///at regular intervals. You can do this with `SceneLocationView`'s `updatePositionOfLocationNode`.
    public var continuallyUpdatePositionAndScale = true
    
    public init(location: CLLocation?) {
        self.location = location
        self.locationConfirmed = location != nil
        super.init()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

open class LocationAnnotationNode: LocationNode {
    
    let offsetToHoriz : Float = 25
    
    ///An image to use for the annotation
    ///When viewed from a distance, the annotation will be seen at the size provided
    ///e.g. if the size is 100x100px, the annotation will take up approx 100x100 points on screen.
    public let image: UIImage
    
    ///Subnodes and adjustments should be applied to this subnode
    ///Required to allow scaling at the same time as having a 2D 'billboard' appearance
    public let annotationNode: SCNNode
    
    ///Whether the node should be scaled relative to its distance from the camera
    ///Default value (false) scales it to visually appear at the same size no matter the distance
    ///Setting to true causes annotation nodes to scale like a regular node
    ///Scaling relative to distance may be useful with local navigation-based uses
    ///For landmarks in the distance, the default is correct
    public var scaleRelativeToDistance = false
    
    public init(location: CLLocation?, image: UIImage) {
        self.image = image
        
        let plane = SCNPlane(width: image.size.width / 100, height: image.size.height / 100)
        plane.firstMaterial!.diffuse.contents = image
        plane.firstMaterial!.lightingModel = .constant
        
        annotationNode = SCNNode()
        annotationNode.geometry = plane
        
        super.init(location: location)
        
        let billboardConstraint = SCNBillboardConstraint()
        billboardConstraint.freeAxes = SCNBillboardAxis.Y
        constraints = [billboardConstraint]
        
        addChildNode(annotationNode)
    }
    
    // Wan Added - Name Tag AR Overlay
    public init(location: CLLocation?, text: String, room: String, distance: CLLocationDistance) {
        print("DISTANCE TO \(text) IS \(distance)")
        
        // Mode - Scaling changes of tag for various distance to user
        /*let scale = Float(100.0 / distance)
         var textColor = UIColor.orange
         switch scale {
         case 0..<0.5:
         textColor = UIColor.orange
         case 0.5...:
         textColor = UIColor.white
         default:
         textColor = UIColor.white
         }*/
        
        let strs = text.components(separatedBy: " ")
        var building : String = ""
        var strLine : Int = 1
        var temp : Int = 0
        for str in strs{
            if((temp + str.count) > 22 ) {
                building += "\n\(str) "
                temp = (str.count + 1)
                strLine += 1
            }else{
                building += "\(str) "
                temp += (str.count + 1)
            }
        }
        building += "\n\(room)"
        strLine += 1
        let yOffset : Float = (Float(strLine)*(-3.8))
        
        // Mode - smaller range of sacling changes size and color
        let scale = Float(1.0)
        let textColor = UIColor.white
        
        let geoText = SCNText(string: building, extrusionDepth: 0.1)
        geoText.flatness = CGFloat(0.1)
        geoText.font = UIFont.systemFont(ofSize:3.4, weight:UIFont.Weight.black) //bold font
        geoText.alignmentMode = kCAAlignmentLeft
        geoText.firstMaterial!.diffuse.contents = textColor
        let textNode = SCNNode(geometry: geoText)
        textNode.opacity = CGFloat(0.8)
        
        let (minVec, maxVec) = textNode.boundingBox
        //textNode.position = SCNVector3(x: (minVec.x - maxVec.x) / 2, y: minVec.y - maxVec.y, z: 0)
        textNode.scale = SCNVector3Make(scale,scale,scale)
        textNode.position = SCNVector3(x: 0, y: yOffset-offsetToHoriz, z: 0)
        textNode.pivot = SCNMatrix4MakeTranslation(0, 0, 0)
        
        let w = CGFloat(maxVec.x - minVec.x)
        let h = CGFloat(maxVec.y - minVec.y)
        let d = CGFloat(maxVec.z - minVec.z)
        
        let geoBox = SCNBox(width: w, height: h, length: d, chamferRadius: 0)
        geoBox.firstMaterial!.diffuse.contents =   UIColor.gray.withAlphaComponent(0)
        annotationNode = SCNNode(geometry: geoBox)
        //annotationNode.position = SCNVector3Make((maxVec.x - minVec.x) / 2 + minVec.x, (maxVec.y - minVec.y) / 2 + minVec.y, 0);
        annotationNode.position = SCNVector3Make(minVec.x, (maxVec.y - minVec.y) / 2 + minVec.y, 0);
        textNode.addChildNode(annotationNode)
        
        self.image = UIImage(named:"default")!
        
        super.init(location: location)
        
        let billboardConstraint = SCNBillboardConstraint()
        billboardConstraint.freeAxes = SCNBillboardAxis.Y
        constraints = [billboardConstraint]
        
        
        let moveUp = SCNAction.moveBy(x: 0, y: 1, z: 0, duration: 1)
        moveUp.timingMode = .easeInEaseOut;
        let moveDown = SCNAction.moveBy(x: 0, y: -1, z: 0, duration: 1)
        moveDown.timingMode = .easeInEaseOut;
        let moveSequence = SCNAction.sequence([moveUp,moveDown])
        let moveLoop = SCNAction.repeatForever(moveSequence)
        textNode.runAction(moveLoop)
        
        
        addChildNode(textNode)
    }
    // Wan Added - Distance Tag AR Overlay
    public init(location: CLLocation?, distance: CLLocationDistance) {
        let arrivingDist : Float = 150
        let scale = Float(1.0)
        let textColor = UIColor.orange
        /*
         * Distance indicator
         */
        // Mode - smaller range of sacling changes size and color
        //let distText = String(Int(distance)) + "m" //in meters
        let distText : String
        let feet = Float(distance*3.28084)
        if(feet > 5280){
            let mile = Float(feet/5280.0)
            distText = String(Float(round(100*mile)/100)) + "mi"
        }
        else {
            distText = String(Int(feet)) + "ft"
        }
        
        let geoText = SCNText(string: distText, extrusionDepth: 1)
        geoText.flatness = CGFloat(0.1) // Increse smoothness of curves
        //geoText.font = UIFont (name: "San Francisco", size: 12)
        geoText.font = UIFont.systemFont(ofSize:12, weight:UIFont.Weight.black) //bold font
        //geoText.alignmentMode = kCAAlignmentRight
        geoText.firstMaterial!.diffuse.contents = textColor
        let textNode = SCNNode(geometry: geoText)
        
        let (minVec, maxVec) = textNode.boundingBox
        textNode.scale = SCNVector3Make(scale,scale,scale)
        textNode.position = SCNVector3(x: 0, y: 0-offsetToHoriz, z: 0)
        textNode.pivot = SCNMatrix4MakeTranslation(0, 0, 0)
        
        let w = CGFloat(2.5) // X
        let h = CGFloat(0.8) // Y
        let d = CGFloat(0.1) // Z
        
        let geoBox = SCNBox(width: w, height: h, length: d, chamferRadius: 0.8)
        geoBox.firstMaterial!.diffuse.contents =   UIColor.gray.withAlphaComponent(0.3)
        annotationNode = SCNNode(geometry: geoBox)
        annotationNode.position = SCNVector3Make((maxVec.x - minVec.x) / 2 + minVec.x, (maxVec.y - minVec.y) / 2 + minVec.y+1, -2);
        textNode.addChildNode(annotationNode)
        
        /*
         * Diatance indicator Text
         */
        // Mode - smaller range of sacling changes size and color
        let text = String("Distance to Your Classroom")
        
        let titleText = SCNText(string: text, extrusionDepth: 1)
        titleText.flatness = CGFloat(0.1) // Increse smoothness of curves
        titleText.font = UIFont.systemFont(ofSize:14, weight:UIFont.Weight.black) //bold font
        //titleText.alignmentMode = kCAAlignmentRight
        titleText.firstMaterial!.diffuse.contents = UIColor.orange
        let distNode = SCNNode(geometry: titleText)
        
        let (minVec1, maxVec1) = distNode.boundingBox
        distNode.scale = SCNVector3Make(scale/6,scale/6,scale/6)
        distNode.position = SCNVector3(x:0, y: 12-offsetToHoriz, z: 0)
        distNode.pivot = SCNMatrix4MakeTranslation(0, 0, 0)
        
        let w1 = CGFloat(2.0) // X
        let h1 = CGFloat(1.0) // Y
        let d1 = CGFloat(0.1) // Z
        
        let distBox = SCNBox(width: w1, height: h1, length: d1, chamferRadius: 0)
        //geoBox.firstMaterial!.diffuse.contents =   UIColor.white.withAlphaComponent(0.2)
        let distTextNode: SCNNode
        distTextNode = SCNNode(geometry: distBox)
        distTextNode.position = SCNVector3Make((maxVec1.x - minVec1.x) / 2 + minVec1.x, (maxVec1.y - minVec1.y) / 2 + minVec1.y, -2);
        distNode.addChildNode(distTextNode)
        
        self.image = UIImage(named:"default")!
        
        super.init(location: location)
        
        let billboardConstraint = SCNBillboardConstraint()
        billboardConstraint.freeAxes = SCNBillboardAxis.Y
        constraints = [billboardConstraint]
        
        addChildNode(textNode)
        addChildNode(distNode)
        
        // Show arrival info
        if(feet < arrivingDist){
            let arrivText = SCNText(string: "CONGRATULATIONS,", extrusionDepth: 0.1)
            arrivText.flatness = CGFloat(0.1) // Increse smoothness of curves
            //geoText.font = UIFont (name: "San Francisco", size: 12)
            arrivText.font = UIFont.systemFont(ofSize:4, weight:UIFont.Weight.ultraLight) //bold font
            //geoText.alignmentMode = kCAAlignmentRight
            arrivText.firstMaterial!.diffuse.contents = UIColor.yellow
            
            let arrivNode = SCNNode(geometry: arrivText)
            let (minVec, maxVec) = arrivNode.boundingBox
            arrivNode.scale = SCNVector3Make(scale,scale,scale)
            arrivNode.position = SCNVector3(x: 0, y: 38-offsetToHoriz, z: 0)
            arrivNode.pivot = SCNMatrix4MakeTranslation(0, 0, 0)
            
            let w = CGFloat(2.5) // X
            let h = CGFloat(0.8) // Y
            let d = CGFloat(0.1) // Z
            
            let arrivBox = SCNBox(width: w, height: h, length: d, chamferRadius: 0.8)
            arrivBox.firstMaterial!.diffuse.contents =   UIColor.gray.withAlphaComponent(0)
            let arrivTextNode: SCNNode
            arrivTextNode = SCNNode(geometry: arrivBox)
            arrivTextNode.position = SCNVector3Make((maxVec.x - minVec.x) / 2 + minVec.x, (maxVec.y - minVec.y) / 2 + minVec.y+1, -2);
            arrivNode.addChildNode(arrivTextNode)
            addChildNode(arrivNode)
            
            
            let arrivText1 = SCNText(string: "YOU'VE FOUND \nYOUR WAY!", extrusionDepth: 0.1)
            arrivText1.flatness = CGFloat(0.1) // Increse smoothness of curves
            arrivText1.font = UIFont.systemFont(ofSize:6, weight:UIFont.Weight.ultraLight) //bold font
            arrivText1.firstMaterial!.diffuse.contents = UIColor.yellow
            
            let arrivNode1 = SCNNode(geometry: arrivText1)
            let (minVec1, maxVec1) = arrivNode.boundingBox
            arrivNode1.scale = SCNVector3Make(scale,scale,scale)
            arrivNode1.position = SCNVector3(x: 0, y: 23-offsetToHoriz, z: 0)
            arrivNode1.pivot = SCNMatrix4MakeTranslation(0, 0, 0)
            
            let w1 = CGFloat(2.5) // X
            let h1 = CGFloat(0.8) // Y
            let d1 = CGFloat(0.1) // Z
            
            let arrivBox1 = SCNBox(width: w1, height: h1, length: d1, chamferRadius: 0.8)
            arrivBox1.firstMaterial!.diffuse.contents =   UIColor.gray.withAlphaComponent(0)
            let arrivTextNode1: SCNNode
            arrivTextNode1 = SCNNode(geometry: arrivBox1)
            arrivTextNode1.position = SCNVector3Make((maxVec1.x - minVec1.x) / 2 + minVec1.x, (maxVec1.y - minVec1.y) / 2 + minVec1.y+1, -2);
            arrivNode1.addChildNode(arrivTextNode1)
            
            let rotateByY = SCNAction.rotateBy(x: 0, y:CGFloat(4*Double.pi), z: 0, duration: 2)
            rotateByY.timingMode = .easeInEaseOut
            let fadeIn = SCNAction.fadeIn(duration: 1)
            let fadeOut = SCNAction.fadeOut(duration: 1)
            let moveSequence = SCNAction.sequence([fadeIn,rotateByY,fadeOut])
            let moveLoop = SCNAction.repeatForever(moveSequence)
            arrivNode.runAction(moveLoop)
            arrivNode1.runAction(moveLoop)
            
            addChildNode(arrivNode1)
        }
        
    }
    // Wan Added - Course AR Overlay
    public init(location: CLLocation?, course: String, distance: CLLocationDistance) {
        // Mode - smaller range of sacling changes size and color
        let scale = Float(1)
        let textColor = UIColor.orange
        
        let geoText = SCNText(string: course, extrusionDepth: 0.1)
        geoText.flatness = CGFloat(0.1)
        geoText.font = UIFont.systemFont(ofSize:6, weight:UIFont.Weight.bold) //bold font
        geoText.alignmentMode = kCAAlignmentLeft
        geoText.firstMaterial!.diffuse.contents = textColor
        let textNode = SCNNode(geometry: geoText)
        
        let (minVec, maxVec) = textNode.boundingBox
        //textNode.position = SCNVector3(x: (minVec.x - maxVec.x) / 2, y: minVec.y - maxVec.y, z: 0)
        textNode.scale = SCNVector3Make(scale,scale,scale)
        textNode.position = SCNVector3(x: 0, y: 15-offsetToHoriz, z: 0)
        textNode.pivot = SCNMatrix4MakeTranslation(0, 0, 0)
        
        let w = CGFloat(maxVec.x - minVec.x)
        let h = CGFloat(maxVec.y - minVec.y)
        let d = CGFloat(maxVec.z - minVec.z)
        
        let geoBox = SCNBox(width: w, height: h, length: d, chamferRadius: 0)
        geoBox.firstMaterial!.diffuse.contents =   UIColor.gray.withAlphaComponent(0)
        annotationNode = SCNNode(geometry: geoBox)
        //annotationNode.position = SCNVector3Make((maxVec.x - minVec.x) / 2 + minVec.x, (maxVec.y - minVec.y) / 2 + minVec.y, 0);
        annotationNode.position = SCNVector3Make(minVec.x, (maxVec.y - minVec.y) / 2 + minVec.y, 0);
        textNode.addChildNode(annotationNode)
        
        self.image = UIImage(named:"default")!
        
        super.init(location: location)
        
        let billboardConstraint = SCNBillboardConstraint()
        billboardConstraint.freeAxes = SCNBillboardAxis.Y
        constraints = [billboardConstraint]
        
        let moveUp = SCNAction.moveBy(x: 0, y: 1, z: 0, duration: 1)
        moveUp.timingMode = .easeInEaseOut;
        let moveDown = SCNAction.moveBy(x: 0, y: -1, z: 0, duration: 1)
        moveDown.timingMode = .easeInEaseOut;
        let moveSequence = SCNAction.sequence([moveDown,moveUp])
        let moveLoop = SCNAction.repeatForever(moveSequence)
        textNode.runAction(moveLoop)
        
        addChildNode(textNode)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

