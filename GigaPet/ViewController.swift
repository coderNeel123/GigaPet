//
//  File.swift
//  GigaPet
//
//  Created by Neel Khattri on 7/23/16.
//  Copyright © 2016 SimpleStuff. All rights reserved.
//

//
//  ViewController.swift
//  GigaPet
//
//  Created by Neel Khattri on 7/22/16.
//  Copyright © 2016 SimpleStuff. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var monsterImage: MonsterImage!
    @IBOutlet weak var foodImage: DragImage!
    @IBOutlet weak var heartImage: DragImage!
    @IBOutlet weak var penaltyImage1: UIImageView!
    @IBOutlet weak var penaltyImage2: UIImageView!
    @IBOutlet weak var penaltyImage3: UIImageView!
    @IBOutlet weak var vegieImage: DragImage!
    @IBOutlet weak var restartButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    let dimAlpha: CGFloat = 0.2
    let opaque: CGFloat = 1.0
    let maxPenalties = 3
    var currentPenalties = 0
    var monsterHappy = false
    var currentItem: UInt32 = 0
    var imageValue = 0
    
    var timer: NSTimer!
    
    var musicPlayer: AVAudioPlayer!
    var biteSound: AVAudioPlayer!
    var heartSound: AVAudioPlayer!
    var deathSound: AVAudioPlayer!
    var skullSound: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        monsterImage.monsterAnimation()
        
         self.textField.delegate = self
        
        restartButton.hidden = true
        
        turnItemsOff()
        
        foodImage.dropTarget = monsterImage
        heartImage.dropTarget = monsterImage
        vegieImage.dropTarget = monsterImage
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.itemDroppedOnCharacter(_:)), name: "onTargetDropped", object: nil)
        
        penaltyImage1.alpha = dimAlpha
        penaltyImage2.alpha = dimAlpha
        penaltyImage3.alpha = dimAlpha
        
        
        let path = NSBundle.mainBundle().pathForResource("cave-music", ofType: "mp3")
        let soundUrl = NSURL(fileURLWithPath: path!)
        
        let path2 = NSBundle.mainBundle().pathForResource("bite", ofType: "wav")
        let soundUrl2 = NSURL(fileURLWithPath: path2!)
        
        let path3 = NSBundle.mainBundle().pathForResource("heart", ofType: "wav")
        let soundUrl3 = NSURL(fileURLWithPath: path3!)
        
        let path4 = NSBundle.mainBundle().pathForResource("death", ofType: "wav")
        let soundUrl4 = NSURL(fileURLWithPath: path4!)
        
        let path5 = NSBundle.mainBundle().pathForResource("skull", ofType: "wav")
        let soundUrl5 = NSURL(fileURLWithPath: path5!)
        
        do {
            try musicPlayer = AVAudioPlayer(contentsOfURL: soundUrl)
            musicPlayer.prepareToPlay()
            musicPlayer.play()
            
            try biteSound = AVAudioPlayer(contentsOfURL: soundUrl2)
            biteSound.prepareToPlay()
            
            try heartSound = AVAudioPlayer(contentsOfURL: soundUrl3)
            heartSound.prepareToPlay()
            
            try deathSound = AVAudioPlayer(contentsOfURL: soundUrl4)
            deathSound.prepareToPlay()
            
            try skullSound = AVAudioPlayer(contentsOfURL: soundUrl5)
            skullSound.prepareToPlay()
        } catch let error as NSError {
            print(error.debugDescription)
        }

    }
    
    func itemDroppedOnCharacter (notif: AnyObject) {
        if currentItem == 0 {
            heartSound.play()
        }
        else {
            biteSound.play()
        }
        
        monsterHappy = true
        startTimer()
        
        foodImage.alpha = dimAlpha
        heartImage.alpha = dimAlpha
        vegieImage.alpha = dimAlpha

        foodImage.userInteractionEnabled = false
        heartImage.userInteractionEnabled = false
        vegieImage.userInteractionEnabled = false

        
    }
    
    func startTimer () {
        if timer != nil {
            timer.invalidate()
        }
        
        timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: #selector(ViewController.changeGameState), userInfo: nil, repeats: true)
 
    }
    
    func changeGameState () {
        if !monsterHappy {
            
            currentPenalties+=1
            skullSound.play()
            
            if currentPenalties == 1 {
                penaltyImage1.alpha = opaque
                penaltyImage2.alpha = dimAlpha
                penaltyImage3.alpha = dimAlpha
            }
            else if currentPenalties == 2 {
                penaltyImage1.alpha = opaque
                penaltyImage2.alpha = opaque
                penaltyImage3.alpha = dimAlpha
            }
            else if currentPenalties == 3 {
                penaltyImage1.alpha = opaque
                penaltyImage2.alpha = opaque
                penaltyImage3.alpha = opaque
            }
            else {
                penaltyImage1.alpha = dimAlpha
                penaltyImage2.alpha = dimAlpha
                penaltyImage3.alpha = dimAlpha
            }
            
            
        }
        if currentPenalties >= maxPenalties {
            gameOver()
        }
        else {
            pickRandomImage()
        }
        
        
    }
    
    func gameOver() {
        timer.invalidate()
        
        if imageValue == 0 {
        monsterImage.monsterDeathAnimation()
        }
        else {
            monsterImage.deathAnimation()
        }
        
        turnItemsOff()
        deathSound.play()
        restartButton.hidden = false
    }
    
    func turnItemsOff () {
        foodImage.alpha = dimAlpha
        heartImage.alpha = dimAlpha
        vegieImage.alpha = dimAlpha
        foodImage.userInteractionEnabled = false
        heartImage.userInteractionEnabled = false
        vegieImage.userInteractionEnabled = false

    }
    
    func pickRandomImage () {
        let rand = arc4random_uniform(3)
        
        if rand == 0  {
            foodImage.alpha = dimAlpha
            foodImage.userInteractionEnabled = false
            heartImage.alpha = opaque
            heartImage.userInteractionEnabled = true
            vegieImage.alpha = dimAlpha
            vegieImage.userInteractionEnabled = false

        }
        else if rand == 1 {
            foodImage.alpha = dimAlpha
            foodImage.userInteractionEnabled = false
            heartImage.alpha = dimAlpha
            heartImage.userInteractionEnabled = false
            vegieImage.alpha = opaque
            vegieImage.userInteractionEnabled = true

        }
        else {
            foodImage.alpha = opaque
            foodImage.userInteractionEnabled = true
            heartImage.alpha = dimAlpha
            heartImage.userInteractionEnabled = false
            vegieImage.alpha = dimAlpha
            vegieImage.userInteractionEnabled = false

            
        }
        
        currentItem = rand
        
        monsterHappy = false
    }
    @IBAction func restartButtonClicked(sender: AnyObject) {
        restart()
    }
    
    func restart() {
        if imageValue == 0 {
            monsterImage.monsterAnimation()
            backgroundImage.image = UIImage(named: "bg")
        }
        else {
            monsterImage.idleAnimation()
            backgroundImage.image = UIImage(named: "earth")
        }

        currentPenalties = 0
        penaltyImage1.alpha = dimAlpha
        penaltyImage2.alpha = dimAlpha
        penaltyImage3.alpha = dimAlpha
        startTimer()
        pickRandomImage()
        monsterHappy = false
        restartButton.hidden = true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    func textFieldDidEndEditing(textField: UITextField){
            valueAndReturnOfTextField()
    }
    
    func valueAndReturnOfTextField() {
        if textField.text == "monster" {
            imageValue = 0
            monsterImage.monsterAnimation()
            backgroundImage.image = UIImage(named: "bg")
            print("hi")
        }
        else if textField.text == "monster " {
            imageValue = 0
            backgroundImage.image = UIImage(named: "bg")
            monsterImage.monsterAnimation()
        }
        else if textField.text == "Monster" {
            imageValue = 0
            backgroundImage.image = UIImage(named: "bg")
            monsterImage.monsterAnimation()
        }
        else if textField.text == "Monster " {
            imageValue = 0
            backgroundImage.image = UIImage(named: "bg")
            monsterImage.monsterAnimation()
        }
        else if textField.text == "Groundhog" {
            imageValue = 1
            backgroundImage.image = UIImage(named: "earth")
            monsterImage.idleAnimation()
        }
        else if textField.text == "groundhog" {
            imageValue = 1
            backgroundImage.image = UIImage(named: "earth")
            monsterImage.idleAnimation()
        }
        else if textField.text == "groundhog " {
            imageValue = 1
            backgroundImage.image = UIImage(named: "earth")
            monsterImage.idleAnimation()
        }
        else if textField.text == "Groundhog " {
            imageValue = 1
            backgroundImage.image = UIImage(named: "earth")
            monsterImage.idleAnimation()
        }
        else {
            imageValue = 0
            backgroundImage.image = UIImage(named: "bg")
            monsterImage.monsterAnimation()
        }
        
        textField.hidden = true
        textField.text = ""
        
        startTimer()
        pickRandomImage()

    }
    
}



