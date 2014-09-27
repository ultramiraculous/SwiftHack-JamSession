//
//  ViewController.swift
//  MultipeerJamSession
//
//  Created by Chris Williams on 9/27/14.
//  Copyright (c) 2014 SwiftHack. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ViewController: UIViewController {

    @IBOutlet var label: UITextView?
    
    var server: JamSessionServer?
    var client: JamSessionClient?
    var browserController: MCBrowserViewController?
    
    
    func gotNewPeers(peers: [MCPeerID]) {
        
        let peerNames = peers.map { $0.displayName }
        
        self.label?.text = "New Peer List: \(peerNames.description) \n \(self.label?.text)"
        
    }
    
    func gotNewData(data: NSData) {
        
       self.label?.text = "New Data: \(data.description)"
        
    }
    
    @IBAction func startServer(UIButton) {
        
        let session = MCSession(peer: JamSessionPeer)
        client = JamSessionClient(session: session,
            peerListChanged: gotNewPeers,
            recievedData: gotNewData)
        
        server = JamSessionServer(serverName: "My Server", localClient: client!)
        
        
//        MCAdvertiserAssistant(serviceType: JamSessionServiceType,
//            discoveryInfo: nil,
//            session: self.server!.session).start();
        
    }
    
    @IBAction func startClient(UIButton) {
        
        let browser = MCNearbyServiceBrowser(peer: JamSessionPeer, serviceType: JamSessionServiceType)
        
        let session = MCSession(peer: JamSessionPeer)
        client = JamSessionClient(session: session,
            peerListChanged: gotNewPeers,
            recievedData: gotNewData)
        
        self.browserController = MCBrowserViewController(browser: browser, session: session)
        
        self.presentViewController(self.browserController!, animated: true, completion: {
            
            browser.startBrowsingForPeers()
        })
        
    }


}

