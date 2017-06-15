//
//  ASTKotlin+Declaration.swift
//  SwiftKotlinFramework
//
//  Created by Angel Garcia on 15/06/2017.
//  Copyright © 2017 Angel G. Olloqui. All rights reserved.
//

import AST

extension TopLevelDeclaration : KotlinConvertible {
    func toKotlin() -> String {
        return statements.toKotlin() + "\n"
    }
}

extension CodeBlock : KotlinConvertible {
    func toKotlin() -> String {
        if statements.isEmpty {
            return "{}"
        }
        return "{\n\(statements.toKotlin().indent)\n}"
    }
}

extension GetterSetterBlock.GetterClause {
    func toKotlin() -> String {
        let attrsText = attributes.isEmpty ? "" : "\(attributes.textDescription) "
        let modifierText = mutationModifier.map({ "\($0.textDescription) " }) ?? ""
        return "\(attrsText)\(modifierText)get \(codeBlock.toKotlin())"
    }
}

extension GetterSetterBlock.SetterClause {
    func toKotlin() -> String {
        let attrsText = attributes.isEmpty ? "" : "\(attributes.textDescription) "
        let modifierText = mutationModifier.map({ "\($0.textDescription) " }) ?? ""
        let nameText = name.map({ "(\($0))" }) ?? ""
        return "\(attrsText)\(modifierText)set\(nameText) \(codeBlock.toKotlin())"
    }
}

extension GetterSetterBlock {
    func toKotlin() -> String {
        let setterStr = setter.map({ "\n\($0.toKotlin())" }) ?? ""
        return "{\n" + "\(getter.toKotlin())\(setterStr)".indent + "\n}"
    }
}

extension GetterSetterKeywordBlock {
    func toKotlin() -> String {
        let setterStr = setter.map({ "\n\($0.textDescription.indent)" }) ?? ""
        return "{\n\(getter.textDescription.indent)\(setterStr)\n}"
    }
}

extension WillSetDidSetBlock.WillSetClause {
    func toKotlin() -> String {
        let attrsText = attributes.isEmpty ? "" : "\(attributes.textDescription) "
        let nameText = name.map({ "(\($0))" }) ?? ""
        return "\(attrsText)willSet\(nameText) \(codeBlock.toKotlin())"
    }
}

extension WillSetDidSetBlock.DidSetClause {
    func toKotlin() -> String {
        let attrsText = attributes.isEmpty ? "" : "\(attributes.textDescription) "
        let nameText = name.map({ "(\($0))" }) ?? ""
        return "\(attrsText)didSet\(nameText) \(codeBlock.toKotlin())"
    }
}

extension WillSetDidSetBlock {
    func toKotlin() -> String {
        let willSetClauseStr = willSetClause.map({ "\n\($0.toKotlin().indent)" }) ?? ""
        let didSetClauseStr = didSetClause.map({ "\n\($0.toKotlin().indent)" }) ?? ""
        return "{\(willSetClauseStr)\(didSetClauseStr)\n}"
    }
}

extension PatternInitializer: KotlinConvertible {
    func toKotlin() -> String {
        let pttrnText = pattern.textDescription
        guard let initExpr = initializerExpression else {
            return pttrnText
        }
        return "\(pttrnText) = \(initExpr.toKotlin())"
    }
}

extension Collection where Iterator.Element == PatternInitializer {
    func toKotlin() -> String {
        return self.map({ $0.toKotlin() }).joined(separator: ", ")
    }
}

extension ClassDeclaration.Member {
    func toKotlin() -> String {
        switch self {
        case .declaration(let decl):
            return decl.toKotlin()
        case .compilerControl(let stmt):
            return stmt.toKotlin()
        }
    }
}

