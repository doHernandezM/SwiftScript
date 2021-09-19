# SwiftScript

### "1 part HyperCard, 1 part realBasic(rip), and 3 parts Swift."

This code currently just highlights most swift code. However, in the future this will be able to do things based on the compiled text.

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
SwiftScriptCompiler.compiler.delegate = myDelegate
```
3. Set the 
```swift
SwiftScriptCompiler.compiler.string = myStringToBeCompiled
```
 to string to be compiled or highlighted
4. Once the string has been compiled, you can access the attributed strings via 
```swift
myAttributedString = SwiftScriptCompiler.compiler.attributedString
```
5. Or you can access the compiled lines, errors and vars via 
```swift
var errors: [SwiftScriptCompiler.Error] = SwiftScriptCompiler.compiler.state.errors
```

### Requires:
1. Swift ~4, developed under 5.2+
2. macOS 10.15+ for Syntext Highlighting
