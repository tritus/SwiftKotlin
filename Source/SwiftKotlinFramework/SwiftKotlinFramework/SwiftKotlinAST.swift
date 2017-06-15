//
//  SwiftKotlinAST.swift
//  SwiftKotlinFramework
//
//  Created by Angel Garcia on 15/06/2017.
//  Copyright © 2017 Angel G. Olloqui. All rights reserved.
//

import Foundation
import Source
import Parser
import AST
import Frontend

class SwiftKotlinAST {
    let fileName = NSUUID().uuidString
    
    func translate(path: String, options: TransformOptions? = nil) throws -> String {
        
        let sourceFile = try SourceReader.read(at: path)
        let parser = Parser(source: sourceFile)
        let topLevelDecl = try parser.parse()
        
        return topLevelDecl.toKotlin()
    }
    
    func translate(content: String, options: TransformOptions? = nil) throws -> String {
        guard let url = NSURL.fileURL(withPathComponents: [NSTemporaryDirectory(), fileName]) else {
            throw URLException()
        }
        try content.write(to: url, atomically: true, encoding: .utf8)
        return try translate(path: url.absoluteString.replacingOccurrences(of: "file://", with: ""), options: options)
    }
 
}

struct URLException: Error {}
