//
//  GameDisplay.swift
//  GuessMojiPlsHappen
//
//  Created by Jonathan Heriyanto on 25/03/23.
//

import SwiftUI

class UIEmojiTextField: UITextField {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setEmoji() {
        _ = self.textInputMode
    }
    
    override var textInputContextIdentifier: String? {
        return ""
    }
    
    override var textInputMode: UITextInputMode? {
        for mode in UITextInputMode.activeInputModes {
            if mode.primaryLanguage == "emoji" {
                self.keyboardType = .default // do not remove this
                return mode
            }
        }
        return nil
    }
}

struct EmojiTextField: UIViewRepresentable {
    @Binding var text: String
    var placeholder: String = ""
    
    func makeUIView(context: Context) -> UIEmojiTextField {
        let emojiTextField = UIEmojiTextField()
        emojiTextField.placeholder = placeholder
        emojiTextField.text = text
        emojiTextField.delegate = context.coordinator
        return emojiTextField
    }
    
    func updateUIView(_ uiView: UIEmojiTextField, context: Context) {
        uiView.text = text
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: EmojiTextField
        
        init(parent: EmojiTextField) {
            self.parent = parent
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            DispatchQueue.main.async { [weak self] in
                self?.parent.text = textField.text ?? ""
            }
        }
    }
}

struct LobbyDisplay: View {
    @State var emoji: String = ""
//    @State var name: String = ""
    @State var buttonTapped = false
    @EnvironmentObject var multipeerConnection: MultipeerConnection
    
    var body: some View {
        ZStack {
            Image("LobbyGraphic")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            
            VStack{
                ZStack {
                    Circle()
                        .fill(Color("darkOrange"))
                        .frame(height: 140)
                    Text("\((multipeerConnection.peers.count)+1)")
                        .font(.system(size: 55, design: .rounded))
                        .bold()
                        .foregroundColor(Color("forBg"))
                }
                .padding(.init(top: 90, leading: 0, bottom: 25, trailing: 0))
                
                Text("player(s) has joined the game")
                    .font(.system(.title3, design: .rounded))
                    .bold()
                    .foregroundColor(Color("darkOrange"))
                    .padding(.bottom, 15)
                
                ScrollView(.horizontal){
                    HStack{
                        Text("You")
                            .padding(.all, 6)
                            .background(Color("darkOrange"))
                            .foregroundColor(Color("forBg"))
                            .font(Font.body.bold())
                            .cornerRadius(9)
                        ForEach(multipeerConnection.peers, id: \.self) { peer in
                            Text(peer.displayName)
                                .padding(.all, 6)
                                .background(Color("darkOrange"))
                                .foregroundColor(Color("forBg"))
                                .font(Font.body.bold())
                                .cornerRadius(9)
                        }
                    }
                    .padding()
                }
                .frame(maxWidth: 350)
                
                HStack(spacing: 12){
//                    VStack(alignment: .leading){
//                        Text("Your Name")
//                            .font(.system(.body, design: .rounded))
//                            .bold()
//                            .foregroundColor(Color("darkOrange"))
//                        TextField("", text: $name)
//                            .padding()
//                            .frame(maxWidth: 150, maxHeight: 46)
//                            .background(.white)
//                            .cornerRadius(8)
//                            .shadow(color: Color.black.opacity(0.22), radius: 9.0, x: 0.0, y: 1.0)
//                            .disabled(buttonTapped)
//                    }
                    
                    VStack(alignment: .leading) {
                        Text("Your Emoji")
                            .font(.system(.body, design: .rounded))
                            .bold()
                            .foregroundColor(Color("darkOrange"))
                        EmojiTextField(text: $emoji, placeholder: "")
                            .padding()
                            .frame(maxWidth: 280, maxHeight: 46)
                            .background(.white)
                            .cornerRadius(8)
                            .shadow(color: Color.black.opacity(0.22), radius: 9.0, x: 0.0, y: 1.0)
                            .disabled(buttonTapped)
                    }
                    
                }
                
                HStack(spacing: 20){
                    if !buttonTapped{
                        Button {
                            multipeerConnection.send(emoji)
                            self.buttonTapped.toggle()
                        } label: {
                            Label("Submit", systemImage: "checkmark.circle.fill" )
                        }
                        .buttonStyle(stateChange())
                        .disabled(emoji.isEmpty ||  buttonTapped)
                    }else {
                        NavigationLink {
                            GameDisplay().onAppear{
                                multipeerConnection.gameStart()
                            }
                        } label: {
                            Text("Enter the Game")
                        }
                        .buttonStyle(stateChange())
                        .disabled(((multipeerConnection.peers.count+1) != multipeerConnection.emojis.count) || multipeerConnection.peers.count < 3)
                    }
                }
                .padding(.top, 25)
                
                //                Text("\(multipeerConnection.emojis.count)")
                
                Spacer()
                
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            NavigationLink() {
                                ContentView()
                                    .onAppear{
                                        multipeerConnection.leave()
                                    }
                                
                            }label: {
                                Text("Leave")
                                    .font(.system(.body, design: .rounded))
                                    .bold()
                                    .padding(.trailing, 6)
                            }
                            .disabled(buttonTapped)
                            .buttonStyle(stateChange2())
                        }
                    }
            }
            .frame(maxHeight: .infinity)
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct LobbyDisplay_Previews: PreviewProvider {
    static var previews: some View {
        LobbyDisplay().environmentObject(MultipeerConnection())
    }
}

