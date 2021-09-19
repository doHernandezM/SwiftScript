//
//  CodeModels.swift
//  SwiftScript
//
//  Created by Dennis Hernandez on 9/30/19.
//  Copyright © 2019 Dennis Hernandez. All rights reserved.
//

import Foundation

// MARK: - Error
// TODO: Add more detailed error type for debugging
struct Error: Codable {
    var type = ""
    var pos = 0
    var length = 0
}

// MARK: - State
/// This is where the compiler stores it's state. Conforms to Codable to theoretically support state save.
public class State: Codable {
    var version = 0.1
    
    var errors: [Error] = []
    var lines: [Line] = []
    var variables: [Word] = []
    
    func hasVariable(variable: Word) -> Bool {
        
        for (_,existingVariable) in self.variables.enumerated() {
            if (variable.string == existingVariable.string) {
                return true
            }
        }
        
        return false
    }
    
}

// MARK: - Line
// TODO: Reoganize and make this look prettier.
/// This is where the compiler stores it's state. Conforms to Codable to theoretically support state save.
class Line: Codable {
    var string =  ""
    var pos: Int = -1
    
    var hasError = false
    var isEditing = false
    
    var words: [Word] = []
    
    var block: Block? = nil
    var blockCommands: [String:LineCommand] = [:]
    
    var theOperator: Operators? = nil
    
    enum CodingKeys: CodingKey {
        case string
        case pos
        case words
    }
    
    init(text: String, pos: Int, words: [Word], theOperator: Operators?) {
        self.string = text
        self.pos = pos
        self.words = words
        self.theOperator = theOperator
        
        //        print(("L"),(self.pos),("---------------------------------------------------------------------------------------------- \r"),self.string)
        
        analyzeWords()
        
        interpretLine()
        //         print(blockCommands)
        
        
        //        self.block = Block(words: self.words)
        
    }
    
    // MARK: Analyze - Word
    /// Splits the line String into string components based on whitespace.
    func analyzeWords() {
        let codeWords = self.string.components(separatedBy: .whitespaces)
        for (_,word) in codeWords.enumerated() {
            //Creates a new word and adds its variable to the state.
            let newWord = Word(string: word)
            self.words.append(newWord)
        }
    }
    
    func interpretLine() {
        // MARK: - Line Pattern
        // Step 2 - Patterns
        // Assign values to variable
        let variable1 = self.words[0] /// likely let/var or var ie "Let " or "foo "
        
        //        if self.words.count > 0 {
        //            // Modify existing variable
        //            if variable1.string.contains(Operators.ifOp.rawValue)  {
        //                print("Iffy")
        //                blockCommands["ConditionalIf"] = LineCommand.ConditionalIf
        //
        //
        //
        //                if self.pos > 0 {return}
        //                let lastLine = schwifty.state.lines[self.pos - 1]
        //            }
        //        }
        //
        if self.words.count > 1 {
            
            let variable2 = self.words[1]/// likely var or assignOp ie "foo " or "= "
            
            // Modify existing variable
            if (variable2.theOperator?.isAssignOperator() ?? false)  {
                blockCommands["Assign"] = LineCommand.assign
                return
            }
            
            if (variable1.theOperator?.isCreateVariable() ?? false) {
                
                ///I'm not really sure what's going on here `<=4\` then `>=4`??? WTF Maybe a typo
                if self.words.count <= 4 {
                    //                    print(self.words)
                    //                    print("|||||||||||||||||||\r\r")
                    if self.words.count >= 4 {
                        let variable3 = self.words[3]
                        ///likely var, ie "foo " or "\"foo\"" | "3.14" | "false"
                        if !(variable3.type.isValue()) {
                            variable3.type = .error
                            //Adds whole line error
                            return
                        }
                        
                        /// var found
                        blockCommands["Create"] = LineCommand.create// Unknown type or error
                        variable2.value = variable3
                        SwiftScript.compiler.state.variables.append(variable2)
                        return
                    }
                }
            }
            
        }
        
    }
}

// MARK: - Word
//
class Word: Codable {
    var name = ""
    var pos = 0
    
    var string: String = ""
    
    var number: NSNumber? = nil
    var command: Commands? = nil
    var theOperator: Operators? = nil
    
    var blockCommands: [String:LineCommand] = [:]
    
    var value: Word? = nil
    
    var type = Types.error
    
    func typeDescription() -> String{
        var typeString = "Undescribed"
        
        if (self.type == .command) {
            typeString = command!.rawValue
            return typeString
        }
        if (self.type == .`operator`) {
            typeString = self.theOperator!.rawValue
            return typeString
        }
        if (self.value != nil) {
            if (self.value!.isValue()) {
                typeString = self.value!.string
            }
        }
        else {
            typeString = self.type.rawValue
        }
        return typeString
    }
    
    func description() -> String{
        if self.value != nil {
            var newString = ""
            newString = "\(self.string) = \(self.value!.string)"
            return newString
        }
        return "I have no value"
    }
    
