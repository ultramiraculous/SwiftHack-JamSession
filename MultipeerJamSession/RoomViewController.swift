//
//  RoomViewController.swift
//  MultipeerJamSession
//
//  Created by Chris Williams on 9/27/14.
//  Copyright (c) 2014 SwiftHack. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class RoomViewController: UIViewController, JamSessionClientDelegate {
    @IBOutlet var roomName: UILabel?
    @IBOutlet var peerList: UITableView?
    
    var roomClient: JamSessionClient! {
        didSet { self.roomClient.delegate = self }
    }
    
    
    func peerListChanged(session: MCSession, peers: [MCPeerID]) {
        
    }
    
    func recievedMessage(session: MCSession, message: JamSessionMessage) {
        
    }
    
    func recivedInvitationRequest(session: MCSession, peer: MCPeerID, accept: (Void)->(Void), reject: (Void)->(Void)) {
        let alert = UIAlertController(title: "Add Musician",
            message: "\(peer.displayName)\nWould like to join your session.",
            preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Accept",
            style: .Default,
            handler: { (action) -> Void in
                
            accept()
                
        }))
        alert.addAction(UIAlertAction(title: "Deny",
            style: .Destructive,
            handler: { (action) -> Void in
                
                reject()
                
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
}

class PeerListController: UITableViewController {

    
    
}