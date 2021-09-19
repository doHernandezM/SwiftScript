//
//  SwiftScriptBlocks.swift
//  SwiftScript
//
//  Created by Dennis Hernandez on 10/11/19.
//  Copyright © 2019 Dennis Hernandez. All rights reserved.
//

import Foundation

// MARK: - Block
/** Block

 Blocks are where all of the scripting magive happens. If this gets as long as Word, then will have to break out into seperate swift file.
 Sample `Block Types`:
 
 • Create
 Let X   =   1
 • Assign
 X   =   2
 • Operator
 x   +   3
 
 Swift Infix Operator Precedence: https://developer.apple.com/documentation/swift/swift_standard_library/operator_declarations#2881142
 PRECEDENCE: * / % + - *= /= += -=
 */

class Block {
    var words: [Word] = []
    var subBlock: [Block] = []
    
    // MARK: init
    init(words: [Word]?) {
        if words == nil {return}
        
        self.words = words!
//        scanForBlocks()
    }
    
    func scanForBlocks() {
        
        if words.count < 2 {return}
        
        var orderedWords: [Int:Word] = [:]
        
        for (i,word) in words.enumerated() {
            orderedWords[i] = word
            
            
            
        }
        

//        for (_,word) in words.enumerated() {
//            switch isBlockOpen(string: word.string) {
//            case true:
//                return [Block(words: [])]
//            case false:
//                return nil
//            default:
//                print("noBlock")
//                return nil
//            }
//
//        }
        return
    }
    
    func isBlockOpen(string: String) -> Bool? {
        switch string.prefix(1) {
        case "(":
            return true
        case ")":
            return false
        default:
            return nil
        }
    }
    /* What is a block:
     let    a   =   5
     5
     
     var    b   =   1
     1
     
     a  =   a   +   b
     a   +   b
     
     if a   ==  b   {do foo}
     a   ==  b   |   {do foo}
     
     else   {do foo}
     {do foo}
     
     { a + b ( a + b)}
     */
    
    func createBlock(inString: String) -> Block {
        
        
        
        return Block(words: [])
    }
    
    
    
    static func blocksFromLines(lines: [Line]?) -> [Block]? {
        if lines == nil {return nil}
        
//        var mainBlock = Block(words: nil)
        
        for (_,_) in lines!.enumerated() {
            
            
            
        }
        
        
        return nil
    }
    
    
}

class Instruction: Codable {
    var word: Word? = nil
}

// MARK: - Types
///
enum LineCommand: String, CaseIterable {
    case create
    case assign
    
    case command
    
    case conditionalIf
    case conditionalContinue
    case conditionalClose
}
