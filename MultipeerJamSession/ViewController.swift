//
//  ViewController.swift
//  MultipeerJamSession
//
//  Created by Chris Williams on 9/27/14.
//  Copyright (c) 2014 SwiftHack. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ViewController: UIViewController, UITextFieldDelegate, MCBrowserViewControllerDelegate {

    @IBOutlet var label: UITextView?
    
    var server: JamSessionServer?
    var client: JamSessionClient?
    var clientName: String?
    var browserController: MCBrowserViewController?
    
    func gotNewPeers(peers: [MCPeerID]) {
        
        let peerNames = peers.map { $0.displayName }
        
        self.label?.text = "New Peer List: \(peerNames.description) \n\n \(self.label?.text)"
        
    }
    
    @IBOutlet weak var name: UITextField!

    func gotNewData(peer: MCPeerID, data:NSData) {
       self.label?.text = "New Data: \(data.description)"
        
    }
    
    func browserViewController(browserViewController: MCBrowserViewController!, shouldPresentNearbyPeer peerID: MCPeerID!, withDiscoveryInfo info: [NSObject : AnyObject]!) -> Bool {
        return true
    }
    
    func browserViewControllerDidFinish(browserViewController: MCBrowserViewController!) {
        // code
    }
    
    func browserViewControllerWasCancelled(browserViewController: MCBrowserViewController!) {
        // code
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        clientName = textField.text
    }
    
    @IBAction func startServer(UIButton) {
        
        if clientName == nil {
            clientName = UIDevice.currentDevice().name
        }
        
        var peer = MCPeerID(displayName: "\(clientName) Server")
        
        let session = MCSession(peer: peer)
        client = JamSessionClient(session: session,
            peerListChanged: gotNewPeers,
            recievedData: gotNewData)

        server = JamSessionServer(localClient: client!)
        
    }
    
    @IBAction func startClient(UIButton) {
        
        var peer = MCPeerID(displayName: "\(clientName) Client")
        
        let browser = MCNearbyServiceBrowser(peer: peer, serviceType: JamSessionServiceType)
        
        let session = MCSession(peer: peer)
        client = JamSessionClient(session: session,
            peerListChanged: gotNewPeers,
            recievedData: gotNewData)
        
        self.browserController = MCBrowserViewController(browser: browser, session: session)
        self.browserController?.delegate = self
        self.presentViewController(self.browserController!, animated: true, completion: {
            
            browser.startBrowsingForPeers()
        })
        
        
    }


}

