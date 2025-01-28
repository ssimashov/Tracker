//
//  Tracker.swift
//  Tracker
//
//  Created by Sergey Simashov on 03.12.2024.
//

import Foundation
import UIKit

struct Tracker {
    let id: UUID
    let title: String
    let color: UIColor
    let emoji: String
    let schedule: [Weekday]
    let isPinned: Bool
}
