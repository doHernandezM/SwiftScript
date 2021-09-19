//
//  Engine.swift
//  SwiftScript
//
//  Created by Dennis Hernandez on 9/30/19.
//  Copyright © 2019 Dennis Hernandez. All rights reserved.
//

import Foundation
//import SwiftScriptBlocks


//let schwifty = SwiftScriptCompiler(isLight: false, highlightSyntax: true, string: nil)
let kDebug = true

///
///
/// Call on `SwiftScriptCompiler.compiler` to access the main compiler.
public class SwiftScriptCompiler: Codable {
    // MARK: - Basics
    public var delegate: SchwiftScriptDelegate? = nil
    public var state = State()
    public var lightCompile = false
    
    
    //Mark: - Main compiler
    
    ///
    ///
    ///To keeps things easy and make sure we only use this when we need it, we are making this static and public singleton, which is backed by an internal "\`internal?\`"
    static public var compiler: SwiftScriptCompiler {
        get {
            if (SwiftScriptCompiler.`internal` == nil) {
                SwiftScriptCompiler.`internal` = SwiftScriptCompiler(isLight: false, highlightSyntax: true, string: nil)
                return SwiftScriptCompiler.`internal`!
            }
            return SwiftScriptCompiler.`internal`!
        }
        set(newValue){
            SwiftScriptCompiler.`internal` = newValue
        }
    }
    static private var `internal`: SwiftScriptCompiler? = nil

    static public var thread: Thread? = nil
    
    
    // MARK: Syntax Highlighting
    public var highlightSyntax = false
#if os(OSX) || os(iOS)
    public var syntaxHighlighter: Highlighter? = nil
    public var attributedString: NSAttributedString? = nil
#endif
    // MARK: - Compiling
    /// Set this to start the compiler.
    public var string: String? = "" {
        didSet {
            startCompiling()
        }
    }
    
    fileprivate func compile() {
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
                syntaxHighlighter = Highlighter(compiler: self, rawString: codeString)
#endif
                self.attributedString = syntaxHighlighter?.attributedString
            }
            
            //Delegate
            delegate?.update()
        }
    }

// // MARK: Compiler Thread
    public func startCompiling() {
        SwiftScriptCompiler.thread?.cancel()
        self.stopCompiling()
        
        SwiftScriptCompiler.thread = Thread(){ [self] in
            self.compile()
        }
        
        SwiftScriptCompiler.thread?.qualityOfService = .userInteractive
        SwiftScriptCompiler.thread?.start()
    }
    
    public func stopCompiling() {
        if SwiftScriptCompiler.thread!.isCancelled {
            Thread.exit()
        }
    }
    
    // MARK: Init
    // TODO: Add support for creating a light compiler for a highlighter
    /*
     This would theoretically support a highlighter for applications that don't need a full compiler.
     */
    public init(isLight: Bool, highlightSyntax: Bool, string: String?) {
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
public protocol SchwiftScriptDelegate {
    func update()
}