extension ClassDeclaration : KotlinConvertible {
    func toKotlin() -> String {
        let attrsText = attributes.isEmpty ? "" : "\(attributes.textDescription) "
        let modifierText = accessLevelModifier.map({ "\($0.textDescription) " }) ?? ""
        let finalText = isFinal ? "final " : ""
        let headText = "\(attrsText)\(modifierText)\(finalText)class \(name)"
        let genericParameterClauseText = genericParameterClause?.textDescription ?? ""
        let typeText = typeInheritanceClause?.textDescription ?? ""
        let whereText = genericWhereClause.map({ " \($0.textDescription)" }) ?? ""
        let neckText = "\(genericParameterClauseText)\(typeText)\(whereText)"
        let membersText = members.map({ $0.toKotlin() }).joined(separator: "\n")
        let memberText = members.isEmpty ? "" : "\n\(membersText.indent)\n"
        return "\n\(headText)\(neckText) {" + memberText + "}"
    }
}

extension ConstantDeclaration : KotlinConvertible {
    func toKotlin() -> String {
        let attrsText = attributes.isEmpty ? "" : "\(attributes.textDescription) "
        let modifiersText = modifiers.isEmpty ? "" : "\(modifiers.textDescription) "
        return "\(attrsText)\(modifiersText)val \(initializerList.toKotlin())"
    }
}

extension DeinitializerDeclaration : KotlinConvertible {
    func toKotlin() -> String {
        let attrsText = attributes.isEmpty ? "" : "\(attributes.textDescription) "
        return "\(attrsText)deinit \(body.toKotlin())"
    }
}

extension EnumDeclaration.Member {
    func toKotlin() -> String {
        switch self {
        case .declaration(let decl):
            return decl.toKotlin()
        case .compilerControl(let stmt):
            return stmt.toKotlin()
        default:
            return textDescription
        }
    }
}

extension EnumDeclaration : KotlinConvertible {
    func toKotlin() -> String {
        let attrsText = attributes.isEmpty ? "" : "\(attributes.textDescription) "
        let modifierText = accessLevelModifier.map({ "\($0.textDescription) " }) ?? ""
        let indirectText = isIndirect ? "indirect " : ""
        let headText = "\(attrsText)\(modifierText)\(indirectText)enum \(name)"
        let genericParameterClauseText = genericParameterClause?.textDescription ?? ""
        let typeText = typeInheritanceClause?.textDescription ?? ""
        let whereText = genericWhereClause.map({ " \($0.textDescription)" }) ?? ""
        let neckText = "\(genericParameterClauseText)\(typeText)\(whereText)"
        let membersText = members.map({ $0.toKotlin() }).joined(separator: "\n")
        let memberText = members.isEmpty ? "" : "\n\(membersText.indent)\n"
        return "\(headText)\(neckText) {\(memberText)}"
    }
}

extension ExtensionDeclaration.Member {
    func toKotlin() -> String {
        switch self {
        case .declaration(let decl):
            return decl.toKotlin()
        case .compilerControl(let stmt):
            return stmt.toKotlin()
        }
    }
}

extension ExtensionDeclaration : KotlinConvertible {
    func toKotlin() -> String {
        let attrsText = attributes.isEmpty ? "" : "\(attributes.textDescription) "
        let modifierText = accessLevelModifier.map({ "\($0.textDescription) " }) ?? ""
        let headText = "\(attrsText)\(modifierText)"
        let membersText = members.flatMap { member -> String? in
            let kotlinDescription = member.toKotlin()
            if kotlinDescription.contains("\nfun ") {
                return "\(headText) fun \(type.textDescription).\(kotlinDescription.replacingOccurrences(of: "\nfun ", with: ""))"
            } else {
                return nil
            }
        }
        return membersText.joined(separator: "\n")
    }
}

extension FunctionDeclaration : KotlinConvertible {
    func toKotlin() -> String {
        let attrsText = attributes.isEmpty ? "" : "\(attributes.textDescription) "
        let modifiersText = modifiers.isEmpty ? "" : "\(modifiers.textDescription) "
        let headText = "\(attrsText)\(modifiersText)fun"
        let genericParameterClauseText = genericParameterClause?.textDescription ?? ""
        let signatureText = signature.toKotlin()
        let genericWhereClauseText = genericWhereClause.map({ " \($0.textDescription)" }) ?? ""
        let bodyText = body.map({ " \($0.toKotlin())" }) ?? ""
        return "\n\(headText) \(name)\(genericParameterClauseText)\(signatureText)\(genericWhereClauseText)\(bodyText)"
    }
}

