//
//  ConnectionsViewController.swift
//  AugmentedRealityTest
//
//  Created by MacBook on 04.07.18.
//  Copyright © 2018 Anonymer Eintrag. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ConnectionsViewController: UIViewController, MCBrowserViewControllerDelegate {
    var appDelegate : AppDelegate?
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        print("")
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        print("")
    }
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var switchVisible: UISwitch!
    @IBOutlet weak var peersTableView: UITableView!
    @IBOutlet weak var disconnectButton: UIButton!
    @IBAction func browseForDevices(_ sender: Any) {
        appDelegate?.mcManager?.setupMCBrowser()
        appDelegate?.mcManager?.browser?.delegate = self
        
    }
    @IBAction func toggleVisibility(_ sender: Any) {
        if(switchVisible.isOn){
            switchVisible.setOn(false, animated: true)
        }else{
            switchVisible.setOn(true, animated: true)
        }
    }
    @IBAction func disconnect(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.mcManager?.setupPeerAndSessionWithDisplayName(displayName: UIDevice.current.name)
        appDelegate?.mcManager?.advertiseSelf(shouldAdvertise: switchVisible.isOn)
        appDelegate?.mcManager?.browser?.present(self, animated: true, completion: nil)
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