    enum CodingKeys: CodingKey {
        case name
        case string
        case pos
        case value
    }
    
    init(string: String) {
        self.string = string
        self.name = string
        
        assingType()
        
    }
    
    func isQoute(string: String) -> Bool {
        let qoutes = CharacterSet(charactersIn: "\"\u{201C}\u{201D}")
        if string.rangeOfCharacter(from: qoutes) != nil {
            return true
        }
        return false
    }
    
    func isString() -> Bool {
        
        if isQoute(string: String(string.prefix(1))) && isQoute(string: String(string.suffix(1))) {
            type = .string
            return true
        }
        return false
    }
    
    func assingType() {
        for (_,theCommand) in Commands.allCases.enumerated() {
            let stringComponents = string.components(separatedBy: theCommand.rawValue)
            if stringComponents.count > 1 {
                command = theCommand
                type = .command
                return
            }
        }
        
        for (_,anOpertator) in Operators.allCases.enumerated() {
            if string == anOpertator.rawValue {
                theOperator = anOpertator
                //                print(("OP:"),anOpertator.string())
                type = .`operator`
                return
            }
        }
        
        if isString() {return}
        
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        let assignedNumber = formatter.number(from: string)
        
        if assignedNumber == nil {
            if string == "false" {
                number = NSNumber(value: false)
                type = .bool
                return
            }
            else if string == "true" {
                number = NSNumber(value: true)
                type = .bool
                return
            }
            
            
            type = .`var`
            return
        }
        
        
        if type == .lineNumber {
            return
        }
        
        self.number = assignedNumber
        
        let numberType = CFNumberGetType(number)
        
        switch numberType {
            /// Bool
        case .charType:
            type = .bool
            /// Int
        case .sInt8Type, .sInt16Type, .sInt32Type, .sInt64Type, .shortType, .intType, .longType, .longLongType, .cfIndexType, .nsIntegerType:
            type = .int
            /// Double
        case .doubleType:
            type = .double
            /// Float
        case .float32Type, .float64Type, .floatType, .cgFloatType:
            type = .float
            /// Error
        default:
            type = .error
        }
        
    }
    
    func isValue() -> Bool {
        if self.value != nil {
            return self.value!.type.isValue()
        }
        return false
    }
    
}

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
}

enum Commands: String, CaseIterable {
    case unassigned = "Unassigned"
    case print = "print"
    case dev = "Dev"
    case UI = "UI"
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

// MARK: - Test Input
/// Current ``SwiftScript`` version
///
/// Major number should only change for first release or a major expansion in supported operators/functions. Minor number changes when default input updates to show new support. Revision changed when defualt input changes.
public let Version = "0.1.0"


/// Test string.
///
/// This is considered the ``SwiftScript`` version of the Acid2 test. The compiler should support creating and assigning all the `var`/`let` operation, creating functions(`func foo() {...}`), and executing functions (`print()`)
/// - Note:
///  The compiler is considered to have passed when:
///  a = `12`
///  b = `2`
///  c = `6`
///  d = `false`
///  e = `-3.14`
///  f = `10`
///  g = `-5`
///  h = `"House"`
///  i = `"ion"`
///  j = `"jet"`
///  k = `"redKite"`
///  l = `01234567891011`
///  m = `200e50`
///  n = `9`
///  0 = `0`
public let TestString = """
var a = 5
var b = 1
var c = a + b
let d = false
let e = -3.14
var f = 9 - 0
let g = -a
let h = "House"
let i = "ion"
let j = "jet"
let k = "redKite"
let l = 01234567891011
let m = 200e50
let n = f
let o = 0

func foo() {
    if a == 5 {
        a = b + a
    }
    
    f += 1
    b = b + 1
    
    a += a
    
    print(a)
    print(b)
    print(c)
    print(f)

    foo()
}

"""

var TestBlock: () -> Void = {
    var a = 5
    var b = 1
    var c = a + b
    let d = false
    let e = -3.14
    var f = 9 - 0
    let g = -a
    let h = "House"
    let i = "ion"
    let j = "jet"
    let k = "redKite"
    let l = 01234567891011
    let m = 200e50
    let n = f
    let o = 0

    func foo() {
        if a == 5 {
            a = b + a
        }
        
        f += 1
        b = b + 1
        
        a += a
        
        print("Var Values\r")
        print("a:\(a)\r)")
        print("b:\(b)\r)")
        print("c:\(c)\r)")
        print("d:\(d)\r)")
        print("e:\(e)\r)")
        print("f:\(f)\r)")
        print("g:\(g)\r)")
        print("h:\(h)\r)")
        print("i:\(i)\r)")
        print("j:\(j)\r)")
        print("k:\(k)\r)")
        print("l:\(l)\r)")
        print("m:\(m)\r)")
        print("n:\(n)\r)")
        print("o:\(o)\r)")
        
    }
    
    foo()
    
}
