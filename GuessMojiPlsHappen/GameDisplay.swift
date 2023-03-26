//
//  GameDisplay.swift
//  GuessMojiPlsHappen
//
//  Created by Jonathan Heriyanto on 25/03/23.
//

import SwiftUI

struct GameDisplay: View {
    @EnvironmentObject var multipeerConnection: MultipeerConnection
    @State private var emoji: [Emoji] = []
    @State var done: String = "done"
    @State var buttonTapped = false
    @State var revealTapped = false
    
    var body: some View {
        ZStack {
            let emoji = multipeerConnection.emojis
            
            Image("bg1")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            
            VStack{
                HStack{
                    Button {
                    } label: {
                        Label("\(multipeerConnection.peers.count+1)", systemImage: "person.2.circle.fill")
                    }
                    .disabled(true)
                    .padding(.init(top: 55, leading: 25, bottom: 0, trailing: 0))
                    .buttonStyle(GuessMojiBtn2())
                    Spacer()
                }
                
                Image("guess")
                    .padding(.top, -3)
                
                if !revealTapped {
                    ScrollView(.horizontal){
                        LazyHStack(spacing: 15){
                            ForEach(emoji) { e in
                                Text("\(e.value)")
                                    .font(.system(size: 85))
                                    .padding()
                                    .frame(width: 250, height: 250)
                                    .background(Color.white)
                                    .cornerRadius(12)
                                    .shadow(color: Color.black.opacity(0.12), radius: 4.0, x: 0.0, y: 1.0)
                            }
                        }
                    }
                    .frame(width: 280, height: 260)
                    .padding()
                } else{
                    ScrollView(.horizontal){
                        LazyHStack(spacing: 15){
                            ForEach(emoji) { e in
                                VStack(spacing: 14) {
                                    Text("\(e.value)")
                                        .font(.system(size: 85))
                                        .padding()
                                        .frame(width: 250, height: 250)
                                        .background(Color.white)
                                        .cornerRadius(12)
                                        .shadow(color: Color.black.opacity(0.12), radius: 4.0, x: 0.0, y: 1.0)
                                    
                                    Text("\(e.displayName)")
                                        .font(.system(.body, design: .rounded))
                                        .bold()
                                        .padding(14)
                                        .background( Color("darkOrange"))
                                        .cornerRadius(17.0)
                                        .foregroundColor(Color("forBg"))
                                }
                            }
                        }
                    }
                    .frame(width: 280, height: 350)
                    .padding()
                }
                
                if !buttonTapped{
                    Button {
                        //                        multipeerConnection.send(done)
                        self.buttonTapped.toggle()
                    } label: {
                        Label("Done Guessing", systemImage: "person.crop.circle.badge.checkmark")
                    }
                    .buttonStyle(GuessMojiBtn())
                } else {
                    if !revealTapped{
                        Button {
                            self.revealTapped.toggle()
                        } label: {
                            Label("Reveal Answer", systemImage: "eyes.inverse")
                        }
                        .buttonStyle(GuessMojiBtn())
                    } else {
                        EmptyView()
                    }
                }
                
                //                Text("\(multipeerConnection.emojis.count)")
                
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct GameDisplay_Previews: PreviewProvider {
    static var previews: some View {
        GameDisplay().environmentObject(MultipeerConnection())
    }
}
