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
    
    @IBOutlet weak var arscnView: ARSCNView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        // Run the view's session
        arscnView?.session.run(configuration)
        self.setARSCNView(SceneView: arscnView!)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.arscnView.delegate = self
        
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
