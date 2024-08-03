//
//  UIButton + Remove Actions.swift
//  Pocket Thought
//
//  Created by Alonica🐦‍⬛🐺 on 18/07/24.
//

import UIKit

extension UIButton {
    func removeAllActions () {
        enumerateEventHandlers { action, _, event, _ in
            if let action = action {
                removeAction(action, for: event)
            }
        }
    }
}
