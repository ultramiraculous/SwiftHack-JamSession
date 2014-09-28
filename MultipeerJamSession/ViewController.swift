//
//  ViewController.swift
//  MultipeerJamSession
//
//  Created by Chris Williams on 9/27/14.
//  Copyright (c) 2014 SwiftHack. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ViewController: UITableViewController, MCBrowserViewControllerDelegate {
    
    @IBOutlet weak var name: UITextField!
    
    var clientName: String {
        get {
            return self.name?.text ?? UIDevice.currentDevice().name
        }
    }
    var browserController: MCBrowserViewController?
    
    func gotNewPeers(peers: [MCPeerID]) {
        
        let peerNames = peers.map { $0.displayName }
        
    }

    
    func gotNewData(peer: MCPeerID, data:NSData) {
       self.name?.text = "New Data: \(data.description)"
    }
    
    func browserViewController(browserViewController: MCBrowserViewController!, shouldPresentNearbyPeer peerID: MCPeerID!, withDiscoveryInfo info: [NSObject : AnyObject]!) -> Bool {
        return true
    }
    

    @IBAction func startServer(UIButton) {
        
        var peer = MCPeerID(displayName: "\(clientName) Server")
        let session = MCSession(peer: peer)
        
        self.performSegueWithIdentifier("ToRoom", sender: JamSessionServer(session: session))
        
    }
    
    @IBAction func startClient(UIButton) {
        
        var peer = MCPeerID(displayName: "\(clientName) Client")
        
        let browser = MCNearbyServiceBrowser(peer: peer, serviceType: JamSessionServiceType)
        
        let session = MCSession(peer: peer)
        
        self.browserController = MCBrowserViewController(browser: browser, session: session)
        self.browserController?.delegate = self
        self.presentViewController(self.browserController!, animated: true, completion: {
            
            browser.startBrowsingForPeers()
        })
    }
    
    func browserViewControllerDidFinish(browserViewController: MCBrowserViewController!) {
        self.dismissViewControllerAnimated(false, completion: { () -> Void in
            self.performSegueWithIdentifier("ToRoom", sender: JamSessionClient(session: browserViewController.session))
        })
    }
    
    func browserViewControllerWasCancelled(browserViewController: MCBrowserViewController!) {
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let roomController = segue.destinationViewController as? RoomViewController {
            
            roomController.roomClient = sender as JamSessionClient
            
        }
    }

}

