//
//  SwiftScriptHighlighter.swift
//  SwiftScript
//
//  Created by Dennis Hernandez on 10/7/19.
//  Copyright © 2019 Dennis Hernandez. All rights reserved.
//

import Foundation
#if os(OSX)
import Cocoa

class Highlighter: Codable {
    var compiler: SwiftScriptCompiler
    var attributedString: NSAttributedString? = nil
    
    enum CodingKeys: CodingKey {
        case compiler
    }
    
    // MARK: Compildf
    // TODO: Add support for creating a highlighter without a compiler. /IOS/Linux support
    /**
     This would theoretically support a highlighter for applications that don't need a full compiler.
     */
    init(compiler: SwiftScriptCompiler, rawString: String) {
        self.compiler = compiler
        self.attributedString = NSAttributedString(string: rawString)
        //        let encoder = JSONEncoder()
        //        do {
        //            let jsonData = try encoder.encode(compiler)
        //            let jsonString = String(data: jsonData, encoding: .utf8)
        //            print(jsonString ?? "EncoderError")
        //        } catch {
        //            print("EncodingError: \(error)")
        //        }
        
        let newAttributed = NSMutableAttributedString(string: "")
        
        
        for (_,line) in compiler.state.lines.enumerated() {
            
            if line.hasError {
                for (i,word) in line.words.enumerated() {
                    newAttributed.append(attributesForLine(line: word.string))
                    if i != line.words.count - 1 {
                        newAttributed.append(NSAttributedString(string: " "))
                    }
                }
                
            } else {
                
                for (i,word) in line.words.enumerated() {
                    newAttributed.append(attributesForWord(word: word))
                    if i != line.words.count - 1 {
                        newAttributed.append(NSAttributedString(string: " "))
                    }
                }
                
            }
            
            newAttributed.append(NSAttributedString(string: "\r"))
        }
        
        self.attributedString = newAttributed
        
    }
    
    /*For Ref
     enum Types: String {
     case errorType
     case lineNumber
     case commandsType
     case operatorType
     case varType
     case dtringType
     case intType
     case doubleType
     case floatType
     case boolType
     }
     */
    
    let kDefaultFontSize: CGFloat = 15.0
    let kDefaultFontSizeSmall: CGFloat = 12.0
    
    // FIXME: THis code need much simplyfication and portability.
    func attributesForLine(line: String) -> NSAttributedString {
        var multipleAttributes = [NSAttributedString.Key : Any]()
        
        let font = NSFont.monospacedSystemFont(ofSize: kDefaultFontSizeSmall, weight: .bold)
        multipleAttributes[NSAttributedString.Key.foregroundColor] = NSColor.systemRed
        multipleAttributes[NSAttributedString.Key.font] = font
        
        let myAttrString = NSMutableAttributedString(string: line, attributes: multipleAttributes)
        
        return myAttrString
    }
    
    func attributesForWord(word: Word) -> NSAttributedString {
        var multipleAttributes = [NSAttributedString.Key : Any]()
        
        var font = NSFont.systemFont(ofSize: kDefaultFontSize, weight: .medium)
        
        multipleAttributes[NSAttributedString.Key.font] = font
        multipleAttributes[NSAttributedString.Key.foregroundColor] = NSColor.textColor
        
        switch word.type {
        case .error:
            font = NSFont.monospacedSystemFont(ofSize: kDefaultFontSizeSmall, weight: .bold)
            multipleAttributes[NSAttributedString.Key.foregroundColor] = NSColor.systemRed
            multipleAttributes[NSAttributedString.Key.backgroundColor] = NSColor(calibratedHue: 0.0, saturation: 0.0, brightness: 0.5, alpha: 0.25)
        case .lineNumber:
            font = NSFont.systemFont(ofSize: kDefaultFontSize, weight: .light)
            multipleAttributes[NSAttributedString.Key.foregroundColor] = NSColor.systemGray
        case .command:
            multipleAttributes[NSAttributedString.Key.foregroundColor] = NSColor.systemIndigo
        case .`operator`:
            font = NSFont.systemFont(ofSize: kDefaultFontSize, weight: .medium)
            multipleAttributes[NSAttributedString.Key.font] = font
            switch word.theOperator {
            case .letOp, .varOp, .ifOp:
                let font = NSFont.systemFont(ofSize: kDefaultFontSize, weight: .bold)
                multipleAttributes[NSAttributedString.Key.font] = font
                multipleAttributes[NSAttributedString.Key.foregroundColor] = NSColor.systemPurple
            default:
                font = NSFont.systemFont(ofSize: kDefaultFontSize, weight: .regular)
                multipleAttributes[NSAttributedString.Key.font] = font
                multipleAttributes[NSAttributedString.Key.foregroundColor] = NSColor.systemPink
            }
        case .`var`:
            font = NSFont.monospacedSystemFont(ofSize: kDefaultFontSize, weight: .light)
            multipleAttributes[NSAttributedString.Key.foregroundColor] = NSColor.textColor
        case .string:
            multipleAttributes[NSAttributedString.Key.foregroundColor] = NSColor.systemRed
        case .int, .double, .float:
            font = NSFont.monospacedSystemFont(ofSize: kDefaultFontSize, weight: .regular)
            multipleAttributes[NSAttributedString.Key.font] = font
            multipleAttributes[NSAttributedString.Key.foregroundColor] = NSColor.systemYellow
        case .bool:
            font = NSFont.monospacedSystemFont(ofSize: kDefaultFontSize, weight: .semibold)
            multipleAttributes[NSAttributedString.Key.font] = font
            multipleAttributes[NSAttributedString.Key.foregroundColor] = NSColor.systemOrange
        case .varOp:
            font = NSFont.monospacedSystemFont(ofSize: kDefaultFontSize, weight: .semibold)
            multipleAttributes[NSAttributedString.Key.font] = font
            multipleAttributes[NSAttributedString.Key.foregroundColor] = NSColor.systemIndigo
        }
        
        let myAttrString = NSAttributedString(string: word.string, attributes: multipleAttributes)
        return myAttrString
        
    }
    
}

#endif
