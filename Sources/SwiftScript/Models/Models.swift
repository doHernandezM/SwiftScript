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
        
        
        analyzeWords()
        
        interpretLine()
        print((self.pos),(": "),blockCommands," ",self.string)

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
        let variable1 = self.words[0] /// likely let/var or var ie "Let " or "foo" maybe "func" or command/function
        
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
            
            let variable2 = self.words[1]/// likely var or assignOp ie "foo " or "= " or function name
            
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

