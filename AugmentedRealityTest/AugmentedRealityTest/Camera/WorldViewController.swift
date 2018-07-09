//
//  ViewModeController.swift
//  AugmentedRealityTest
//
//  Created by Anonymer Eintrag on 30.05.18.
//  Copyright © 2018 Anonymer Eintrag. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import Vision

class WorldViewController: UIViewController, ARSCNViewDelegate {
    var fileManager : FileManager!
    
    var hats = [String](arrayLiteral: "art.scnassets/Hats/Cap/hatCap.scn","art.scnassets/Hats/CaptainHat/hatCaptainHat.scn","art.scnassets/Hats/CowboyHat/hatCowboyHat.scn", "art.scnassets/Hats/SantaHat/hatSantaHat.scn","removeModels")
    var pets = [String](arrayLiteral: "art.scnassets/Pets/Baymax/petBaymax.scn","art.scnassets/Pets/Butterfly/petButterfly.scn","art.scnassets/Pets/Deer/petDeer.scn","art.scnassets/Pets/Fly/petFly.scn","art.scnassets/Pets/Ship/petJetPilot.scn","removeModels")
    
    
    var hatPreviews = [String](arrayLiteral: "HatCollectionPreviews/Cap","HatCollectionPreviews/CaptainHat","HatCollectionPreviews/CowboyHat","HatCollectionPreviews/SantaHat","removeModels")
    var petPreviews = [String](arrayLiteral: "PetCollectionPreviews/Baymax","PetCollectionPreviews/Butterfly","PetCollectionPreviews/Deer","PetCollectionPreviews/Fly","PetCollectionPreviews/JetPilot","removeModels")
    
    var bubbles = [String](arrayLiteral: "BubbleCollection/bubbleDrawnBubble","BubbleCollection/bubbleGreenBackground","BubbleCollection/thinkBubble","removeModels")
    
    var prevScaleFactor : CGFloat = 0
    
    
    private var scanTimer: Timer?
    private var scannedFaceViews = [UIView]()

    
    var hatNode = SCNNode()
    var bubbleNode = SCNNode()
    var petNode = SCNNode()
    let textNode = SCNNode()
    
    var mainScene = SCNScene()
    var modelScene : SCNScene?
    var petScene : SCNScene?
    
    var planePosition : SCNVector3?
    var planes = [UUID: VirtualPlane]()
    var plane : VirtualPlane?
    @IBOutlet var viewModeARSCN: ARSCNView!
    
    var santaHat = SCNNode()
    
    let wft : WorldFaceTracking = WorldFaceTracking()
    
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        viewModeARSCN.delegate = self
        // Do any additional setup after loading the view.
        
