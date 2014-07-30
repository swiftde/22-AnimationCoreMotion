//
//  ViewController.swift
//  Animator-Tutorial
//
//  Created by Benjamin Herzog on 30.07.14.
//  Copyright (c) 2014 Benjamin Herzog. All rights reserved.
//

import UIKit
import CoreMotion

var MAX_X = 0
var MAX_Y = 0
let BOX_SIZE: CGFloat = 15
let NUMBER_OF_BOXES = 80

class ViewController: UIViewController {
    
    var boxes = [UIView]()
    
    var animator: UIDynamicAnimator?
    let gravity = UIGravityBehavior()
    let collider = UICollisionBehavior()
    let itemBehavior = UIDynamicItemBehavior()
    
    let motionQueue = NSOperationQueue()
    let motionManager = CMMotionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MAX_X = view.bounds.size.width - BOX_SIZE
        MAX_Y = view.bounds.size.height - BOX_SIZE
        
        createAnimator()
        generateBoxes(NUMBER_OF_BOXES)
    }
    
    func createAnimator() {
        
        animator = UIDynamicAnimator(referenceView: view)
        gravity.gravityDirection = CGVectorMake(0, 0.8)
        animator?.addBehavior(gravity)
        
        collider.translatesReferenceBoundsIntoBoundary = true
        animator?.addBehavior(collider)
        
        itemBehavior.friction = 0.3
        itemBehavior.elasticity = 0.6
        animator?.addBehavior(itemBehavior)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        motionManager.startDeviceMotionUpdatesToQueue(motionQueue, withHandler: {
            motion,error in
            
            if error {
                println("Error: \(error.localizedDescription)")
                return
            }
            
            let grav = motion.gravity
            
            let x = CGFloat(grav.x)
            let y = CGFloat(grav.y)
            var p = CGPoint(x: x, y: y)
            
            var orientation = UIApplication.sharedApplication().statusBarOrientation
            
            switch orientation {
            case .LandscapeLeft:
                var t = p.x
                p.x = 0 - p.y
                p.y = t
            case .LandscapeRight:
                var t = p.x
                p.x = p.y
                p.y = 0 - t
            case .PortraitUpsideDown:
                p.x *= -1
                p.x *= -1
            default: break
            }
            
            self.gravity.gravityDirection = CGVectorMake(p.x, 0 - p.y)
            
            })
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        motionManager.stopDeviceMotionUpdates()
    }
    
    func generateBoxes(number: Int) {
        for i in 0..<number {
            let newBox = UIView(frame: randomRect())
            newBox.backgroundColor = UIColor.randomColor()
            view.addSubview(newBox)
            gravity.addItem(newBox)
            collider.addItem(newBox)
            itemBehavior.addItem(newBox)
            boxes += newBox
        }
    }
    
    func randomRect() -> CGRect {
        var ret = CGRect(x: 0, y: 0, width: BOX_SIZE, height: BOX_SIZE)
        
        do {
            let x = Int(rand()) % MAX_X
            let y = Int(rand()) % MAX_Y
            ret = CGRect(x: CGFloat(x), y: CGFloat(y), width: BOX_SIZE, height: BOX_SIZE)
        } while(!doesNotCollide(ret))
        
        return ret
    }
    
    func doesNotCollide(rect: CGRect) -> Bool {
        for box in boxes {
            if(CGRectIntersectsRect(box.frame, rect)) {
                return false
            }
        }
        return true
    }
}


extension UIColor {
    
    class func randomColor() -> UIColor {
        let redValue = Float(rand() % 255) / 255
        let greenValue = Float(rand() % 255) / 255
        let blueValue = Float(rand() % 255) / 255
        
        return UIColor(red: CGFloat(redValue), green: CGFloat(greenValue), blue: CGFloat(blueValue), alpha: 1)
    }
    
}
















