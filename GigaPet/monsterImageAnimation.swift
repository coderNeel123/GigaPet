//
//  monsterImageAnimation.swift
//  GigaPet
//
//  Created by Neel Khattri on 7/23/16.
//  Copyright © 2016 SimpleStuff. All rights reserved.
//

import Foundation
import UIKit

class MonsterImage: UIImageView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
       idleAnimation()
    }

    func idleAnimation () {

        self.image = UIImage(named:"idle1.png")
        self.animationImages = nil
    
        var imageArray = [UIImage]()
        for var x = 1; x<=4; x += 1 {
        let img = UIImage(named: "idle\(x).png")
        imageArray.append(img!)
    }
    
    //Animating the monster image
    
    self.animationImages = imageArray
    self.animationDuration = 0.8
    self.animationRepeatCount = 0
    self.startAnimating()

}
    
    func monsterAnimation () {
            self.image = UIImage(named:"monster1.png")
            self.animationImages = nil
            
            var imageArray = [UIImage]()
            for var x = 1; x<=4; x += 1 {
                let img = UIImage(named: "monster\(x).png")
                imageArray.append(img!)
            }
            
            //Animating the monster image
            
            self.animationImages = imageArray
            self.animationDuration = 0.8
            self.animationRepeatCount = 0
            self.startAnimating()
        }
            
    
    func deathAnimation () {
            self.image = UIImage(named:"hide6")
            self.animationImages = nil
            
            
            var imageArray = [UIImage]()
            for var x = 1; x<=6; x += 1 {
                let img = UIImage(named: "hide\(x).png")
                imageArray.append(img!)
            }
            //Animating the monster image
            
            self.animationImages = imageArray
            self.animationDuration = 0.8
            self.animationRepeatCount = 1
            self.startAnimating()
        
    }
    func monsterDeathAnimation () {
            self.image = UIImage(named:"dead5")
            self.animationImages = nil
            
            
            var imageArray = [UIImage]()
            for var x = 1; x<=5; x += 1 {
                let img = UIImage(named: "dead\(x).png")
                imageArray.append(img!)
            }
            //Animating the monster image
            
            self.animationImages = imageArray
            self.animationDuration = 0.8
            self.animationRepeatCount = 1
        }
}