extension InitializerDeclaration : KotlinConvertible {
    func toKotlin() -> String {
        let attrsText = attributes.isEmpty ? "" : "\(attributes.textDescription) "
        let modifiersText = modifiers.isEmpty ? "" : "\(modifiers.textDescription) "
        let headText = "\(attrsText)\(modifiersText)init\(kind.textDescription)"
        let genericParameterClauseText = genericParameterClause?.textDescription ?? ""
        let parameterText = "(\(parameterList.map({ $0.textDescription }).joined(separator: ", ")))"
        let throwsKindText = throwsKind.textDescription.isEmpty ? "" : " \(throwsKind.textDescription)"
        let genericWhereClauseText = genericWhereClause.map({ " \($0.textDescription)" }) ?? ""
        return "\(headText)\(genericParameterClauseText)\(parameterText)\(throwsKindText)\(genericWhereClauseText) \(body.toKotlin())"
    }
}

extension PrecedenceGroupDeclaration : KotlinConvertible {
    func toKotlin() -> String {
        let attrsText = attributes.map({ $0.textDescription }).joined(separator: "\n")
        let attrsBlockText = attributes.isEmpty ? "{}" : "{\n\(attrsText.indent)\n}"
        return "precedencegroup \(name) \(attrsBlockText)"
    }
}

extension ProtocolDeclaration.PropertyMember {
    func toKotlin() -> String {
        let attrsText = attributes.isEmpty ? "" : "\(attributes.textDescription) "
        let modifiersText = modifiers.isEmpty ? "" : "\(modifiers.textDescription) "
        let blockText = getterSetterKeywordBlock.toKotlin()
        return "\(attrsText)\(modifiersText)var \(name)\(typeAnnotation) \(blockText)"
    }
}

extension ProtocolDeclaration.SubscriptMember {
    func toKotlin() -> String {
        let attrsText = attributes.isEmpty ? "" : "\(attributes.textDescription) "
        let modifiersText = modifiers.isEmpty ? "" : "\(modifiers.textDescription) "
        let parameterText = "(\(parameterList.map({ $0.textDescription }).joined(separator: ", ")))"
        let headText = "\(attrsText)\(modifiersText)subscript\(parameterText)"
        
        let resultAttrsText = resultAttributes.isEmpty ? "" : "\(resultAttributes.textDescription) "
        let resultText = "-> \(resultAttrsText)\(resultType.textDescription)"
        
        return "\(headText) \(resultText) \(getterSetterKeywordBlock.toKotlin())"
    }
}

extension ProtocolDeclaration.Member {
    func toKotlin() -> String {
        switch self {
        case .property(let member):
            return member.toKotlin()
        case .subscript(let member):
            return member.toKotlin()
        case .compilerControl(let stmt):
            return stmt.toKotlin()
        default:
            return textDescription
        }
    }
}

extension ProtocolDeclaration : KotlinConvertible {
    func toKotlin() -> String {
        let attrsText = attributes.isEmpty ? "" : "\(attributes.textDescription) "
        let modifierText = accessLevelModifier.map({ "\($0.textDescription) " }) ?? ""
        let headText = "\(attrsText)\(modifierText)interface \(name)"
        let typeText = typeInheritanceClause?.textDescription ?? ""
        let membersText = members.map({ $0.toKotlin() }).joined(separator: "\n")
        let memberText = members.isEmpty ? "" : "\n\(membersText.indent)\n"
        return "\(headText)\(typeText) {\(memberText)}"
    }
}

extension StructDeclaration.Member {
    func toKotlin() -> String {
        switch self {
        case .declaration(let decl):
            return decl.toKotlin()
        case .compilerControl(let stmt):
            return stmt.toKotlin()
        }
    }
}

