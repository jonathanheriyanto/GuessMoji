//
//  DoneGuess.swift
//  GuessMojiPlsHappen
//
//  Created by Jonathan Heriyanto on 26/03/23.
//

import Foundation
import UIKit

struct Guess: Identifiable, Equatable, Codable {
    var id = UUID()
    let displayName: String
    let status: String
    
    var isUser: Bool {
        return displayName == UIDevice.current.name
    }
}
