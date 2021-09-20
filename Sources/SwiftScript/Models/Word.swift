//
//  File.swift
//  
//
//  Created by Dennis Hernandez on 9/19/21.
//

import Foundation

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
        if isQoute(string: String(string.prefix(1))) || isQoute(string: String(string.suffix(1))) {
            type = .string
            return true
        }
        return false
    }
    
    func isCommand() -> Bool {
        for (_,theCommand) in Commands.allCases.enumerated() {
            let stringComponents = string.components(separatedBy: theCommand.rawValue)
            if stringComponents.count > 1 {
                command = theCommand
                type = .command
                return true
            }
        }
        return false
    }
    
    func isOperator() -> Bool {
        for (_,anOperator) in Operators.allCases.enumerated() {
            if string == anOperator.rawValue {
                theOperator = anOperator
                type = .`operator`
                return true
            }
        }
        return false
    }
    
    func assingType() {
        if isCommand() {return}
        
        if isOperator() {return}
        
        
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
