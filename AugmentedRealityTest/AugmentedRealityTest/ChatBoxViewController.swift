//
//  ChatBoxViewController.swift
//  AugmentedRealityTest
//
//  Created by MacBook on 04.07.18.
//  Copyright © 2018 Anonymer Eintrag. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ChatBoxViewController: UIViewController {
    let error = NSError()
    var allPeers : Array<MCPeerID>?
    let connectionView = ConnectionsViewController()
    @IBOutlet weak var cancelButton: UIButton!
    @IBAction func cancelButtonAction(_ sender: Any) {
        textInputField.resignFirstResponder()
    }
    @IBOutlet weak var sendButton: UIButton!
    @IBAction func sendButtonAction(_ sender: Any){
        if (allPeers?.isEmpty == false){
        do {
            try sendMyMessage()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        }else{
            let alert = UIAlertController(title: "No peers connected :/ ", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        textInputField.resignFirstResponder()
    }
    @IBOutlet weak var textInputField: UITextField!
    @IBOutlet weak var chatTextView: UITextView!
    
    var appDelegate : AppDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        textInputField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(self.didReceiveDataWithNotification(notification:)), name: NSNotification.Name(rawValue: "MCDidReceiveDataNotification"), object: nil)
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
    func sendMyMessage() throws {
        let dataToSend : Data = (textInputField.text?.data(using: String.Encoding.utf8))!
        allPeers = appDelegate.mcManager?.session?.connectedPeers
        
       
        try appDelegate.mcManager?.session?.send(dataToSend, toPeers: allPeers! , with: MCSessionSendDataMode.reliable)
        let ht = "I wrote: \n\n"+textInputField.text!
        chatTextView.text.append(ht)
        textInputField.text = ""
        textInputField.resignFirstResponder()
        
    }
    @objc func didReceiveDataWithNotification(notification : NSNotification){
        let peerID : MCPeerID = notification.userInfo!["peerID"] as! MCPeerID
        let peerDisplayName = peerID.displayName
        let receivedData : NSData = notification.userInfo!["data"] as! NSData
        let receivedText : NSString = NSString.init(data: receivedData as Data, encoding: String.Encoding.utf8.rawValue)!
        
        let ht = peerDisplayName + " wrote:\n\n" + (receivedText as String)
        chatTextView.performSelector(onMainThread: #selector(chatTextView.text(in:)), with: chatTextView.text.append(ht), waitUntilDone: false)
        
        
    }

}
extension ChatBoxViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (allPeers?.isEmpty == false){
            do {
                try sendMyMessage()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }else{
            let alert = UIAlertController(title: "No peers connected :/ ", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        textInputField.resignFirstResponder()
        return true
    }
    
}
