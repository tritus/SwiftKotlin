//
//  KotlinConvertible.swift
//  SwiftKotlinFramework
//
//  Created by Angel Garcia on 15/06/2017.
//  Copyright © 2017 Angel G. Olloqui. All rights reserved.
//

import Foundation
import AST


public typealias Statements = [Statement]
//
//extension Collection where Iterator.Element == Statement {
//    func toKotlin() -> String {
//        return self.map({ $0.toKotlin() }).joined(separator: "\n")
//    }
//}

protocol KotlinConvertible {
    func toKotlin() -> String
}


extension String {
    init(indentation: Int) {
        self.init(repeating: "  ", count: indentation)
    }
    
    static let indent = String(indentation: 1)
    
    var indent: String {
        return components(separatedBy: .newlines)
            .map { String.indent + $0 }
            .joined(separator: "\n")
    }
}


//
//
//extension ASTTextRepresentable {
//    func toKotlin() -> String {
//        
//        return textDescription
//    }
//}
//
//extension TopLevelDeclaration {
//    func toKotlin() -> String {
//        return statements.toKotlin()
//    }
//}
//


