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

///These are cheats to make this a bit more portable. iOS takes precedence, since Catalyst.
typealias UIFont = NSFont
typealias UIColor = NSColor
extension UIColor {
    func hue (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(calibratedHue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }
    static var label:NSColor {
        get {
            return NSColor.textColor
        }
    }
}
#elseif os(iOS)
import UIKit
#endif

public class Highlighter: Codable {
    var compiler: SwiftScript
    public var attributedString: NSAttributedString? = nil
    
    enum CodingKeys: CodingKey {
        case compiler
    }
    
    // MARK: Compildf
    // TODO: Add support for creating a highlighter without a compiler. Linux support
    /**
     This would theoretically support a highlighter for applications that don't need a full compiler.
     */
    public init(compiler: SwiftScript, rawString: String) {
        self.compiler = compiler
        self.attributedString = NSAttributedString(string: rawString)

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
    
    let kDefaultFontSize: CGFloat = 20.0
    let kDefaultFontSizeSmall: CGFloat = 18.0
    
    // FIXME: THis code need much simplyfication and portability.
    func attributesForLine(line: String) -> NSAttributedString {
        var multipleAttributes = [NSAttributedString.Key : Any]()
        
        let font = UIFont.monospacedSystemFont(ofSize: kDefaultFontSizeSmall, weight: .bold)
        multipleAttributes[NSAttributedString.Key.foregroundColor] = UIColor.systemRed
        multipleAttributes[NSAttributedString.Key.font] = font
        
        let myAttrString = NSMutableAttributedString(string: line, attributes: multipleAttributes)
        
        return myAttrString
    }
    
    func attributesForWord(word: Word) -> NSAttributedString {
        var multipleAttributes = [NSAttributedString.Key : Any]()
        
        var font = UIFont.systemFont(ofSize: kDefaultFontSize, weight: .medium)
        
        multipleAttributes[NSAttributedString.Key.font] = font
        multipleAttributes[NSAttributedString.Key.foregroundColor] = UIColor.label
        
        switch word.type {
        case .error:
            font = UIFont.monospacedSystemFont(ofSize: kDefaultFontSizeSmall, weight: .bold)
            multipleAttributes[NSAttributedString.Key.foregroundColor] = UIColor.systemRed
            multipleAttributes[NSAttributedString.Key.backgroundColor] = UIColor(hue: 0.0, saturation: 0.0, brightness: 0.5, alpha: 0.25)
        case .lineNumber:
            font = UIFont.systemFont(ofSize: kDefaultFontSize, weight: .light)
            multipleAttributes[NSAttributedString.Key.foregroundColor] = UIColor.systemGray
        case .command:
            multipleAttributes[NSAttributedString.Key.foregroundColor] = UIColor.systemIndigo
        case .`operator`:
            font = UIFont.systemFont(ofSize: kDefaultFontSize, weight: .medium)
            multipleAttributes[NSAttributedString.Key.font] = font
            switch word.theOperator {
            case .letOp, .varOp, .ifOp:
                let font = UIFont.systemFont(ofSize: kDefaultFontSize, weight: .bold)
                multipleAttributes[NSAttributedString.Key.font] = font
                multipleAttributes[NSAttributedString.Key.foregroundColor] = UIColor.systemPurple
            default:
                font = UIFont.systemFont(ofSize: kDefaultFontSize, weight: .regular)
                multipleAttributes[NSAttributedString.Key.font] = font
                multipleAttributes[NSAttributedString.Key.foregroundColor] = UIColor.systemPink
            }
        case .`var`:
            font = UIFont.monospacedSystemFont(ofSize: kDefaultFontSize, weight: .light)
            multipleAttributes[NSAttributedString.Key.foregroundColor] = UIColor.label
        case .string:
            multipleAttributes[NSAttributedString.Key.foregroundColor] = UIColor.systemRed
        case .int, .double, .float:
            font = UIFont.monospacedSystemFont(ofSize: kDefaultFontSize, weight: .regular)
            multipleAttributes[NSAttributedString.Key.font] = font
            multipleAttributes[NSAttributedString.Key.foregroundColor] = UIColor.systemYellow
        case .bool:
            font = UIFont.monospacedSystemFont(ofSize: kDefaultFontSize, weight: .semibold)
            multipleAttributes[NSAttributedString.Key.font] = font
            multipleAttributes[NSAttributedString.Key.foregroundColor] = UIColor.systemOrange
        case .varOp:
            font = UIFont.monospacedSystemFont(ofSize: kDefaultFontSize, weight: .semibold)
            multipleAttributes[NSAttributedString.Key.font] = font
            multipleAttributes[NSAttributedString.Key.foregroundColor] = UIColor.systemIndigo
        case .userCustom:
            multipleAttributes[NSAttributedString.Key.foregroundColor] = UIColor.systemPurple
        }
        
        let myAttrString = NSAttributedString(string: word.string, attributes: multipleAttributes)
        return myAttrString
        
    }
    
}

//#endif
