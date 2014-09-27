//  ConnectionManger.swift
//  MultipeerJamSession


import Foundation
import MultipeerConnectivity

//The name of the app's "service"
let JamSessionServiceType = "JamSession-srvc"

//The peer name for our local device
let JamSessionPeer = MCPeerID(displayName: UIDevice.currentDevice().name)


class JamSessionServer : NSObject, MCNearbyServiceAdvertiserDelegate {
    let serverName: String
    let advertiser: MCNearbyServiceAdvertiser
    
    init(serverName: String){
        self.serverName = serverName
        self.advertiser = MCNearbyServiceAdvertiser(peer: JamSessionPeer,
            discoveryInfo: nil,
            serviceType: JamSessionServiceType)
    }
    
    func advertiser(advertiser: MCNearbyServiceAdvertiser!,
                    didReceiveInvitationFromPeer peerID: MCPeerID!,
                    withContext context: NSData!,
                    invitationHandler: ((Bool, MCSession!) -> Void)!) {
        
        
        
    }
    
    
}