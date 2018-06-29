//
//  WorldFaceTracking.swift
//  AugmentedRealityTest
//
//  Created by MacBook on 07.06.18.
//  Copyright © 2018 Anonymer Eintrag. All rights reserved.
//
import UIKit
import Foundation
import Vision
import ARKit

class WorldFaceTracking{
    var viewModeARSCN : ARSCNView?

    var santaHat = SCNNode()
    var modelScene : SCNScene?
    
    private var scanTimer: Timer?
    private var scannedFaceViews = [UIView]()
    
    private var imageOrientation: CGImagePropertyOrientation {
        switch UIDevice.current.orientation {
        case .portrait: return .right
        case .landscapeRight: return .down
        case .portraitUpsideDown: return .left
        case .unknown: fallthrough
        case .faceUp: fallthrough
        case .faceDown: fallthrough
        case .landscapeLeft: return .up
        }
    }
    
    @objc
    public func scanForFaces() {
        
        //remove the test views and empty the array that was keeping a reference to them
        _ = scannedFaceViews.map { $0.removeFromSuperview() }
        scannedFaceViews.removeAll()
        
        //get the captured image of the ARSession's current frame
        guard let capturedImage = viewModeARSCN?.session.currentFrame?.capturedImage else { return }
        
        let image = CIImage.init(cvPixelBuffer: capturedImage)
        
        let detectFaceRequest = VNDetectFaceRectanglesRequest { (request, error) in
            
            DispatchQueue.main.async {
                //Loop through the resulting faces and add a red UIView on top of them.
                if let faces = request.results as? [VNFaceObservation] {
                    if(faces.isEmpty){
                        NSLog("NO FACE FOUND!")
                        self.santaHat.isHidden = true
                    }else{
                        for face in faces {
                            self.santaHat.isHidden = false
                            let faceView = UIView(frame: self.faceFrame(from: face.boundingBox))
                            
                            faceView.backgroundColor = .red
                            
                            let xUpperLeftFF = face.boundingBox.minX * (self.viewModeARSCN?.bounds.width)!
                            let yUpperLeftFF = (1 - face.boundingBox.maxY) * (self.viewModeARSCN?.bounds.height)!
                            let widthFF = face.boundingBox.width * (self.viewModeARSCN?.bounds.width)!
                            let heightFF = face.boundingBox.height * (self.viewModeARSCN?.bounds.height)!
                            let scaleFactor = ((widthFF/100)*(heightFF/100))/3
                            
                            NSLog("xFF : %f  yFF : %f", xUpperLeftFF, yUpperLeftFF)
                            NSLog("widthFF : %f  heightFF : %f", widthFF, heightFF)
                            NSLog("minX : %f  minY : %f", face.boundingBox.minX, face.boundingBox.minY)
                            NSLog("maxX : %f  maxY : %f", face.boundingBox.maxX, face.boundingBox.maxY)
                            NSLog("scaleFactor : %f", scaleFactor)
                            
                            let scaleAction = SCNAction.scale(to: scaleFactor, duration: 0)
                            let moveAction = SCNAction.move(to: SCNVector3((face.boundingBox.maxX/2),(face.boundingBox.minY),-1), duration: 0)
                            //let actionSequence = SCNAction.sequence([scaleAction,moveAction])
                            
                            self.santaHat.runAction(scaleAction)
                            self.santaHat.runAction(moveAction)
                            
                            
                            //self.santaHat.position = SCNVector3((widthFF/2),0,-3)
                            self.viewModeARSCN?.scene = self.modelScene!
                            
                            self.viewModeARSCN?.addSubview(faceView)
                            
                            self.scannedFaceViews.append(faceView)
                        }
                    }
                }
            }
        }
        
        DispatchQueue.global().async {
            try? VNImageRequestHandler(ciImage: image, orientation: self.imageOrientation).perform([detectFaceRequest])
        }
    }
    
    private func faceFrame(from boundingBox: CGRect) -> CGRect {
        
        //translate camera frame to frame inside the ARSKView
        let origin = CGPoint(x: boundingBox.minX * (viewModeARSCN?.bounds.width)!, y: (1 - boundingBox.maxY) * (viewModeARSCN?.bounds.height)!)
        let size = CGSize(width: boundingBox.width * (viewModeARSCN?.bounds.width)!, height: boundingBox.height * (viewModeARSCN?.bounds.height)!)
        
        return CGRect(origin: origin, size: size)
    }
    public func setARSCNView(SceneView : ARSCNView){
        self.viewModeARSCN = SceneView
    }
    

    
}
