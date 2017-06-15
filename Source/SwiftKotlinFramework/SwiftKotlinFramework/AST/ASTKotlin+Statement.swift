//
//  ASTKotlin+Statement.swift
//  SwiftKotlinFramework
//
//  Created by Angel Garcia on 15/06/2017.
//  Copyright © 2017 Angel G. Olloqui. All rights reserved.
//

import Foundation

import AST

extension Statement {
    func toKotlin() -> String {
        switch self {
        case let kotlinConvertible as KotlinConvertible:
            return kotlinConvertible.toKotlin()
        default:
            return textDescription
        }
    }
}

extension Collection where Iterator.Element == Statement {
    func toKotlin() -> String {
        return self.map({ $0.toKotlin() }).joined(separator: "\n")
    }
}

extension Condition {
    func toKotlin() -> String {
        switch self {
        case .expression(let expr):
            return expr.toKotlin()
        case let .case(pattern, expr):
            return "case \(pattern) = \(expr.toKotlin())"
        case let .let(pattern, expr):
            return "val \(pattern) = \(expr.toKotlin())"
        case let .var(pattern, expr):
            return "var \(pattern) = \(expr.toKotlin())"
        default:
            return textDescription
        }
    }
}

extension Collection where Iterator.Element == Condition {
    func toKotlin() -> String {
        return self.map({ $0.toKotlin() }).joined(separator: ", ")
    }
}

extension DeferStatement : KotlinConvertible {
    func toKotlin() -> String {
        return "defer \(codeBlock.toKotlin())"
    }
}

extension DoStatement.CatchClause {
    func toKotlin() -> String {
        var patternText = ""
        if let pattern = pattern {
            patternText = " \(pattern.textDescription)"
        }
        var whereText = ""
        if let whereExpr = whereExpression {
            whereText = " where \(whereExpr.toKotlin())"
        }
        return "catch\(patternText)\(whereText) \(codeBlock.toKotlin())"
    }
}

extension DoStatement : KotlinConvertible {
    func toKotlin() -> String {
        return (["do \(codeBlock.toKotlin())"] +
            catchClauses.map({ $0.toKotlin() })).joined(separator: " ")
    }
}

extension ForInStatement : KotlinConvertible {
    func toKotlin() -> String {
        var descr = "for"
        if item.isCaseMatching {
            descr += " case"
        }
        descr += " \(item.matchingPattern.textDescription) in \(collection.toKotlin()) "
        if let whereClause = item.whereClause {
            descr += "where \(whereClause.toKotlin()) "
        }
        descr += codeBlock.toKotlin()
        return descr
    }
}

extension GuardStatement : KotlinConvertible {
    func toKotlin() -> String {
        return "guard \(conditionList.toKotlin()) else \(codeBlock.toKotlin())"
    }
}

extension IfStatement.ElseClause {
    func toKotlin() -> String {
        switch self {
        case .else(let codeBlock):
            return "else \(codeBlock.toKotlin())"
        case .elseif(let ifStmt):
            return "else \(ifStmt.toKotlin())"
        }
    }
}

extension IfStatement : KotlinConvertible {
    func toKotlin() -> String {
        var elseText = ""
        if let elseClause = elseClause {
            elseText = " \(elseClause.toKotlin())"
        }
        return "if (\(conditionList.toKotlin())) \(codeBlock.toKotlin())\(elseText)"
    }
}

extension RepeatWhileStatement : KotlinConvertible {
    func toKotlin() -> String {
        return "repeat \(codeBlock.toKotlin()) while \(conditionExpression.toKotlin())"
    }
}

extension ReturnStatement : KotlinConvertible {
    func toKotlin() -> String {
        if let expression = expression {
            return "return \(expression.toKotlin())"
        }
        return "return"
    }
}

extension SwitchStatement.Case.Item {
    func toKotlin() -> String {
        var whereText = ""
        if let whereExpr = whereExpression {
            whereText = " where \(whereExpr.toKotlin())"
        }
        return "\(pattern.textDescription)\(whereText)"
    }
}

extension SwitchStatement.Case {
    func toKotlin() -> String {
        switch self {
        case let .case(itemList, stmts):
            let itemListText = itemList.map({ $0.toKotlin() }).joined(separator: ", ")
            return "case \(itemListText):\n\(stmts.toKotlin().indent)"
        case .default(let stmts):
            return "default:\n\(stmts.toKotlin().indent)"
        }
    }
}

extension SwitchStatement : KotlinConvertible {
    func toKotlin() -> String {
        var casesDescr = "{}"
        if !cases.isEmpty {
            let casesText = cases.map({ $0.toKotlin() }).joined(separator: "\n")
            casesDescr = "{\n\(casesText)\n}"
        }
        return "switch \(expression.toKotlin()) \(casesDescr)"
    }
}

extension ThrowStatement : KotlinConvertible {
    func toKotlin() -> String {
        return "throw \(expression.toKotlin())"
    }
}

extension WhileStatement : KotlinConvertible {
    func toKotlin() -> String {
        return "while \(conditionList.toKotlin()) \(codeBlock.toKotlin())"
    }
}

extension LabeledStatement : KotlinConvertible {
    func toKotlin() -> String {
        return "\(labelName) = \(statement.toKotlin())"
    }
}
