//  ConnectionManger.swift
//  MultipeerJamSession


import Foundation
import MultipeerConnectivity

//The name of the app's "service"
let JamSessionServiceType = "JamSession-srvc"

let JamSessionStringEncoding = NSASCIIStringEncoding


protocol JamSessionClientDelegate {
    
    func peerListChanged(peers: [MCPeerID])
    
    func recievedMessage(peer: MCPeerID, message: String)
    
    func recivedInvitationRequest(session: MCSession, peer: MCPeerID, accept: (Void)->(Void), reject: (Void)->(Void))
    
}

enum JamSessionMessage: String {
    case Start = "START"
    case Stop  = "STOP"
}

class JamSessionClient: NSObject, MCSessionDelegate {
    var delegate: JamSessionClientDelegate?
    let session: MCSession
    var peerID: MCPeerID {
        get { return self.session.myPeerID }
    }
    
    init(session: MCSession){
        self.session = session
        
        super.init()
        
        session.delegate = self
    }
    
    // Remote peer changed state
    func session(session: MCSession!, peer peerID: MCPeerID!, didChangeState state: MCSessionState) {
        
        if (state == .Connected || state == .NotConnected) {
            if let delegate = self.delegate {
                dispatch_async(dispatch_get_main_queue(), {
                    var currentPeers = self.session.connectedPeers as [MCPeerID]
                    currentPeers.insert(self.peerID, atIndex: 0)
                    delegate.peerListChanged(currentPeers)
                })
            }
        }
        
        
    }
    
    // Received data from remote peer
    func session(session: MCSession!, didReceiveData data: NSData!, fromPeer peerID: MCPeerID!) {
        if let delegate = self.delegate {
            dispatch_async(dispatch_get_main_queue(), {
                
                let message = NSString(data: data, encoding: JamSessionStringEncoding)
                delegate.recievedMessage(peerID, message:message)
                
            })
        }
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
    
    func sendMessage(message: String) {
        self.session.sendData(message.dataUsingEncoding(JamSessionStringEncoding, allowLossyConversion: true),
                            toPeers: self.session.connectedPeers,
                            withMode: .Reliable, error: nil)
        
        self.delegate?.recievedMessage(self.peerID, message:message)
        
    }
    
    func sendNoteOn(note:Int) {
        sendMessage("1:\(note)")
    }
    
    func sendNoteOff(note:Int) {
        sendMessage("0\(note)")
    }
    
}

class JamSessionServer : JamSessionClient, MCNearbyServiceAdvertiserDelegate
{
    let advertiser: MCNearbyServiceAdvertiser
    
    override init(session: MCSession){
        
        self.advertiser = MCNearbyServiceAdvertiser(peer:session.myPeerID,
            discoveryInfo: nil,
            serviceType: JamSessionServiceType)
        
        super.init(session: session)
        
        self.advertiser.delegate = self
        self.advertiser.startAdvertisingPeer()
    }
    
    func advertiser(advertiser: MCNearbyServiceAdvertiser!,
        didReceiveInvitationFromPeer peerID: MCPeerID!,
        withContext context: NSData!,
        invitationHandler: ((Bool, MCSession!) -> Void)!)
    {
        
        self.delegate?.recivedInvitationRequest(self.session, peer: peerID, accept: {
            
            invitationHandler(true, self.session)
            
        }, reject: {
            
            invitationHandler(false, self.session)
            
        })
        
    }
}


