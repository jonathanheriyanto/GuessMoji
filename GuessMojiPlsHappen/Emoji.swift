//
//  Emoji.swift
//  GuessMojiPlsHappen
//
//  Created by Jonathan Heriyanto on 25/03/23.
//

import Foundation
import UIKit

struct Emoji: Identifiable, Equatable, Codable {
    var id = UUID()
    let displayName: String
    let value: String
//    let status: Bool = false
    
    var isUser: Bool {
        return displayName == UIDevice.current.name
    }
}
