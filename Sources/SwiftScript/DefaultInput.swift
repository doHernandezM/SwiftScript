//
//  DefaultInput.swift
//  Schwifty
//
//  Created by Dennis Hernandez on 10/14/19.
//  Copyright © 2019 Dennis Hernandez. All rights reserved.
//

import Foundation

var a = 5
var b = 1
var c = a + b
let d = false
let e = -3.14
var f = 5
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
}
