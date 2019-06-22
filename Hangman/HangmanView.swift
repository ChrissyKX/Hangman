//
//  HangmanView.swift
//  Hangman
//
//  Created by Chrissy on 5/19/19.
//  Copyright © 2019 iDEX. All rights reserved.
//

import UIKit

class HangmanView: UIView {
    
    // The misterious word
    lazy var word = ""
    
    // Helper functions for drawing underlines and vars for associated
    // values.
    lazy var lengthForAnUnderLinePlusAGap = CGFloat()
    
    private func ComputeLengthForUnderLinePlusGap() {
        if word.count > 9 {
            lengthForAnUnderLinePlusAGap = self.frame.width * 0.9 /
                                           CGFloat(word.count)
        } else {
            lengthForAnUnderLinePlusAGap = self.frame.width * 0.1
        }
    }
    
    // the starting x value for underlines
    var _start : CGFloat {
        if (lengthForAnUnderLinePlusAGap == self.frame.width * 0.1) {
            return (self.frame.width - CGFloat(word.count) * lengthForAnUnderLinePlusAGap) / 2
        } else {
            return self.frame.width * 0.05
        }
    }
    
    // The ratio of the underline to the total length of the sum of an
    // underline and a gap
    let underlinet_ratio = CGFloat(0.8)
    
    
    // Text label on the top of the screen showing game result when the game is over
    lazy var result_label : UILabel = { [weak self] in
        var label = UILabel()
        if let frame = self?.frame {
            label = UILabel(frame: CGRect(x: frame.width * 0.25,
                                          y: frame.minY + frame.height * 0.025,
                                          width: frame.midX,
                                          height: 40))
            // TODO: figure out hoe to modify attributed text with assigning to it
            
            let attrs = [NSAttributedString.Key.font: UIFont(name: "Helvetica Neue", size: 40)!,
                         NSAttributedString.Key.foregroundColor: UIColor.black]
            label.attributedText = NSMutableAttributedString(string: "", attributes: attrs)

            label.textAlignment = .center
            // label.font = UIFont(name: "Helvetica Neue", size: 40)
        }
        addSubview(label)
        return label
    }()
    
    
    // Functions and associated vars for drawing text on the underlines.
    let attrs = [NSAttributedString.Key.font: UIFont(name: "Helvetica Neue", size: 30)!]
    
    // The most recent selected letter
    var selected_letter : String?
    
    // Tracks which indeces in the string have been matched
    lazy var matched_list = [Bool](repeating: false, count: word.count)
    
    var num_matched = 0
    
    private func DrawLetter() {
        if let letter = selected_letter {
            var index = 0;
            for char in word {
                // Draw both previously and newly matched letters on screen
                if (String(char).lowercased() == letter || matched_list[index]) {
                    let start = _start
                    let text = NSAttributedString(string: String(char), attributes: attrs)
                    // TODO: Optimize the way to display letters
                    // May use text labels
                    // Currently 0.25 is for diplaying the letters at the middle of the
                    // underlines
                    let letter_frame = CGRect(x: start + CGFloat(Double(index) + 0.25) *
                                              lengthForAnUnderLinePlusAGap,
                                              y: self.frame.minY + self.frame.height * 0.55,
                                              width: lengthForAnUnderLinePlusAGap * underlinet_ratio,
                                              height: self.frame.height * 0.05)
                    text.draw(in: letter_frame)
                    
                    // Add the indices of newly matched letters
                    if (String(char).lowercased() == letter) {
                        matched_list[index] = true
                        num_matched += 1
                        
                        // Disable the button after match
                        
                    }
                    
                    // Check if the user has won the game
                    if (num_matched == matched_list.count) {
                        result_label.text = "You Win!"
                    }
                }
                index += 1
            }
        }
    }

    // Functions and vars for drawing hang man
    
