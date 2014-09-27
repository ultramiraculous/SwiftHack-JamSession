//  ConnectionManger.swift
//  MultipeerJamSession


import Foundation
import MultipeerConnectivity

//The name of the app's "service"
let JamSessionServiceType = "JamSession-srvc"

//The peer name for our local device
let JamSessionPeer = MCPeerID(displayName: UIDevice.currentDevice().name)


class JamSessionServer : NSObject,
                         MCNearbyServiceAdvertiserDelegate,
                         MCSessionDelegate

{
    let serverName: String
    let advertiser: MCNearbyServiceAdvertiser
    let session: MCSession
    
    init(serverName: String){
        self.serverName = serverName
        
        self.advertiser = MCNearbyServiceAdvertiser(peer: JamSessionPeer,
            discoveryInfo: nil,
            serviceType: JamSessionServiceType)
        
        self.session = MCSession(peer: JamSessionPeer)
        
    }
    
    func advertiser(advertiser: MCNearbyServiceAdvertiser!,
                    didReceiveInvitationFromPeer peerID: MCPeerID!,
                    withContext context: NSData!,
                    invitationHandler: ((Bool, MCSession!) -> Void)!)
    {
        
    
        let alert = UIAlertController(title: "Add Musician",
                          message: "\(peerID.displayName)\nWould like to join your session.",
                          preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Accept",
                                style: .Default,
                                handler: { (action) -> Void in
                                    
                                    invitationHandler(true, self.session)
                                    
                                }))
        alert.addAction(UIAlertAction(title: "Deny",
                style: .Destructive,
                handler: { (action) -> Void in
                    
                    invitationHandler(false, self.session)
                    
            }))
        
        
    }
    
    // Remote peer changed state
    func session(session: MCSession!, peer peerID: MCPeerID!, didChangeState state: MCSessionState) {
        
    }
    
    // Received data from remote peer
    func session(session: MCSession!, didReceiveData data: NSData!, fromPeer peerID: MCPeerID!) {
        
    }
    
    // Received a byte stream from remote peer
    func session(session: MCSession!, didReceiveStream stream: NSInputStream!, withName streamName: String!, fromPeer peerID: MCPeerID!) {
        
    }
    
    // Start receiving a resource from remote peer
    func session(session: MCSession!, didStartReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, withProgress progress: NSProgress!) {
        
    }
    
    // Finished receiving a resource from remote peer and saved the content in a temporary location - the app is responsible for moving the file to a permanent location within its sandbox
    func session(session: MCSession!, didFinishReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, atURL localURL: NSURL!, withError error: NSError!) {
        
    }
    
}

