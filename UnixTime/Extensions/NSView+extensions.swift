//
//  NSView+extensions.swift
//  UnixTime (macOS)
//
//  Created by Kamaal M Farah on 26/07/2023.
//

import Cocoa

extension NSView {
    func setFrame(_ rect: NSRect) -> NSView {
        self.frame = rect
        return self
    }
}
