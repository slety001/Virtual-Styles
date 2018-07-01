//
//  InitialLoginViewController.swift
//  AugmentedRealityTest
//
//  Created by Semen Letychevskyy on 01.07.18.
//  Copyright © 2018 Anonymer Eintrag. All rights reserved.
//

import UIKit
import FirebaseAuth

class InitialLoginViewController: UIViewController {

    fileprivate func checkState(){
        if (Auth.auth().currentUser != nil) {
            self.performSegue(withIdentifier: "go to menu", sender: self)
        }
        let authListener = Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                Profile.observeUserProfile(user!.uid) { userProfile in
                    Profile.currentUserProfile = userProfile
                }
                self.performSegue(withIdentifier: "go to menu", sender: self)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkState()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (Auth.auth().currentUser != nil) {
            self.performSegue(withIdentifier: "go to menu", sender: self)
        }
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
