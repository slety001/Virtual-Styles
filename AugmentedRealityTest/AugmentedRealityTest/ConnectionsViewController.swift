//
//  ConnectionsViewController.swift
//  AugmentedRealityTest
//
//  Created by MacBook on 04.07.18.
//  Copyright © 2018 Anonymer Eintrag. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ConnectionsViewController: UIViewController{

    @IBOutlet weak var findPeersButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var switchVisible: UISwitch!
    @IBOutlet weak var peersTableView: UITableView!
    @IBOutlet weak var disconnectButton: UIButton!
    
    
    var appDelegate : AppDelegate?
    var arrConnectedDevices : NSMutableArray?
    
    @IBAction func browseForDevices(_ sender: Any) {
        print("find peers")
        appDelegate?.mcManager?.setupMCBrowser()
        appDelegate?.mcManager?.browser?.delegate = self
        self.present((appDelegate?.mcManager?.browser)!, animated: true, completion: nil)
        
    }
    @IBAction func toggleVisibility(_ sender: Any) {
        appDelegate?.mcManager?.advertiseSelf(shouldAdvertise: switchVisible.isOn)
        
    }
    @IBAction func disconnect(_ sender: Any) {
        print("disconnect")
        appDelegate?.mcManager?.session?.disconnect()
        arrConnectedDevices?.removeAllObjects()
        peersTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        
    appDelegate?.mcManager?.setupPeerAndSessionWithDisplayName(displayName: UIDevice.current.name)
        appDelegate?.mcManager?.advertiseSelf(shouldAdvertise: switchVisible.isOn)
        
        appDelegate?.mcManager?.browser?.present(self, animated: true, completion: nil)
        
        arrConnectedDevices = NSMutableArray.init()
        peersTableView.delegate = self
        peersTableView.dataSource = self
        DispatchQueue.main.async {
            NotificationCenter.default.addObserver(self, selector: #selector(self.peerDidChangeStateWithNotification(notification:)), name: NSNotification.Name(rawValue: "MCDidChangeStateNotification"), object: nil)
        }
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
extension ConnectionsViewController : MCBrowserViewControllerDelegate {
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        print("done")
        appDelegate?.mcManager?.browser?.dismiss(animated: true)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        print("cancel")
        appDelegate?.mcManager?.browser?.dismiss(animated: true)
        
    }
    
}
extension ConnectionsViewController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        appDelegate?.mcManager?.peerID = nil
        appDelegate?.mcManager?.session = nil
        appDelegate?.mcManager?.browser = nil
        
        if(switchVisible.isOn){
            appDelegate?.mcManager?.advertiser?.stop()
        }
        
        appDelegate?.mcManager?.advertiser = nil
        
        appDelegate?.mcManager?.setupPeerAndSessionWithDisplayName(displayName: textField.text!)
        appDelegate?.mcManager?.setupMCBrowser()
        appDelegate?.mcManager?.advertiseSelf(shouldAdvertise: switchVisible.isOn)
        
        return true
    }
}
extension ConnectionsViewController : UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //
        return (arrConnectedDevices?.count)!
    }
    private func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> Float {
        //
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //
        var cell : UITableViewCell?
        if (cell == nil){
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "CellIdentifier")
        }
        cell?.textLabel?.text = arrConnectedDevices?.object(at: indexPath.row) as? String
        return cell!
    }
    @objc func peerDidChangeStateWithNotification(notification : NSNotification){
        let peerID : MCPeerID = notification.userInfo!["peerID"] as! MCPeerID
        //let peerID : MCPeerID = MCPeerID(displayName:  arrConnectedDevices?.value(forKey: "peerID") as! String)
        let peerDisplayName = peerID.displayName
        let state : MCSessionState = notification.userInfo!["state"] as! MCSessionState
        
        if (state != MCSessionState.connecting){
            if(state == MCSessionState.connected){
                arrConnectedDevices?.add(peerDisplayName)
            }
            else if(state == MCSessionState.notConnected){
                if((arrConnectedDevices?.count)! > 0){
                    let index : Int = arrConnectedDevices!.index(of: peerDisplayName)
                    arrConnectedDevices?.removeObject(at: index)
                }
            }
            peersTableView.reloadData()
            let peersExist : Bool = appDelegate?.mcManager?.session?.connectedPeers.count == 0
            disconnectButton.isEnabled = peersExist
            nameTextField.isEnabled = peersExist
        }
        
    }
    
}

