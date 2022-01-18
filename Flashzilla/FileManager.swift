//
//  FileManager.swift
//  Flashzilla
//
//  Created by Sree on 17/01/22.
//

import Foundation

extension FileManager {
    
  static func getUrl()->URL{
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
    }
    
    static var doucmentsDir : URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
        
    static func getFile(fileName: String) throws -> String   {
        let url = getUrl().appendingPathComponent(fileName)
        let input = try String(contentsOf: url)
        return input
    }
    
    static func saveString(str: String,fileName: String) throws {
        let url = getUrl().appendingPathComponent(fileName)
        try str.write(to: url,atomically: true,encoding: .utf8)
    }
    
}