extension StructDeclaration : KotlinConvertible {
    func toKotlin() -> String {
        let attrsText = attributes.isEmpty ? "" : "\(attributes.textDescription) "
        let modifierText = accessLevelModifier.map({ "\($0.textDescription) " }) ?? ""
        let headText = "\(attrsText)\(modifierText)data class \(name)"
        let genericParameterClauseText = genericParameterClause?.textDescription ?? ""
        let typeText = typeInheritanceClause?.textDescription ?? ""
        let whereText = genericWhereClause.map({ " \($0.textDescription)" }) ?? ""
        let neckText = "\(genericParameterClauseText)\(typeText)\(whereText)"
        let membersText = members.map({ $0.toKotlin() }).joined(separator: "\n")
        let memberText = members.isEmpty ? "" : "\n\(membersText.indent)\n"
        return "\(headText)\(neckText) {\(memberText)}"
    }
}

extension SubscriptDeclaration.Body {
    func toKotlin() -> String {
        switch self {
        case .codeBlock(let block):
            return block.toKotlin()
        case .getterSetterBlock(let block):
            return block.toKotlin()
        case .getterSetterKeywordBlock(let block):
            return block.toKotlin()
        }
    }
}

extension SubscriptDeclaration : KotlinConvertible {
    func toKotlin() -> String {
        let attrsText = attributes.isEmpty ? "" : "\(attributes.textDescription) "
        let modifiersText = modifiers.isEmpty ? "" : "\(modifiers.textDescription) "
        let parameterText = "(\(parameterList.map({ $0.textDescription }).joined(separator: ", ")))"
        let headText = "\(attrsText)\(modifiersText)subscript\(parameterText)"
        
        let resultAttrsText = resultAttributes.isEmpty ? "" : "\(resultAttributes.textDescription) "
        let resultText = "-> \(resultAttrsText)\(resultType.textDescription)"
        
        return "\(headText) \(resultText) \(body.toKotlin())"
    }
}

extension VariableDeclaration.Body : KotlinConvertible {
    func toKotlin() -> String {
        switch self {
        case .initializerList(let inits):
            return inits.map({ $0.toKotlin() }).joined(separator: ", ")
        case let .codeBlock(name, typeAnnotation, codeBlock):
            return "\(name)\(typeAnnotation) \(codeBlock.toKotlin())"
        case let .getterSetterBlock(name, typeAnnotation, block):
            return "\(name)\(typeAnnotation) \(block.toKotlin())"
        case let .getterSetterKeywordBlock(name, typeAnnotation, block):
            return "\(name)\(typeAnnotation) \(block.toKotlin())"
        case let .willSetDidSetBlock(name, typeAnnotation, initExpr, block):
            let typeAnnoStr = typeAnnotation?.textDescription ?? ""
            let initStr = initExpr.map({ " = \($0.textDescription)" }) ?? ""
            return "\(name)\(typeAnnoStr)\(initStr) \(block.toKotlin())"
        }
    }
}

extension VariableDeclaration : KotlinConvertible {
    func toKotlin() -> String {
        let attrsText = attributes.isEmpty ? "" : "\(attributes.textDescription) "
        let modifiersText = modifiers.isEmpty ? "" : "\(modifiers.textDescription) "
        return "\(attrsText)\(modifiersText)var \(body.toKotlin())"
    }
}


extension FunctionSignature : KotlinConvertible {
    func toKotlin() -> String {
        let parameterText =
            ["(\(parameterList.map({ $0.textDescription }).joined(separator: ", ")))"]
        let resultText = result.map({ [$0.toKotlin()] }) ?? []
        return (parameterText + resultText).joined(separator: " ")
    }
}


extension FunctionResult : KotlinConvertible {
    func toKotlin() -> String {
        let typeText = type.textDescription
        if attributes.isEmpty {
            return ": \(typeText)"
        }
        return ": \(attributes.textDescription) \(typeText)"
    }
}
