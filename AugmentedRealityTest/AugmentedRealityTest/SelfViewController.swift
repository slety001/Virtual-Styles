//
//  ViewController.swift
//  AugmentedRealityTest
//
//  Created by Anonymer Eintrag on 30.05.18.
//  Copyright © 2018 Anonymer Eintrag. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import Vision
import SpriteKit

class SelfViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, ARSCNViewDelegate {
    
    var fileManager : FileManager!
    
    var hats = [String](arrayLiteral: "art.scnassets/Hats/Cap/hatCap.scn","art.scnassets/Hats/CaptainHat/hatCaptainHat.scn","art.scnassets/Hats/CowboyHat/hatCowboyHat.scn", "art.scnassets/Hats/SantaHat/hatSantaHat.scn")
    var pets = [String](arrayLiteral: "art.scnassets/Pets/Baymax/petBaymax.scn","art.scnassets/Pets/Butterfly/petButterfly.scn","art.scnassets/Pets/Deer/petDeer.scn","art.scnassets/Pets/Fly/petFly.scn","art.scnassets/Pets/Ship/petJetPilot.scn")
    
    
    var hatPreviews = [String](arrayLiteral: "HatCollectionPreviews/Cap","HatCollectionPreviews/CaptainHat","HatCollectionPreviews/CowboyHat","HatCollectionPreviews/SantaHat")
    var petPreviews = [String](arrayLiteral: "PetCollectionPreviews/Baymax","PetCollectionPreviews/Butterfly","PetCollectionPreviews/Deer","PetCollectionPreviews/Fly","PetCollectionPreviews/JetPilot")
    
    var bubbles = [String](arrayLiteral: "BubbleCollection/bubbleDrawnBubble","BubbleCollection/bubbleGreenBackground","BubbleCollection/thinkBubble")
    
    @IBOutlet weak var viewModeARSCN: ARSCNView!

    @IBOutlet weak var collectionView: UICollectionView!
    
    private var scanTimer: Timer?
    private var scannedFaceViews = [UIView]()
    @IBAction func pickBubblesButtonAction(_ sender: Any) {
        print("pickBubbles tapped")
        pickBubblesButton.isSelected = true
        pickPetsButton.isSelected = false
        pickHatsButton.isSelected = false
        collectionView.reloadData()
        
    }
    @IBAction func pickPetButtonAction(_ sender: Any) {
        print("pickPets tapped")
        pickBubblesButton.isSelected = false
        pickPetsButton.isSelected = true
        pickHatsButton.isSelected = false
        collectionView.reloadData()
    }
    @IBAction func pickHatButtonAction(_ sender: Any) {
        print("pickHats tapped")
        pickBubblesButton.isSelected = false
        pickPetsButton.isSelected = false
        pickHatsButton.isSelected = true
        collectionView.reloadData()
    }
    @IBOutlet weak var pickBubblesButton: UIButton!
    @IBOutlet weak var pickPetsButton: UIButton!
    @IBOutlet weak var pickHatsButton: UIButton!
    
    let wft : WorldFaceTracking = WorldFaceTracking()
    
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(pickHatsButton.isSelected){
            return hatPreviews.count
        }
        else if(pickPetsButton.isSelected){
            return petPreviews.count
        }
        else if(pickBubblesButton.isSelected){
            return bubbles.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell
        cell.layer.cornerRadius = 50
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 3
        
        if(pickHatsButton.isSelected){
            cell.myImage.image = UIImage(named: hatPreviews[indexPath.row])
            cell.modelSourcePath = hats[indexPath.row]
        }
        else if(pickPetsButton.isSelected){
            cell.myImage.image = UIImage(named: petPreviews[indexPath.row])
            cell.modelSourcePath = pets[indexPath.row]
        }
        else if(pickBubblesButton.isSelected){
            cell.myImage.image = UIImage(named: bubbles[indexPath.row])
            cell.modelSourcePath = bubbles[indexPath.row]
        }
        cell.selfView = self
        return cell
    }
    
    
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
        fileManager = FileManager.default
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        // Set the view's delegate
        viewModeARSCN.delegate = self
        self.viewModeARSCN.scene = mainScene
        
        viewModeARSCN.autoenablesDefaultLighting = true
        
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        guard ARFaceTrackingConfiguration.isSupported else {
            let alert = UIAlertController(title: "You're Using IPhone 7 or lower", message: "For FaceCamera-AR-Experience you need IPhone 8 or higher! Use a Mirror to do your Settings using the FrontCamera!", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            
            self.present(alert, animated: true)
            let configuration = ARWorldTrackingConfiguration()
            configuration.planeDetection = [.horizontal]
            viewModeARSCN.session.run(configuration)
            
            
            scanTimer = Timer.scheduledTimer(timeInterval: 0.08, target: self, selector: #selector(scanForFaces), userInfo: nil, repeats: true)

            return }
        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = true

        viewModeARSCN.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        
        // Run the view's session
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        scanTimer?.invalidate()
        // Pause the view's session
        viewModeARSCN.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate
    

    // Override to create and configure nodes for anchors added to the view's session.


    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
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
                            faceView.backgroundColor = .red
                            
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
                                    let scaleAction = SCNAction.scale(to: scaleFactor, duration: 0.07)
                                    self.hatNode.runAction(scaleAction)
                                }
                                if(self.bubbleNode.geometry != nil){
                                    let bubbleHeight = CGFloat(self.bubbleNode.boundingBox.max.y)-CGFloat(self.bubbleNode.boundingBox.min.y)
                                    let newY = faceRectVector.y + Float(bubbleHeight/2)
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
}
extension SelfViewController {
    
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
