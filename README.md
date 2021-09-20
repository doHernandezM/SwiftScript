# SwiftScript v0.1.1
## "*Lite*" Version of Swift: for fun

### 1 part HyperCard, 1 part realBasic(rip), and 3 parts Swift.

The intent of Schwifty is to be even more light weight and easy to use than Swfit. It does this by dropping support for everything but assigning variables, arithmetic and if statements.

Download the demo app  [Schwifty](https://github.com/doHernandezM/Schwifty) for more

### Status
• This code currently just highlights most swift code. However, in the future this will be able to do things based on the compiled text.
• Going to use pre-fab blocks to support 

**Todo:**
• Highlight entered text vs error vs string

I'm thinking that I should be able to use blocks to get things done.

To get started
 1. Conform to 
 ```swift
 public protocol SchwiftScriptDelegate {
    func update()
 }
   ```
 2. Set the designated delegate
 ```swift
 SwiftScript.compiler.delegate = myDelegate
 ```
 3. Set the compilers string to string to be compiled or highlighted
 ```swift
 SwiftScript.compiler.string = myStringToBeCompiled
 ```
 4. Once the string has been compiled, you can access the attributed strings via  
 ```swift
 let myAttributedString: NSAttributedString = SwiftScript.compiler.attributedString 
 ```
 5. Or you can access the compiled lines, errors and vars via 
 ```swift
 var errors: [SwiftScript.Error] = SwiftScript.compiler.state.errors
 ```

### Requires:
1. Swift ~4, developed under 5.2+
2. macOS 10.15+ for Syntext Highlighting
