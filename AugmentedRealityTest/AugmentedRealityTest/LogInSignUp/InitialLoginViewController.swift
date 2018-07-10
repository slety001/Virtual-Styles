//
//  InitialLoginViewController.swift
//  AugmentedRealityTest
//
//  Created by Semen Letychevskyy on 01.07.18.
//  Copyright © 2018 Anonymer Eintrag. All rights reserved.
//

import UIKit
import ARKit
import FirebaseAuth

class InitialLoginViewController: UIViewController{
    var appDelegate : AppDelegate?
    
    @IBAction func testThis(_ sender: UIButton) {
        DataBaseHelper.shareInstance.fetchUser()
        print(DataBaseHelper.shareInstance.getName())
        //DataBaseHelper.shareInstance.fetchBubble()
        //DataBaseHelper.shareInstance.fetchHat()
        //DataBaseHelper.shareInstance.fetchPet()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.arscnView.delegate = self
        let text = SCNText(string: " Login `u must ...!", extrusionDepth: 2)
        
        // creates material object, sets color, assigns material to text
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.green
        text.materials = [material]
        
        // creates node, sets position, scales size of text, sets textgeometry to node
        let node = SCNNode()
        node.position = SCNVector3(x: 2, y:2, z: -7)
        node.scale = SCNVector3(x: 0.1, y: 0.1, z: 0.1)
        node.geometry = text
        
        // adds node to view, enable lighting to display shadows
        arscnView.scene.rootNode.addChildNode(node)
        
        // Do any additional setup after loading the view.
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
extension InitialLoginViewController : ARSCNViewDelegate{
    public func setARSCNView(SceneView : ARSCNView){
        self.arscnView = SceneView
    }
    
}
