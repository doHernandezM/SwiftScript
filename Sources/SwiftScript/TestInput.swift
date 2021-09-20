//
//  DefaultInput.swift
//  SwiftScript
//
//  Created by Dennis Hernandez on 10/14/19.
//  Copyright © 2019 Dennis Hernandez. All rights reserved.
//


import Foundation

// MARK: - Test Input
/// Current ``SwiftScript`` version
///
/// Major number should only change for first release or a major expansion in supported operators/functions. Minor number changes when default input updates to show new support. Revision changed when defualt input changes.
public let Version = "0.1.1"


/// Test string.
///
/// This is considered the ``SwiftScript`` version of the Acid2 test. The compiler should support creating and assigning all the `var`/`let` operation, creating functions(`func foo() {...}`), and executing functions (`print()`)
///
/// **Note:**
/// The compiler is considered to have passed when:
///  - a = `12`
///  - b = `2`
///  - c = `6`
///  - d = `false`
///  - e = `-3.14`
///  - f = `10`
///  - g = `-5`
///  - h = `"Hou se"`
///  - i = `"ion"`
///  - j = `"jet"`
///  - k = `"red. Kite"`
///  - l = `01234567891011`
///  - m = `200e50`
///  - n = `9`
///  - 0 = `0`
public let TestString = """
var a = 5
var b = 1
var c = a + b
let d = false
let e = -3.14
var f = 9 - 0
let g = -a
let h = "Hou se"
let i = "ion"
let j = "jet"
let k = "red. Kite"
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
    let h = "Hou se"
    let i = "ion"
    let j = "jet"
    let k = "red. Kite"
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
        print("a:\(a)")
        print("b:\(b)")
        print("c:\(c)")
        print("d:\(d)")
        print("e:\(e)")
        print("f:\(f)")
        print("g:\(g)")
        print("h:\(h)")
        print("i:\(i)")
        print("j:\(j)")
        print("k:\(k)")
        print("l:\(l)")
        print("m:\(m)")
        print("n:\(n)")
        print("o:\(o)")
        
    }
    
    foo()
    
}
