//
//  takeAPhotoViewController.swift
//  AugmentedRealityTest
//
//  Created by Anonymer Eintrag on 02.07.18.
//  Copyright © 2018 Anonymer Eintrag. All rights reserved.
//

import Foundation
import UIKit
import SceneKit
import ARKit
import Vision

class takeAPhotoViewController : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var hm: ARSCNView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func takePhoto(_ sender: UIButton) {
        let snapShot = self.hm.snapshot()
        UIImageWriteToSavedPhotosAlbum(snapShot, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print("Error Saving ARKit Scene \(error)")
        } else {
            print("ARKit Scene Successfully Saved")
        }
    }
}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


