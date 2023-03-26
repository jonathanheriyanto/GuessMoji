//
//  ContentView.swift
//  GuessMojiPlsHappen
//
//  Created by Jonathan Heriyanto on 25/03/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var multipeerConnection: MultipeerConnection
    
    var body: some View {
        NavigationView{
            VStack{
                Image("emojiHome")
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(0.8)
                    .padding(.top, 62)
                
                Image("guessMojiText")
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(0.7)
                    .padding(.top, -134)
                
                VStack(spacing: 25){
                    Button {
                        multipeerConnection.host()
                    } label: {
                        Label("Be a Host", systemImage: "shareplay")
                    }
                    .buttonStyle(GuessMojiBtn())
                    
                    Button {
                        multipeerConnection.join()
                    } label: {
                        Label("Join a Game", systemImage: "person.fill")
                    }
                    .buttonStyle(GuessMojiBtn())

                    NavigationLink(
                      destination: LobbyDisplay()
                        .environmentObject(multipeerConnection),
                      isActive: $multipeerConnection.connectedToGame) {
                        EmptyView()
                    }
                }
                .padding(25)
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .background(Color("forBg"))
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(MultipeerConnection())
    }
}
