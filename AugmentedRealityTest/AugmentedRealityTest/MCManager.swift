//
//  MCManager.swift
//  AugmentedRealityTest
//
//  Created by MacBook on 04.07.18.
//  Copyright © 2018 Anonymer Eintrag. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class MCManager: NSObject, MCSessionDelegate{
    var peerID : MCPeerID?
    var session : MCSession?
    var browser : MCBrowserViewController?
    var advertiser : MCAdvertiserAssistant?
    override init() {
        super.init()
        peerID = nil
        session = nil
        browser = nil
        advertiser = nil
  
    }
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        print("diedChangeState")
        let dict : NSDictionary = ["peerID": peerID,
            "state" : state]
            
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MCDidChangeStateNotification"), object: nil, userInfo: dict as? [AnyHashable : Any])
        
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        print("diedReceiveData")
        let dict : NSDictionary = ["peerID" : peerID, "data": data]
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MCReceiveDataNotification"), object: nil, userInfo: dict as? [AnyHashable : Any])
        
        
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        print("diedReceiveStream")
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        print("didStartReceivingResourceWithName")
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        print("didFinishReceivingResourceWithName")
    }
    func setupPeerAndSessionWithDisplayName(displayName : String){
        print("setupPeerAndSessionWithDisplayName")
        peerID = MCPeerID.init(displayName: displayName)
        session = MCSession.init(peer: peerID!)
        session?.delegate = self
    }
    func setupMCBrowser(){
        print("setupBrowser")
        browser = MCBrowserViewController.init(serviceType: "chat-files", session: self.session!)
    }
    func advertiseSelf(shouldAdvertise: Bool){
        print("advertise - shouldAdvertise : " , shouldAdvertise)
        if(shouldAdvertise){
            advertiser = MCAdvertiserAssistant.init(serviceType: "chat-files", discoveryInfo: nil, session: self.session!)
            advertiser?.start()
            
        }else{
            advertiser?.stop()
            advertiser = nil
        }
    }

}
