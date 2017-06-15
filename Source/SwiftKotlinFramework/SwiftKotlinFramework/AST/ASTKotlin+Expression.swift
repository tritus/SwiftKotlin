//
//  ASTKotlin+Expression.swift
//  SwiftKotlinFramework
//
//  Created by Angel Garcia on 15/06/2017.
//  Copyright © 2017 Angel G. Olloqui. All rights reserved.
//

import Foundation

import AST

extension AssignmentOperatorExpression : KotlinConvertible {
    func toKotlin() -> String {
        return leftExpression.toKotlin() + " = " + rightExpression.toKotlin()
    }
}

extension BinaryOperatorExpression : KotlinConvertible {
    func toKotlin() -> String {
        return "\(leftExpression.toKotlin()) \(binaryOperator) \(rightExpression.toKotlin())"
    }
}

extension ClosureExpression : KotlinConvertible {
    func toKotlin() -> String {
        var signatureText = ""
        var stmtsText = ""
        
        if let signature = signature {
            signatureText = " \(signature.textDescription) ->"
            if statements == nil {
                stmtsText = " "
            }
        }
        
        if let stmts = statements {
            if signature == nil && stmts.count == 1 {
                stmtsText = " \(stmts[0].toKotlin()) "
            } else {
                stmtsText = "\n" +
                    stmts.map { $0.toKotlin() }.joined(separator: "\n").indent +
                "\n"
            }
        }
        return "{\(signatureText)\(stmtsText)}"
    }
}

extension ExplicitMemberExpression : KotlinConvertible {
    func toKotlin() -> String {
        switch kind {
        case let .tuple(postfixExpr, index):
            return "\(postfixExpr.toKotlin()).\(index)"
        case let .namedType(postfixExpr, identifier):
            return "\(postfixExpr.toKotlin()).\(identifier)"
        case let .generic(postfixExpr, identifier, genericArgumentClause):
            return "\(postfixExpr.toKotlin()).\(identifier)" +
            "\(genericArgumentClause.textDescription)"
        case let .argument(postfixExpr, identifier, argumentNames):
            var textDesc = "\(postfixExpr.toKotlin()).\(identifier)"
            if !argumentNames.isEmpty {
                let argumentNamesDesc = argumentNames.map({ "\($0):" }).joined()
                textDesc += "(\(argumentNamesDesc))"
            }
            return textDesc
        }
    }
}

extension ForcedValueExpression : KotlinConvertible {
    func toKotlin() -> String {
        return "\(postfixExpression.toKotlin())!"
    }
}

extension FunctionCallExpression.Argument : KotlinConvertible {
    func toKotlin() -> String {
        switch self {
        case .expression(let expr):
            return expr.toKotlin()
        case let .namedExpression(identifier, expr):
            return "\(identifier) = \(expr.toKotlin())"
        default:
            return textDescription
        }
    }
}

extension FunctionCallExpression : KotlinConvertible {
    func toKotlin() -> String {
        var parameterText = ""
        if let argumentClause = argumentClause {
            let argumentsText = argumentClause
                .map({ $0.toKotlin() })
                .joined(separator: ", ")
            parameterText = "(\(argumentsText))"
        }
        var trailingText = ""
        if let trailingClosure = trailingClosure {
            trailingText = " \(trailingClosure.toKotlin())"
        }
        return postfixExpression.toKotlin() +
        "\(parameterText)\(trailingText)"
    }
}

extension KeyPathExpression : KotlinConvertible {
    func toKotlin() -> String {
        return "#keyPath(\(expression.toKotlin()))"
    }
}

extension InitializerExpression : KotlinConvertible {
    func toKotlin() -> String {
        var textDesc = "\(postfixExpression.toKotlin()).init"
        if !argumentNames.isEmpty {
            let argumentNamesDesc = argumentNames.map({ "\($0):" }).joined()
            textDesc += "(\(argumentNamesDesc))"
        }
        return textDesc
    }
}

extension LiteralExpression : KotlinConvertible {
    func toKotlin() -> String {
        switch kind {
        case .array(let exprs):
            let arrayText = exprs
                .map({ $0.toKotlin() })
                .joined(separator: ", ")
            return "listOf(\(arrayText))"
        case .dictionary(let entries):
            if entries.isEmpty {
                return "mapOf()"
            }
            let dictText = entries
                .map({ "\($0.key.toKotlin()): \($0.value.toKotlin())" })
                .joined(separator: ", ")
            return "[\(dictText)]"
        default:
            return textDescription
        }
    }
}

