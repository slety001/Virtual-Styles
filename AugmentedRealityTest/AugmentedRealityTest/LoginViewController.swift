//
//  LoginViewController.swift
//  AugmentedRealityTest
//
//  Created by Semen Letychevskyy on 18.06.18.
//  Copyright © 2018 Anonymer Eintrag. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    //if Auth.auth().currentUser != nil {
    //self.performSegue(withIdentifier: "logIn", sender:nil)
    //}
    
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var emailForRegistration: UITextField!
    @IBOutlet weak var passwordForRegistration: UITextField!
    
    @IBAction func registrateUser(_ sender: UIButton) {
        if emailForRegistration.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else {
            
            Auth.auth().createUser(withEmail: emailForRegistration.text!, password: passwordForRegistration.text!) { (user, error) in
                if error == nil {
                    DispatchQueue.main.async{
                        //let currentUser = Auth.auth().currentUser
                        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                        changeRequest?.displayName = self.userName.text
                        changeRequest?.commitChanges(completion: { (error) in
                            if let error = error {
                                print(error.localizedDescription)
                            }
                        })
                        print("You have successfully register and signed up")
                    }
                    self.performSegue(withIdentifier: "registerUser", sender:sender)
                    
                } else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBOutlet weak var emailSignIn: UITextField!
    @IBOutlet weak var passwordSignIn: UITextField!

    @IBAction func signInUser(_ sender: UIButton) {
        if emailSignIn.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
            
        } else {
            Auth.auth().signIn(withEmail: emailSignIn.text!, password: passwordSignIn.text!) { (user, error) in
                if error == nil {
                    DispatchQueue.main.async{
                        print("You have successfully signed up")
                    }
                        self.performSegue(withIdentifier: "signIn", sender:sender)
                    
                } else {
                    print("3")
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
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
