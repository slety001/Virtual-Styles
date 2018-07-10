//
//  MenuViewController.swift
//  AugmentedRealityTest
//
//  Created by Anonymer Eintrag on 29.06.18.
//  Copyright © 2018 Anonymer Eintrag. All rights reserved.
//

import UIKit
import ARKit
import FirebaseAuth
import CoreData

class MenuViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var arscnView: ARSCNView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBAction func signOutUser(_ sender: UIButton) {
        if Auth.auth().currentUser != nil {
            do {
                
                try Auth.auth().signOut()
                print("user signed out")
                let storyboard = UIStoryboard(name: "Login", bundle: .main)
                let initialViewController = storyboard.instantiateInitialViewController()
                self.present(initialViewController!, animated: true, completion: nil)
            }
            catch let error{
                print("Sign out error \(error.localizedDescription)")
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        let configuration = ARWorldTrackingConfiguration()
        // Run the view's session
        arscnView?.session.run(configuration)
        self.setARSCNView(SceneView: arscnView!)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.arscnView?.delegate = self
        // Create a session configuration
        imageView.layer.cornerRadius = 30
        DataBaseHelper.shareInstance.fetchUser()
        
        print(DataBaseHelper.shareInstance.getName())
        
        
        let activityIndicator = UIActivityIndicatorView()
        view.addSubview(activityIndicator)
        activityIndicator.frame = self.view.bounds
        activityIndicator.startAnimating()
        
        let cu = Auth.auth().currentUser?.displayName
        if cu != nil {
            userNameLabel.text = cu
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        } else {
            
            let delay = 1.0
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
            }
        }
        // creates text with depth
        let text = SCNText(string: " WELCOME TO VirtualStylesAR !", extrusionDepth: 2)
        
        // creates material object, sets color, assigns material to text
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.green
        text.materials = [material]
        
        // creates node, sets position, scales size of text, sets textgeometry to node
        let node = SCNNode()
        node.position = SCNVector3(x: -7.5, y:1, z: -10)
        node.scale = SCNVector3(x: 0.1, y: 0.1, z: 0.1)
        node.geometry = text
        
        // adds node to view, enable lighting to display shadows
        arscnView.scene.rootNode.addChildNode(node)
 
    }
    
    @IBOutlet weak var uploadButton: UIButton!
    @IBAction func uploadButTest(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            //imageView.contentMode = .scaleToFill
            imageView.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension MenuViewController : ARSCNViewDelegate{
    public func setARSCNView(SceneView : ARSCNView){
        self.arscnView = SceneView
    }
}


