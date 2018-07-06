//
//  FileSharingViewController.swift
//  AugmentedRealityTest
//
//  Created by MacBook on 04.07.18.
//  Copyright © 2018 Anonymer Eintrag. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class FileSharingViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    var allPeers : [MCPeerID]?
    var appDelegate : AppDelegate?
    var imagePicker : UIImagePickerController?
    

    @IBAction func send(_ sender: Any) {
        print(imageView.image.debugDescription)
        if(allPeers?.isEmpty)!{
            let alert = UIAlertController(title: "Youre not connected to another peer yet :/ ", message: "Connect to Peer and Pick an Image before tryin to send!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }else{
            if(imageView.image==nil){
                let alert = UIAlertController(title: "No image picked yet :/ ", message: "Pick an Image      before tryin to send!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
            }else{
                do{
                    try sendImage()
                }catch{
                    
                }
            }
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        imageView.image = nil
    }
    @IBAction func uploadButTest(_ sender: UIButton) {
        imagePicker?.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(imagePicker!, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        allPeers = appDelegate?.mcManager?.session?.connectedPeers
        imagePicker = UIImagePickerController()
        imagePicker?.delegate = self
        imagePicker?.allowsEditing = true
        imagePicker?.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(imagePicker!, animated: true, completion: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.didReceiveDataWithNotification(notification:)), name: NSNotification.Name(rawValue: "MCDidReceiveDataNotification"), object: nil)
        // Do any additional setup after loading the view.
    }
    func sendImage()throws{
        let image : UIImage = imageView.image!
        let imageData : Data = UIImagePNGRepresentation(image)!
        
        try appDelegate?.mcManager?.session?.send(imageData , toPeers: allPeers!, with: MCSessionSendDataMode.reliable)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func didReceiveDataWithNotification(notification : NSNotification){
        let peerID : MCPeerID = notification.userInfo!["peerID"] as! MCPeerID
        let receivedData : NSData = notification.userInfo!["data"] as! NSData
        let receivedImage : UIImage = UIImage.init(data: receivedData as Data, scale: UIScreen.main.scale)!
        
        
        UIImageWriteToSavedPhotosAlbum(receivedImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        
        
    }
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print("Error Saving ARKit Scene \(error)")
        } else {
            print("ARKit Scene Successfully Saved")
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

}
extension FileSharingViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    
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
}
