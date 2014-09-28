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
    @IBOutlet var roomName: UILabel!
    @IBOutlet var peerList: PeerListController!
    
    var roomClient: JamSessionClient! {
        didSet {
            self.roomClient.delegate = self
        }
    }
    
    var soundGenerator:SoundGenerator?
    
    override func addChildViewController(childController: UIViewController) {
        super.addChildViewController(childController)
        
        if let peerListController = childController as? PeerListController {
            self.peerList = peerListController
        }
    }
    
    func peerListChanged(peers: [MCPeerID]) {
        self.peerList?.peerList = peers
    }
    
    func recievedMessage(peer: MCPeerID, message: String) {
        let idx         = advance(message.startIndex, 2)
        let startOrStop = (message.substringToIndex(idx))
        let tone        = (message.substringFromIndex(idx).toInt())
        switch startOrStop {
        case "1" : soundGenerator?.playNoteOn(UInt32(tone!), velocity: UInt32(100))
        case "0" : soundGenerator?.playNoteOff(UInt32(tone!))
        default  : println("message error")
        }
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
    
    @IBAction func playNoteOn(b:UIButton) {
        roomClient.sendNoteOn(b.tag)
    }
    
    @IBAction func playNoteOff(b:UIButton) {
        roomClient.sendNoteOff(b.tag)
    }

}


class PeerListController: UITableViewController {

    var peerList: [MCPeerID] = [] {
        didSet { self.tableView.reloadData() }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peerList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let peerCell = tableView.dequeueReusableCellWithIdentifier("PeerCell") as UITableViewCell
        
        peerCell.textLabel?.text = peerList[indexPath.row].displayName
        peerCell.detailTextLabel?.text = ""
        
        return peerCell
    }
    
}