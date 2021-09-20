//
//  File.swift
//  
//
//  Created by Dennis Hernandez on 9/19/21.
//

import Foundation

// MARK: - Types
enum Types: String {
    case error
    
    case lineNumber
    
    case command
    case `operator`
    case `var`
    case varOp
    
    case string
    case int
    case double
    case float
    case bool
    
    case userCustom
    
    func isValue() -> Bool {
        switch self {
        case .string, .int, .double, .float, .bool:
            return true
        default:
            return false
        }
    }
    func isNumber() -> Bool {
        switch self {
        case .int, .double, .float, .bool:
            return true
        default:
            return false
        }
    }
    
    func isUserCustom() -> Bool {
        switch self {
        case .userCustom:
            return true
        default:
            return false
        }
    }
}

enum Commands: String, CaseIterable {
    case unassigned = "Unassigned"
    case print = "print"
    case dev = "Dev"
    case UI = "UI"
    case user = "floopy"
}

enum Operators: String, CaseIterable {
    case letOp = "let"
    case varOp = "var"
    func isCreateVariable() -> Bool {
        switch self {
        case .letOp, .varOp:
            return true
        default:
            return false
        }
    }
    
    func string() -> String {
        return self.rawValue
    }
    
    ///MultiplicationPrecedence
    ///Left associative
    case multOp = "*"
    case divOp = "/"
    case remainderOp = "%"
    
    ///AdditionPrecedence
    ///Left associative
    case addOp = "+"
    case subSignOp = "-" //Supports both subraction and number signing
    
    ///NilCoalescingPrecedence
    ///Right associative
    case nilCoalescingOp = "??"
    
    ///ComparisonPrecedence
    ///None
    case lessop = "<"
    case lessEqualop = "<="
    case greaterOp = ">"
    case greaterEqualOp = ">="
    case equalsOp = "=="
    case notOp = "!="
    
    ///LogicalConjunctionPrecedence
    ///Left associative
    case andOp = "&&"
    case orOp = "||"
    
    ///AssignmentPrecedence
    ///Right associative
    case assignOp = "="
    case multAssignOp = "*="
    case divAssignOp = "/="
    case remainderAssignOp = "%="
    case additionAssignOp = "+="
    case subAssignOp = "-="
    func isAssignOperator() -> Bool {
        switch self {
        case .assignOp, .multAssignOp, .divAssignOp, .remainderOp, .additionAssignOp, .subAssignOp:
            return true
        default:
            return false
        }
    }
    
    case leftCrotchet = "["
    case rightCrotchet = "]"
    
    case leftBracket = "{"
    case rightBracket = "}"
    
    case leftParentheses = "("
    case rightParentheses = ")"
    
    case ifOp = "if"
    func isIfBlock() -> Bool {
        switch self {
        case .ifOp:
            return true
        default:
            return false
        }
    }
}

