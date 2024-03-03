//
//  FileManager-DocumentsDirectory.swift
//  Flashzilla(Project 17)
//
//  Created by mac on 04.02.2024.
//

import Foundation
extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
