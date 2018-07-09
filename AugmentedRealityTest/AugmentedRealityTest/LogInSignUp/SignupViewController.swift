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
import ARKit
import CoreData

class SignupViewController: UIViewController, UITextFieldDelegate {
    var appDelegate : AppDelegate?
    @IBOutlet weak var arscnView: ARSCNView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.arscnView?.delegate = self
        
        userNameTextField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        let text = SCNText(string: " You didn`t sign up for it yet ???", extrusionDepth: 2)
        
        // creates material object, sets color, assigns material to text
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.green
        text.materials = [material]
        
        // creates node, sets position, scales size of text, sets textgeometry to node
        let node = SCNNode()
        node.position = SCNVector3(x: -7.5, y:1, z: -15)
        node.scale = SCNVector3(x: 0.1, y: 0.1, z: 0.1)
        node.geometry = text
        
        // adds node to view, enable lighting to display shadows
        arscnView.scene.rootNode.addChildNode(node)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        // Run the view's session
        arscnView?.session.run(configuration)
        self.setARSCNView(SceneView: arscnView!)
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
                                    
                                    let dict = ["uid" : UUID().uuidString, "name" : self.userNameTextField.text!, "email" : self.emailField.text!, "password" : self.passwordField.text!, "profileUrl" : ""] as [String : Any]
                                    
                                    DataBaseHelper.shareInstance.saveUser(object: dict as! [String : String])
                                    
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
                    //self.signUpError()
                    }
                } else {
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
                        
    @IBAction func usernameTextFieldReturnTaped(_ sender: Any) {
        userNameTextField.resignFirstResponder()
    }
    
    @IBAction func emailTextFieldReturnTap(_ sender: Any) {
        emailField.resignFirstResponder()
    }
    
    @IBAction func passwordTextFieldReturnTap(_ sender: Any) {
        passwordField.resignFirstResponder()
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
extension SignupViewController : ARSCNViewDelegate{
    public func setARSCNView(SceneView : ARSCNView){
        self.arscnView = SceneView
    }
    
}
