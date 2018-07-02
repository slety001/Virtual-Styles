//
//  MenuViewController.swift
//  AugmentedRealityTest
//
//  Created by Anonymer Eintrag on 29.06.18.
//  Copyright © 2018 Anonymer Eintrag. All rights reserved.
//

import UIKit
import FirebaseAuth

class MenuViewController: UIViewController {

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
            catch {
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let cu = Auth.auth().currentUser?.displayName
        userNameLabel.text = cu
        
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
