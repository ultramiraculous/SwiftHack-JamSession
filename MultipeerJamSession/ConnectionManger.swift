//  ConnectionManger.swift
//  MultipeerJamSession


import Foundation
import MultipeerConnectivity

//The name of the app's "service"
let JamSessionServiceType = "JamSession-srvc"

//The peer name for our local device

//let JamSessionPeer = MCPeerID(displayName: "\(UIDevice.currentDevice().name)")


class JamSessionServer : NSObject,
                         MCNearbyServiceAdvertiserDelegate

{
    let serverName: String
    let advertiser: MCNearbyServiceAdvertiser
    let localClient: JamSessionClient
    var session: MCSession {
        get { return self.localClient.session }
    }
    
    init(localClient: JamSessionClient){
        

        self.serverName = localClient.session.myPeerID.displayName
        self.advertiser = MCNearbyServiceAdvertiser(peer:localClient.session.myPeerID ,
            discoveryInfo: nil,
            serviceType: JamSessionServiceType)
                
        self.localClient = localClient
        
        
        super.init()
        
        self.advertiser.delegate = self
        self.advertiser.startAdvertisingPeer()
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
        
        
        invitationHandler(true, self.session)
        
    }
        
}



class JamSessionClient: NSObject, MCSessionDelegate {
    let session: MCSession
    let peerListChanged: ([MCPeerID]) -> (Void)
    let recievedData: (MCPeerID, NSData) -> (Void)
    
    init(session: MCSession, peerListChanged: ([MCPeerID]) -> (Void), recievedData: (peer: MCPeerID, sentData: NSData) -> (Void)){
        self.session = session
        self.peerListChanged = peerListChanged
        self.recievedData = recievedData
        
        super.init()
        
        session.delegate = self
    }
    
    
    // Remote peer changed state
    func session(session: MCSession!, peer peerID: MCPeerID!, didChangeState state: MCSessionState) {
        
        if (state == .Connected) {
            session.sendData("Test".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true), toPeers: [peerID], withMode: .Reliable, error: nil)
        }
        
        if (state == .Connected || state == .NotConnected) {
            
            dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                self.peerListChanged(self.session.connectedPeers as [MCPeerID])
            })
            
        }
        
        
    }
    
    // Received data from remote peer
    func session(session: MCSession!, didReceiveData data: NSData!, fromPeer peerID: MCPeerID!) { 
        dispatch_sync(dispatch_get_main_queue(), { () -> Void in
            self.recievedData(peerID, data)
        })
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



