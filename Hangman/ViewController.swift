//
//  ViewController.swift
//  Hangman
//
//  Created by Chrissy on 5/19/19.
//  Copyright © 2019 iDEX. All rights reserved.
//

import UIKit

class HMViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ConfigureKeyboard()
        ShuffleWord()
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var hm_view: HangmanView!
    
    // Words Model
    let model = ["Incubator"]//, "Design", "Efficiency", "Experience"]
    
    private func ShuffleWord() {
        hm_view.word =  model[Int.random(in: 0..<model.count)]
    }
    
    private func ConfigureKeyboard() {
        let first_line = ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"]
        let second_line = ["a", "s", "d", "f", "g", "h", "j", "k", "l"]
        let third_line = ["z", "x", "c", "v", "b", "n", "m"]
        let button_width_plus_gap = hm_view.frame.width * 0.09
        let button_width = button_width_plus_gap * 0.8
        let button_height = CGFloat(40)
        let line_space = CGFloat(20)
        let attrs = [NSAttributedString.Key.font: UIFont(name: "Helvetica Neue", size: 27)!]
        
        // TODO: Optimize the code. Try to warp them in a function.
        let first_line_minX = hm_view.frame.width * 0.05
        let first_line_minY = hm_view.frame.minY + hm_view.frame.height * 0.7
        for index in 0..<first_line.count {
            let button_frame = CGRect(x: first_line_minX + CGFloat(index) *                   button_width_plus_gap,
                                      y: first_line_minY,
                                      width: button_width,
                                      height: button_height)
            let button = UIButton(type: UIButton.ButtonType.system)
            button.frame = button_frame
            let title = NSAttributedString(string: first_line[index], attributes: attrs)
            button.setAttributedTitle(title, for: .normal)
            button.showsTouchWhenHighlighted = true
            button.addTarget(self, action: #selector(TouchedLetter(_:)), for: .touchUpInside)
            hm_view.addSubview(button)
        }
        
        let second_line_minX = (hm_view.frame.width - 9 * button_width_plus_gap) / 2
        let second_line_minY = first_line_minY + button_height + line_space
        for index in 0..<second_line.count {
            let button_frame = CGRect(x: second_line_minX + CGFloat(index) *                   button_width_plus_gap,
                                      y: second_line_minY,
                                      width: button_width,
                                      height: button_height)
            let button = UIButton(type: UIButton.ButtonType.system)
            button.frame = button_frame
            let title = NSAttributedString(string: second_line[index], attributes: attrs)
            button.setAttributedTitle(title, for: .normal)
            button.showsTouchWhenHighlighted = true
            button.addTarget(self, action: #selector(TouchedLetter(_:)), for: .touchUpInside)
            hm_view.addSubview(button)
        }
        
        let third_line_minX = (hm_view.frame.width - 7 * button_width_plus_gap) / 2
        let third_line_minY = second_line_minY + button_height + line_space
        for index in 0..<third_line.count {
            let button_frame = CGRect(x: third_line_minX + CGFloat(index) *                   button_width_plus_gap,
                                      y: third_line_minY,
                                      width: button_width,
                                      height: button_height)
            let button = UIButton(type: UIButton.ButtonType.system)
            button.frame = button_frame
            let title = NSAttributedString(string: third_line[index], attributes: attrs)
            button.setAttributedTitle(title, for: .normal)
            button.showsTouchWhenHighlighted = true
            button.addTarget(self, action: #selector(TouchedLetter(_:)), for: .touchUpInside)
            hm_view.addSubview(button)
        }
    }
    
    @IBAction func TouchedLetter(_ sender: UIButton) {
        if (!game_ended) {
            if let title = sender.currentAttributedTitle?.string {
                hm_view.selected_letter = title
                if (!hm_view.word.lowercased().contains(title)) {
                    hm_view.missed = true
                    num_miss += 1
                } else {
                    hm_view.missed = false
                    num_match += 1
                }
                hm_view.setNeedsDisplay()
            }
        }
    }
    
    
    // Tracks the miss times. Game over when reaching 7
    var num_miss = 0
    var num_match = 0
    
    var game_ended : Bool {
        get {
            return num_miss == 7 || num_match == hm_view.word.count
        }
    }
}