extension OptionalChainingExpression : KotlinConvertible {
    func toKotlin() -> String {
        return "\(postfixExpression.toKotlin())?"
    }
}

extension ParenthesizedExpression : KotlinConvertible {
    func toKotlin() -> String {
        return "(\(expression.toKotlin()))"
    }
}

extension PostfixOperatorExpression : KotlinConvertible {
    func toKotlin() -> String {
        return "\(postfixExpression.toKotlin())\(postfixOperator)"
    }
}

extension PostfixSelfExpression : KotlinConvertible {
    func toKotlin() -> String {
        return "\(postfixExpression.toKotlin()).self"
    }
}

extension PrefixOperatorExpression : KotlinConvertible {
    func toKotlin() -> String {
        return "\(prefixOperator)\(postfixExpression.toKotlin())"
    }
}

extension SelectorExpression : KotlinConvertible {
    func toKotlin() -> String {
        switch kind {
        case .selector(let expr):
            return "#selector(\(expr.toKotlin()))"
        case .getter(let expr):
            return "#selector(getter: \(expr.toKotlin()))"
        case .setter(let expr):
            return "#selector(setter: \(expr.toKotlin()))"
        default:
            return textDescription
        }
    }
}

extension SelfExpression : KotlinConvertible {
    func toKotlin() -> String {
        switch kind {
        case .subscript(let exprs):
            let exprsText = exprs
                .map({ $0.toKotlin() })
                .joined(separator: ", ")
            return "this[\(exprsText)]"
        default:
            return textDescription
        }
    }
}

extension SubscriptExpression : KotlinConvertible {
    func toKotlin() -> String {
        return "\(postfixExpression.toKotlin())[\(expressionList.map { $0.toKotlin() }.joined(separator: ", "))]"
    }
}

extension SuperclassExpression : KotlinConvertible {
    func toKotlin() -> String {
        switch kind {
        case .subscript(let exprs):
            let exprsText = exprs
                .map({ $0.toKotlin() })
                .joined(separator: ", ")
            return "super[\(exprsText)]"
        default:
            return textDescription
        }
    }
}

extension TernaryConditionalOperatorExpression : KotlinConvertible {
    func toKotlin() -> String {
        return "\(conditionExpression.toKotlin()) ? \(trueExpression.toKotlin()) : \(falseExpression.toKotlin())"
    }
}

extension TryOperatorExpression : KotlinConvertible {
    func toKotlin() -> String {
        let tryText: String
        let exprText: String
        switch kind {
        case .try(let expr):
            tryText = "try"
            exprText = expr.toKotlin()
        case .forced(let expr):
            tryText = "try!"
            exprText = expr.toKotlin()
        case .optional(let expr):
            tryText = "try?"
            exprText = expr.toKotlin()
        }
        return "\(tryText) \(exprText)"
    }
}

extension TupleExpression : KotlinConvertible {
    func toKotlin() -> String {
        if elementList.isEmpty {
            return "()"
        }
        
        let listText: [String] = elementList.map { element in
            var idText = ""
            if let id = element.identifier {
                idText = "\(id): "
            }
            return "\(idText)\(element.expression.toKotlin())"
        }
        return "(\(listText.joined(separator: ", ")))"
    }
}

extension TypeCastingOperatorExpression : KotlinConvertible {
    func toKotlin() -> String {
        let exprText: String
        let operatorText: String
        let typeText: String
        switch kind {
        case let .check(expr, type):
            exprText = expr.toKotlin()
            operatorText = "is"
            typeText = type.textDescription
        case let .cast(expr, type):
            exprText = expr.toKotlin()
            operatorText = "as"
            typeText = type.textDescription
        case let .conditionalCast(expr, type):
            exprText = expr.toKotlin()
            operatorText = "as?"
            typeText = type.textDescription
        case let .forcedCast(expr, type):
            exprText = expr.toKotlin()
            operatorText = "as!"
            typeText = type.textDescription
        }
        return "\(exprText) \(operatorText) \(typeText)"
    }
}
