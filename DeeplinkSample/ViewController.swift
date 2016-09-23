//
//  ViewController.swift
//  DeeplinkSample
//
//  Created by Akash Gupta on 9/21/16.
//  Copyright © 2016 ThoughtWorks. All rights reserved.
//

import UIKit

class ViewController: UIViewController, DeepLinkDelegate {

    @IBOutlet weak var golfHole: UIImageView!
    @IBOutlet weak var golfBall: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.backgroundColor = UIColor.init(patternImage: #imageLiteral(resourceName: "grass.jpg"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DeepLinkManager.sharedInstance.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    private func resetGolfBall() {
        var frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        frame = frame.offsetBy(dx: view.frame.size.width / 2 - 40, dy: -80)
        golfBall.frame = frame
        golfBall.alpha = 1.0
    }
    
    private func golfPutt() {
        
        resetGolfBall()
        self.messageLabel.isHidden = true
        
        UIView.animateKeyframes(withDuration: 3.0, delay: 0.0, options: .calculationModeLinear, animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.7, animations: { 
                self.golfBall.center = self.golfHole.center
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.7, relativeDuration: 1.0, animations: {
                self.golfBall.frame = self.golfBall.frame.insetBy(dx: 40, dy: 40)
                self.golfBall.alpha = 0.0
            })
            
            }) { (finished) in
                self.messageLabel.isHidden = false
        }
    }

    func handleDeepLink() {
        golfPutt()
    }
}

