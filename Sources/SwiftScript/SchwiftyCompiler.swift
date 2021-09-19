//
//  Engine.swift
//  Schwifty
//
//  Created by Dennis Hernandez on 9/30/19.
//  Copyright © 2019 Dennis Hernandez. All rights reserved.
//

import Foundation
//import SchwiftyBlocks

let schwifty = SchwiftyCompiler(isLight: false, highlightSyntax: true, string: nil)
let kDebug = true

class SchwiftyCompiler: Codable {
    // MARK: - Basics
    var delegate: SchwiftyDelegate? = nil
    var state = SchwiftyState()
    var lightCompile = false
    
    // MARK: Syntax Highlighting
    var highlightSyntax = false
#if os(OSX) || os(iOS)
    var syntaxHighlighter: SchwiftyHighlighter? = nil
#endif
    var attributedString: NSAttributedString? = nil
    
    // MARK: - string
    // Set this to start the compiler.
    var string: String? = "" {
        didSet {
            if let codeString = self.string {
                if codeString.isEmpty {return}
                
                ///Makes sure everything is clean.
                state.errors = []
                state.lines = []
                state.variables = []
                
                //Analyzer
                
                ///Creates [Line]
                analyzeLines(codeString: codeString)
                
                ///Syntax Highlighting
                if highlightSyntax && !lightCompile {
#if os(OSX) || os(iOS)
                    syntaxHighlighter = SchwiftyHighlighter(compiler: self, rawString: codeString)
#endif
                    self.attributedString = syntaxHighlighter?.attributedString
                }
                
                //Delegate
                delegate?.update()
            }
        }
    }
    
    // MARK: Init
    // TODO: Add support for creating a light compiler for a highlighter
    /*
     This would theoretically support a highlighter for applications that don't need a full compiler.
     */
    init(isLight: Bool, highlightSyntax: Bool, string: String?) {
        self.lightCompile = isLight
        self.highlightSyntax = highlightSyntax
        if string != nil {
            self.string = string!
        }
    }
    
    // MARK: Codable Support
    enum CodingKeys: CodingKey {
        case state
        case string
    }
    
    // MARK: - Analyze - Line
    //Splits the raw code string into string components based on newlines.
    func analyzeLines(codeString: String) {
//        print("\r\t Analyzed Lines\r")
        
        let codeLines = codeString.components(separatedBy: .newlines)
        
        for (int, lineString) in codeLines.enumerated() {
            
            let line = Line(text: lineString, pos: int, words: [], theOperator: nil)
            //Adds line to state
            state.lines.append(line)

        }
        
        
        if lightCompile {
            return
        }
        
        /// if not debug mode stop
        if !kDebug {return}
        
        ///This is non-essential debiug code.
        print("\r\t Assigned Vars\r")
        for (_,stateVariable) in state.variables.enumerated() {
            print("\(stateVariable.string), \(stateVariable.value!.string), \(stateVariable.value!.typeDescription())")
        }
    }
    
}

// MARK: - Delegate
//Splits the raw code string into string components based on newlines.
protocol SchwiftyDelegate {
    func update()
}
