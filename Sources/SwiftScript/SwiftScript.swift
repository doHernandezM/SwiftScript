//
//  Engine.swift
//  SwiftScript
//
//  Created by Dennis Hernandez on 9/30/19.
//  Copyright © 2019 Dennis Hernandez. All rights reserved.
//

import Foundation

//let schwifty = SwiftScript(isLight: false, highlightSyntax: true, string: nil)
let kDebug = true

///
///
/// Call on ``compiler`` to access the main compiler.
public class SwiftScript: Codable {
    // MARK: - Basics
    public var delegate: SchwiftScriptDelegate? = nil
    public var state = State()
    public var lightCompile = false
    
    
    //Mark: - Main compiler
    
    ///
    ///
    ///To keeps things easy and make sure we only use this when we need it, we are making this static and public singleton, which is backed by an optional \``internal`\`?\.
    static public var compiler: SwiftScript {
        get {
            if (SwiftScript.`internal` == nil) {
                SwiftScript.`internal` = SwiftScript(isLight: false, highlightSyntax: true, string: nil)
                return SwiftScript.`internal`!
            }
            return SwiftScript.`internal`!
        }
        set(newValue){
            SwiftScript.`internal` = newValue
        }
    }
    static private var `internal`: SwiftScript? = nil
    
    static public var thread: Thread? = nil
    
    // MARK: Syntax Highlighting
    public var highlightSyntax = false
#if os(OSX) || os(iOS) ///Currently we do not have linux support
    public var syntaxHighlighter: Highlighter? = nil
    public var attributedString: NSAttributedString? = nil
#endif
    
    // MARK: - Compiling
    /// Set this to the string that you want to compile or highlight to start the compiler.
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
            
            ///Analyzer
            analyzeLines(codeString: codeString)
            
            ///Syntax Highlighting
            if highlightSyntax && !lightCompile {
#if os(OSX) || os(iOS)
                syntaxHighlighter = Highlighter(compiler: self, rawString: codeString)
#endif
                self.attributedString = syntaxHighlighter?.attributedString
            }
            
            //Update delegate here
            DispatchQueue.main.async {
                self.delegate?.update()
            }
        }
    }
    
    // MARK: Thread
    private func startCompiling() {
        SwiftScript.thread?.cancel()
    
        SwiftScript.thread = nil
        SwiftScript.thread = Thread(){ [self] in
            self.compile()
            Thread.exit()
        }
        
        SwiftScript.thread?.qualityOfService = .userInteractive
        SwiftScript.thread?.start()
    }
    
    // MARK: Init
    // TODO: Add support for creating a light compiler for a highlighter only use.
    /**
     This would theoretically support a highlighter for applications that don't need a full compiler.
     */
    public init(isLight: Bool, highlightSyntax: Bool, string: String?) {
        TestBlock()
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
    ///Splits the raw code string into string components based on newlines.
    func analyzeLines(codeString: String) {
                print("\r\t Analyzed Lines\r")
        
        let codeLines = codeString.components(separatedBy: .newlines)
//        print(codeString)
        
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
///Called when the compiler finishes highlighting syntax/compiling.
public protocol SchwiftScriptDelegate {
    func update()
}