        addModel(path: "art.scnassets/Hats/SantaHat/hatSantaHat.scn")
        let image = UIImage(named: "BubbleCollection/thinkBubble")
        addBubble(image: image!, text: "Bananarama")
        addPet(path: "art.scnassets/Pets/Deer/petDeer.scn")
        viewModeARSCN.autoenablesDefaultLighting = true
        
    }
        struct myCameraCoordinates{
        var x = Float()
        var y = Float()
        var z = Float()
    }
    func getCameraCoordinates(SceneView: ARSCNView) -> myCameraCoordinates{
        let cameraTransform = viewModeARSCN.session.currentFrame?.camera.transform
        let cameraCoordinates = MDLTransform(matrix: cameraTransform!)
        //
        var cc = myCameraCoordinates()
        cc.x = cameraCoordinates.translation.x
        cc.y = cameraCoordinates.translation.y
        cc.z = cameraCoordinates.translation.z
        
        return cc
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        viewModeARSCN.session.run(configuration)
        
        wft.setARSCNView(SceneView: viewModeARSCN)
        scanTimer = Timer.scheduledTimer(timeInterval: 0.08, target: self, selector: #selector(self.scanForFaces), userInfo: nil, repeats: true)
        viewModeARSCN.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        scanTimer?.invalidate()
        // Pause the view's session
        viewModeARSCN.session.pause()
    }    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - ARSCNViewDelegate
    
    /*
     // Override to create and configure nodes for anchors added to the view's session.
     func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
     let node = SCNNode()
     
     return node
     }
     */
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    func doHitTest(faceRectPoint : CGPoint) -> SCNVector3{
        let hitTestResults = self.viewModeARSCN.hitTest(faceRectPoint, types: ARHitTestResult.ResultType.featurePoint)
        guard let hitTestResult = hitTestResults.first else { return SCNVector3(0,0,0)}
        let translation = SCNMatrix4(hitTestResult.worldTransform)
        let hitPosition = SCNVector3(translation.m41, translation.m42, translation.m43)
        return hitPosition
        
    }
    
    @objc
    private func scanForFaces() {
        
        //remove the test views and empty the array that was keeping a reference to them
        _ = scannedFaceViews.map { $0.removeFromSuperview() }
        scannedFaceViews.removeAll()
        
        //get the captured image of the ARSession's current frame
        guard let capturedImage = viewModeARSCN.session.currentFrame?.capturedImage else { return }
        
        let image = CIImage.init(cvPixelBuffer: capturedImage)
        
        
        let detectFaceRequest = VNDetectFaceRectanglesRequest { (request, error) in
            
            DispatchQueue.main.async {
                if(self.petNode.childNodes.isEmpty == false && self.plane != nil){
                    self.scalePet(plane: self.plane!)
                    self.movePet(plane: self.plane!)
                    self.petNode.isHidden = false
                    
                }
                //Loop through the resulting faces and add a red UIView on top of them.
                if let faces = request.results as? [VNFaceObservation] {
                    if (faces.isEmpty){
                        //NSLog(" NO FACE FOUND !")
                        self.hatNode.isHidden = true
                        self.bubbleNode.isHidden = true
                    }
                    else{
                        for face in faces {
                            
                            let faceRectFrame = self.faceFrame(from: face.boundingBox)
                            let faceView = UIView(frame: faceRectFrame)
                            //faceView.backgroundColor = .red
                            
                            var px = faceRectFrame.origin.x + faceRectFrame.width/2
                            let faceRectVector = self.doHitTest(faceRectPoint: CGPoint(x: faceRectFrame.origin.x, y: faceRectFrame.origin.y))
                            //NSLog("x: %f",faceRectVector.x)
                            //NSLog("y: %f",faceRectVector.y)
                            //NSLog("z: %f",faceRectVector.z)
                            
                            
                            //let scaleFactor =  CGFloat((self.hatNode.boundingBox.max.x/100))
                            if(faceRectVector.x != 0 && faceRectVector.y != 0 && faceRectVector.z != 0){
                                
                                if(self.hatNode.childNodes.isEmpty == false){
                                    let moveAction = SCNAction.move(to: SCNVector3(faceRectVector.x,faceRectVector.y,faceRectVector.z), duration: 0.07)
                                    self.hatNode.isHidden = false
                                    self.hatNode.runAction(moveAction)
                                    let hatWidth = CGFloat(self.hatNode.boundingBox.max.x)-CGFloat(self.hatNode.boundingBox.min.x)
                                    
                                    let scaleFactor = (faceRectFrame.width/hatWidth)*0.002
                                    
                                    NSLog("scaleFactor : %f", scaleFactor)
                                    NSLog("prevScaleFactor : %f", self.prevScaleFactor)
                                    
                                    let scaleAction = SCNAction.scale(to: scaleFactor, duration: 0.07)
                                    self.hatNode.runAction(scaleAction)
                                    
                                    self.prevScaleFactor = scaleFactor
                                }
                                if(self.bubbleNode.geometry != nil){
                                    let bubbleHeight = CGFloat(self.bubbleNode.boundingBox.max.y)-CGFloat(self.bubbleNode.boundingBox.min.y)
                                    let newY = faceRectVector.y + Float(bubbleHeight/3)
                                    
                                    let moveAction = SCNAction.move(to: SCNVector3(faceRectVector.x,newY,faceRectVector.z), duration: 0.07)
                                    self.bubbleNode.isHidden = false
                                    self.bubbleNode.runAction(moveAction)
                                    let bubbleWidth = CGFloat(self.bubbleNode.boundingBox.max.x)-CGFloat(self.bubbleNode.boundingBox.min.x)
                                    let textWidth = CGFloat(self.textNode.boundingBox.max.x)-CGFloat(self.textNode.boundingBox.min.x)
                                    let textScaleFactor = (bubbleWidth/textWidth)*0.2
                                    let bubbleScaleFactor = (faceRectFrame.width/bubbleWidth)*0.005
                                    NSLog("bubbleScaleFactor : %f", bubbleScaleFactor)
                                    NSLog("textScaleFactor : %f", textScaleFactor)
                                    
                                    let bubbleScaleAction = SCNAction.scale(to: bubbleScaleFactor, duration: 0.07)
                                    let textScaleAction = SCNAction.scale(to: textScaleFactor, duration: 0.07)
                                    self.bubbleNode.runAction(bubbleScaleAction)
                                    
                                    self.textNode.runAction(textScaleAction)
                                    let eulerAngles = self.viewModeARSCN.session.currentFrame?.camera.eulerAngles
                                    self.bubbleNode.eulerAngles = SCNVector3((eulerAngles?.x)!, (eulerAngles?.y)!, (eulerAngles?.z)! + .pi / 2)
                                }
                                //self.viewModeARSCN.scene = self.modelScene!
                                self.viewModeARSCN.scene = self.mainScene
                                self.viewModeARSCN.addSubview(faceView)
                                self.scannedFaceViews.append(faceView)
                            }
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
        let origin = CGPoint(x: boundingBox.minX * viewModeARSCN.bounds.width, y: (1 - boundingBox.maxY) * viewModeARSCN.bounds.height)
        let size = CGSize(width: boundingBox.width * viewModeARSCN.bounds.width, height: boundingBox.height * viewModeARSCN.bounds.height)
        
        return CGRect(origin: origin, size: size)
    }
    func removeAllModels(){
        petNode.removeFromParentNode()
        hatNode.removeFromParentNode()
        bubbleNode.removeFromParentNode()
    }
    func addModel(path : String) {
        if(hatNode.childNodes.isEmpty==false){
            hatNode.removeFromParentNode()
        }
        modelScene = SCNScene(named: path)!
        hatNode = (modelScene?.rootNode.childNode(withName: "ModelNode", recursively: true))!
        hatNode.isHidden = true
        mainScene.rootNode.addChildNode(hatNode)
        
    }
    func addPet(path : String) {
        if(petNode.childNodes.isEmpty==false){
            petNode.removeFromParentNode()
        }
        petScene = SCNScene(named: path)!
        petNode = (petScene?.rootNode.childNode(withName: "PetNode", recursively: true))!
        petNode.isHidden = true
        mainScene.rootNode.addChildNode(petNode)
        
    }
    func addBubble(image : UIImage, text : String){
        
        
        NSLog("text: %@", text)
        let scnText = SCNText(string: text, extrusionDepth: 0)
        
        // creates material object, sets color, assigns material to text
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.green
        scnText.materials = [material]
        
        // creates node, sets position, scales size of text, sets textgeometry to node
        
        
        if (bubbleNode.geometry != nil){
            bubbleNode.removeFromParentNode()
            textNode.removeFromParentNode()
        }
        bubbleNode = SCNNode(geometry: SCNPlane(width: 1, height: 1))
        bubbleNode.geometry?.firstMaterial?.diffuse.contents = image
        
        textNode.geometry = scnText
        textNode.name = "TextNode"
        
        bubbleNode.addChildNode(textNode)
        
        bubbleNode.isHidden = true
        
        // adds node to view, enable lighting to display shadows
        mainScene.rootNode.addChildNode(bubbleNode)
        
    }
    
    
}
extension WorldViewController {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        if let arPlaneAnchor = anchor as? ARPlaneAnchor {
            
            let myPlane = VirtualPlane(anchor: arPlaneAnchor)
            self.planes[anchor.identifier] = plane
            node.addChildNode(myPlane)
            self.plane = myPlane
            
            
            
        }
    }
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if let arPlaneAnchor = anchor as? ARPlaneAnchor, let plane = planes[arPlaneAnchor.identifier] {
            // Remove existing plane nodes
            node.enumerateChildNodes {
                (childNode, _) in
                childNode.removeFromParentNode()
            }
            //
            plane.updateWithNewAnchor(arPlaneAnchor)
            self.plane = plane
            
        }
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        if let arPlaneAnchor = anchor as? ARPlaneAnchor, let index = planes.index(forKey: arPlaneAnchor.identifier) {
            // Remove existing plane nodes
            node.enumerateChildNodes {
                (childNode, _) in
                childNode.removeFromParentNode()
            }
            planes.remove(at: index)
        }
    }
    func scalePet(plane: VirtualPlane){
        //let scaleFactor = (faceRectFrame.width/CGFloat(self.hatNode.boundingBox.max.x))*0.004
        let petWidth = CGFloat(self.petNode.boundingBox.max.x)-CGFloat(self.petNode.boundingBox.min.x)
        let planeWidth = CGFloat(plane.planeGeometry.boundingBox.max.x)-CGFloat(plane.planeGeometry.boundingBox.min.x)
        let scaleFactor = (petWidth/planeWidth)*0.005
        //NSLog("scaleFactor : %f", scaleFactor)
        
        let scaleAction = SCNAction.scale(to: scaleFactor, duration: 0.07)
        self.petNode.runAction(scaleAction)
        self.petNode.isHidden = false
    }
    func movePet(plane: VirtualPlane){
        //NSLog("worldPosX : %f, worldPosY : %f, worldPosZ : %f", plane.worldPosition.x, plane.worldPosition.y, plane.worldPosition.z)
        //let moveAction = SCNAction.move(to: SCNVector3((self.planePosition?.x)!,(self.planePosition?.y)!,(self.planePosition?.z)!), duration: 0.07)
        let moveAction = SCNAction.move(to: SCNVector3(CGFloat(plane.worldPosition.x),CGFloat(plane.worldPosition.y),CGFloat(plane.worldPosition.z)), duration: 0.07)
        self.petNode.runAction(moveAction)
        self.petNode.isHidden = false
    }
    
}
