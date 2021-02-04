//
//  String+ReplacingOccurrences.swift
//  DnDQuickLookup
//
//  Created by Hunter Oppel on 2/4/21.
//

import Foundation

extension String {
    mutating func replacingOccurrences(of target: [String], with replacement: String) -> String {
        for string in target {
            self = self.replacingOccurrences(of: string, with: replacement)
        }
        return self
    }
}
