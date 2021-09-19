//
//  ViewController.swift
//  Schwifty
//
//  Created by Dennis Hernandez on 9/30/19.
//  Copyright © 2019 Dennis Hernandez. All rights reserved.
//

import Cocoa


class ViewController: NSViewController, SchwiftyDelegate, NSTextViewDelegate {
    
    @IBOutlet weak var inPutField: NSTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        schwifty.delegate = self
        inPutField.delegate = self
        schwifty.string = defaultInput
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    func textDidChange(_ notification: Notification) {
        if let field = notification.object as? NSTextView {
        schwifty.string = field.string
        }
    }
    
    func update() {
        if schwifty.attributedString != nil {
            let selectedRanges = inPutField.selectedRanges
            inPutField.textStorage?.setAttributedString(schwifty.attributedString!)
            inPutField.selectedRanges = selectedRanges
        } else {
            inPutField.string = schwifty.string ?? "no code"
        }
    }
    
}

