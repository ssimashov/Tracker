//
//  Tracker.swift
//  Tracker
//
//  Created by Sergey Simashov on 03.12.2024.
//

import UIKit

struct Tracker {
    let id: UUID
    let title: String
    let color: UIColor
    let emoji: String
    let schedule: [WeekDay]
    let isHabit: Bool
    let isPinned: Bool
}
