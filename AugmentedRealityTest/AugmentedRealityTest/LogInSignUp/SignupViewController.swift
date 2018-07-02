//
//  SignupViewController.swift
//  AugmentedRealityTest
//
//  Created by Semen Letychevskyy on 01.07.18.
//  Copyright © 2018 Anonymer Eintrag. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class SignupViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userNameTextField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
    }

    @IBAction func signUpPush(_ sender: UIButton) {
        guard let username = userNameTextField.text else {return}
        if (userNameTextField != nil && userNameTextField.text != "" && emailField != nil && emailField.text != "" && passwordField != nil && passwordField.text != ""){
            Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { user, error in
                if error == nil && user != nil {
                    print("User created!")
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.displayName = self.userNameTextField.text
                    changeRequest?.commitChanges { error in
                        if error == nil {
                            print("User display name changed")
                            self.saveUserToDatabase(username : username){ success in
                                if success {
                                    self.dismiss(animated: true, completion: nil)
                                } else {
                                    print("faild")
                                    self.signUpError()
                                }
                            }
                        } else {
                            print("1")
                            print("Error: \(error!.localizedDescription)")
                        }
                    print("2")
                    //self.signUpError()
                    }
                } else {
                    print("3")
                    //self.signUpError()
                }
            } 
        } else {
            textFieldNotFilled()
        }
    }
    
    func saveUserToDatabase(username: String, completion: @escaping ((_ success:Bool)->())){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let databaseRef = Database.database().reference().child("users/profile/\(uid)")
        
        let userObject = [
            "username": username
            ] as [String:Any]
        
        databaseRef.setValue(userObject) { error, ref in
            completion(error == nil)
        }
    }
    
    func textFieldNotFilled(){
        let alert = UIAlertController(title: "Textfield not filled!", message: "Please, properly fill all the textfields", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func signUpError(){
        let alert = UIAlertController(title: "Error signing up", message: "Please try again later", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