    // Consecutive Paths for hang man
    lazy var hangman_paths : [UIBezierPath] = { [weak self] in
        var paths = [UIBezierPath]()
        if let frame = self?.frame {
            // path for head
            let center = CGPoint(x: frame.width * 0.5,
                                 y: frame.minY + frame.height * 0.175)
            let radius = CGFloat(frame.height * 0.025)
            let startAngle = CGFloat(0)
            let endAngle = CGFloat(2 * Double.pi)
            let head_path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            head_path.lineWidth = 0.7
            paths.append(head_path)
            
            // path for body
            let body_path = UIBezierPath()
            body_path.move(to: CGPoint(x: frame.width * 0.5,
                                       y: frame.minY + frame.height * 0.2))
            body_path.addLine(to: CGPoint(x: frame.width * 0.5,
                                          y: frame.minY + frame.height * 0.25))
            body_path.lineWidth = 0.7
            paths.append(body_path)
            
            // path for left arm
            let leftarm_path = UIBezierPath()
            leftarm_path.move(to: CGPoint(x: frame.width * 0.5,
                                          y: frame.minY + frame.height * 0.2))
            leftarm_path.addLine(to: CGPoint(x: frame.width * 0.5 - radius,
                                             y: frame.minY + frame.height * 0.25))
            leftarm_path.lineWidth = 0.7
            paths.append(leftarm_path)
            
            // path for right arm
            let rightarm_path = UIBezierPath()
            rightarm_path.move(to: CGPoint(x: frame.width * 0.5,
                                          y: frame.minY + frame.height * 0.2))
            rightarm_path.addLine(to: CGPoint(x: frame.width * 0.5 + radius,
                                             y: frame.minY + frame.height * 0.25))
            rightarm_path.lineWidth = 0.7
            paths.append(rightarm_path)
            
            // path for left leg
            let leftleg_path = UIBezierPath()
            leftleg_path.move(to: CGPoint(x: frame.width * 0.5,
                                          y: frame.minY + frame.height * 0.25))
            leftleg_path.addLine(to: CGPoint(x: frame.width * 0.5 - radius,
                                             y: frame.minY + frame.height * 0.3))
            leftleg_path.lineWidth = 0.7
            paths.append(leftleg_path)
            
            // path for right leg
            let rightleg_path = UIBezierPath()
            rightleg_path.move(to: CGPoint(x: frame.width * 0.5,
                                          y: frame.minY + frame.height * 0.25))
            rightleg_path.addLine(to: CGPoint(x: frame.width * 0.5 + radius,
                                             y: frame.minY + frame.height * 0.3))
            rightleg_path.lineWidth = 0.7
            paths.append(rightleg_path)
            
            // path for rope
            let rope_path = UIBezierPath()
            rope_path.move(to: CGPoint(x: frame.width * 0.5,
                                      y: frame.minY + frame.height * 0.1))
            rope_path.addLine(to: CGPoint(x: frame.width * 0.5,
                                          y: frame.minY + frame.height * 0.15))
            rope_path.lineWidth = 0.7
            paths.append(rope_path)
        }
        return paths
    }()
    
    var missed = true
    
    // When the view is set up for the first time this var goes from -2 to -1. No letter
    // is drawn on the screen. No letter will be drawn until the user selected a matched
    // letter since current index is -1 < 0
    var hangman_path_index = -2
    
    private func DrawHangMan() {
        if (hangman_path_index < 6) {
            if (missed) {
                hangman_path_index += 1
            }
            
            if (hangman_path_index >= 0) {
                for index in 0..<hangman_path_index {
                    hangman_paths[index].stroke()
                }
                UIView.animate(withDuration: 2) { [weak self] in
                    if let _self = self {
                        _self.hangman_paths[_self.hangman_path_index].stroke()
                    }
                }
            }
            
            if (hangman_path_index == 6) {
                result_label.text = "Game Over."
            }
        }
    }
    
   
    // Path functions
    private func PathForFrame() -> UIBezierPath {
        let path = UIBezierPath()
        // Draws the upper part of the frame
        path.move(to: CGPoint(x: self.frame.width * 0.25,
                              y: self.frame.minY + self.frame.height * 0.1))
        path.addLine(to: CGPoint(x: self.frame.width * 0.75,
                                 y: self.frame.minY + self.frame.height * 0.1))
        // Draws the vertical part of the frame
        path.move(to: CGPoint(x: self.frame.width * 0.7,
                              y: self.frame.minY + self.frame.height * 0.1))
        path.addLine(to: CGPoint(x: self.frame.width * 0.7,
                                 y: self.frame.minY + self.frame.height * 0.5))
        // Draws the ground
        path.move(to: CGPoint(x: self.frame.width * 0.8,
                              y: self.frame.minY + self.frame.height * 0.5))
        path.addLine(to: CGPoint(x: self.frame.width * 0.2,
                                 y: self.frame.minY + self.frame.height * 0.5))
        // Draws the
        path.move(to: CGPoint(x: self.frame.width * 0.6,
                              y: self.frame.minY + self.frame.height * 0.1))
        path.addLine(to: CGPoint(x: self.frame.width * 0.7,
                              y: self.frame.minY + self.frame.height * 0.1
                                 + self.frame.width * 0.1))
        path.lineWidth = 10
        return path
    }
    
    private func PathForUnderLines() -> UIBezierPath {
        let path = UIBezierPath()
        
        var start = _start
        
        let posY = self.frame.minY + self.frame.height * 0.6
        
        for _ in 0..<word.count {
            path.move(to: CGPoint(x: start, y: posY))
            path.addLine(to: CGPoint(x: start + lengthForAnUnderLinePlusAGap * underlinet_ratio,
                                     y: posY))
            start += lengthForAnUnderLinePlusAGap
        }
        
        path.lineWidth = 1
        return path
    }
    
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        PathForFrame().stroke()
        ComputeLengthForUnderLinePlusGap()
        PathForUnderLines().stroke()
        DrawLetter()
        DrawHangMan()
    }
    
}
