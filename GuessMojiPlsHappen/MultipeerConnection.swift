//
//  MultipeerConnection.swift
//  GuessMojiPlsHappen
//
//  Created by Jonathan Heriyanto on 25/03/23.
//

import Foundation
import MultipeerConnectivity

class MultipeerConnection: NSObject, ObservableObject{
    private static let service = "guess-moji"
    
    @Published var emojis: [Emoji] = []
    @Published var peers: [MCPeerID] = []
    @Published var connectedToGame = false
    
    let peerID = MCPeerID(displayName: UIDevice.current.name)
    private var advertiser: MCNearbyServiceAdvertiser?
    private var session: MCSession?
    private var isHosting = false
    
    func send(_ value: String){
        let emoji = Emoji(displayName: peerID.displayName, value: value)
        emojis.append(emoji)
        guard
            let session = session,
            let data = value.data(using: .utf8),
            !session.connectedPeers.isEmpty
        else { return }
        
        do{
            try session.send(data, toPeers: session.connectedPeers, with: .reliable)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func sendHistory(to peer:MCPeerID){
        let tempStorage = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("emojis.data")
        guard let emojiHistory = try? JSONEncoder().encode(emojis) else { return }
        try? emojiHistory.write(to: tempStorage)
        session?.sendResource(at: tempStorage, withName: "Emoji_History", toPeer: peer) { error in
            if let error = error{
                print(error.localizedDescription)
            }
        }
    }
    
    func join(){
        peers.removeAll()
        emojis.removeAll()
        session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        session?.delegate = self
        guard
            let window = UIApplication.shared.windows.first,
            let session = session
        else { return }
        
        let mcBrowserViewController = MCBrowserViewController(serviceType: MultipeerConnection.service, session: session)
        mcBrowserViewController.delegate = self
        window.rootViewController?.present(mcBrowserViewController, animated: true)
    }
    
    func host(){
        isHosting = true
        peers.removeAll()
        emojis.removeAll()
        connectedToGame = true
        session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        session?.delegate = self
        advertiser = MCNearbyServiceAdvertiser(
            peer: peerID,
            discoveryInfo: nil,
            serviceType: MultipeerConnection.service)
        advertiser?.delegate = self
        advertiser?.startAdvertisingPeer()
    }
    
    func gameStart(){
        advertiser?.stopAdvertisingPeer()
    }
    
    func leave(){
        isHosting = false
        connectedToGame = false
        advertiser?.stopAdvertisingPeer()
        emojis.removeAll()
        session = nil
        advertiser = nil
    }
}

extension MultipeerConnection: MCNearbyServiceAdvertiserDelegate{
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true, session)
    }
}

extension MultipeerConnection: MCSessionDelegate{
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state{
        case .connected:
            if !peers.contains(peerID){
                DispatchQueue.main.async {
                    self.peers.insert(peerID, at: 0)
                    print("Connected \(self.peers)")
                }
                if isHosting{
                    sendHistory(to: peerID)
                }
            }
        case .notConnected:
            DispatchQueue.main.async {
                if let index = self.peers.firstIndex(of: peerID){
                    self.peers.remove(at: index)
                }
                if self.peers.isEmpty && !self.isHosting{
                    self.connectedToGame = false
                }
            }
        case .connecting:
            print("Connecting to: \(peerID.displayName)")
        @unknown default:
            print("Unknown State")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        guard let value = String(data: data, encoding: .utf8) else { return }
        let emoji = Emoji(displayName: peerID.displayName,value: value)
        DispatchQueue.main.async {
            self.emojis.append(emoji)
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        print("Receive Stream \(peers)")
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        print("Receiving All Emoji \(emojis)")
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        guard
            let localURL = localURL,
            let data = try? Data(contentsOf: localURL),
            let emojis = try? JSONDecoder().decode([Emoji].self, from: data)
        else { return }
        
        DispatchQueue.main.async {
            self.emojis.insert(contentsOf: emojis, at: 0)
            print("didReceive withName FromPeer \(self.peers)")
        }
    }
    
    
}

extension MultipeerConnection: MCBrowserViewControllerDelegate{
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        browserViewController.dismiss(animated: true){
            self.connectedToGame = true
        }
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        session?.disconnect()
        browserViewController.dismiss(animated: true)
    }
}
