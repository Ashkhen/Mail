//
//  MailboxViewController.swift
//  Mail
//
//  Created by Ashkhen Sargsyan on 2/16/16.
//  Copyright © 2016 Ashkhen Sargsyan. All rights reserved.
//

import UIKit

let MAX_MENU_WIDTH: CGFloat = 280

class MailboxViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var mailboxScrollView: UIScrollView!
    @IBOutlet weak var feedImageView: UIImageView!
    @IBOutlet weak var rightIconImageView: UIImageView!
    @IBOutlet weak var leftIconImageView: UIImageView!
    @IBOutlet weak var messageImageView: UIImageView!
    @IBOutlet weak var listImageView: UIImageView!
    @IBOutlet weak var rescheduleView: UIImageView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var singleMessageView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var menuVIew: UIView!
    @IBOutlet weak var composeView: UIView!
    @IBOutlet weak var archiveLaterView: UIView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    var initialCenter: CGPoint!
    var initialCenterLaterIcon: CGPoint!
    var initialCenterArchiveIcon: CGPoint!
    
    enum Command {
        case Noop
        case Archive
        case Delete
        case RemindLater
        case List
    }

    var command: Command = .Noop

    @IBAction func onSegmentChange(sender: AnyObject) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
                UIView.animateWithDuration(0.4) { () -> Void in
                    self.archiveLaterView.hidden = false
                    self.view.bringSubviewToFront(self.archiveLaterView)
                    self.menuVIew.hidden = true

                    self.archiveLaterView.frame = CGRect(x: 0,
                            y: self.archiveLaterView.frame.origin.y,
                            width: self.archiveLaterView.frame.size.width,
                            height: self.archiveLaterView.frame.size.height)
                }
        case 2:
            UIView.animateWithDuration(0.4) { () -> Void in
                self.archiveLaterView.hidden = false
                self.view.bringSubviewToFront(self.archiveLaterView)
                self.menuVIew.hidden = true

                self.archiveLaterView.frame = CGRect(x: 0,
                        y: self.archiveLaterView.frame.origin.y,
                        width: self.archiveLaterView.frame.size.width,
                        height: self.archiveLaterView.frame.size.height)
            }
        default:
            self.archiveLaterView.frame = CGRect(x: -320,
                    y: self.archiveLaterView.frame.origin.y,
                    width: self.archiveLaterView.frame.size.width,
                    height: self.archiveLaterView.frame.size.height)

            UIView.animateWithDuration(0.4) { () -> Void in
                self.archiveLaterView.hidden = true
                self.view.sendSubviewToBack(self.archiveLaterView)
                self.menuVIew.hidden = false
            }
        }
    }
    
    @IBAction func onCancel(sender: AnyObject) {
        UIView.animateWithDuration(0.3) { () -> Void in
            self.composeView.alpha = 0
        }
    }
    
    @IBAction func onComposeTap(sender: AnyObject) {
        UIView.animateWithDuration(0.3) { () -> Void in
            self.composeView.alpha = 1
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.archiveLaterView.frame = CGRect(x: -320,
                y: self.archiveLaterView.frame.origin.y,
                width: self.archiveLaterView.frame.size.width,
                height: self.archiveLaterView.frame.size.height)

        mailboxScrollView.delegate = self
        mailboxScrollView.contentSize = CGSize(width: 320, height: 1420)

        rightIconImageView.alpha = 0
        leftIconImageView.alpha = 0
        listImageView.alpha = 0
        rescheduleView.alpha = 0

        let tapGesture = UITapGestureRecognizer(target: self, action: "onRescheduleViewTap")
        self.rescheduleView.addGestureRecognizer(tapGesture)
        
        let listImageViewtapGesture = UITapGestureRecognizer(target: self, action: "onListImageViewTap")
        self.listImageView.addGestureRecognizer(listImageViewtapGesture)
        
        let mainViewTapGesture = UITapGestureRecognizer(target: self, action: "reset")
        self.mainView.addGestureRecognizer(mainViewTapGesture)
        
        let edgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: "onEdgePan:")
        edgeGesture.edges = UIRectEdge.Left
        mainView.addGestureRecognizer(edgeGesture)
        
        initialCenter = messageImageView.center
        initialCenterLaterIcon = rightIconImageView.center
        initialCenterArchiveIcon = leftIconImageView.center

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if(event!.subtype == UIEventSubtype.MotionShake) {
            self.reset()
        }
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.becomeFirstResponder()
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    func reset() {
        self.messageImageView.frame = CGRect(x: 0, y: self.messageImageView.frame.origin.y, width: self.messageImageView.frame.size.width, height: self.messageImageView.frame.size.height)
        self.singleMessageView.frame = CGRect(x: 0, y: self.singleMessageView.frame.origin.y, width: self.singleMessageView.frame.size.width, height: self.singleMessageView.frame.size.height)
        self.feedImageView.frame = CGRect(x: self.feedImageView.frame.origin.x, y: self.singleMessageView.frame.size.height, width: self.feedImageView.frame.size.width, height: self.feedImageView.frame.size.height)
        self.mainView.frame = CGRect(origin: CGPoint(x: 0, y: self.mainView.frame.origin.y), size: self.mainView.frame.size)
        self.rightIconImageView.center = initialCenterLaterIcon
        self.leftIconImageView.center = initialCenterArchiveIcon
    }
    
    func onEdgePan(sender: UIScreenEdgePanGestureRecognizer) {
        let velocity = sender.velocityInView(view)
        let mainViewFrame = self.mainView.frame
        
        if sender.state == .Changed {
            var x = self.mainView.frame.origin.x + (velocity.x)/50
            if x < 0 {
                x = 0
            }
            if x > MAX_MENU_WIDTH {
                x = MAX_MENU_WIDTH
            }
            self.mainView.frame = CGRect(origin: CGPoint(x: x, y: mainViewFrame.origin.y), size: mainViewFrame.size)
            
        } else if sender.state == .Ended {
            let x = velocity.x > 0 ? MAX_MENU_WIDTH : 0
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.mainView.frame = CGRect(origin: CGPoint(x: x, y: mainViewFrame.origin.y), size: mainViewFrame.size)
            })
        }
    
    }
    
    func onRescheduleViewTap() {
        let newFeedImageFrame = CGRect(x: self.feedImageView.frame.origin.x, y: self.singleMessageView.frame.origin.y, width: self.feedImageView.frame.size.width, height: self.feedImageView.frame.size.height)
        self.rescheduleView.alpha = 0
        UIView.animateWithDuration(0.4) {
            () -> Void in
            self.feedImageView.frame = newFeedImageFrame
        }
    }
    
    func onListImageViewTap() {
        let newFeedImageFrame = CGRect(x: self.feedImageView.frame.origin.x, y: self.singleMessageView.frame.origin.y, width: self.feedImageView.frame.size.width, height: self.feedImageView.frame.size.height)
        self.listImageView.alpha = 0
        UIView.animateWithDuration(0.4) {
            () -> Void in
            self.feedImageView.frame = newFeedImageFrame
        }

    }

    @IBAction func onMessagePan(sender: UIPanGestureRecognizer) {
        let translation = sender.translationInView(view)
        let velocity = sender.velocityInView(view)

        if sender.state == UIGestureRecognizerState.Changed {
            messageImageView.center.x = translation.x + initialCenter.x
            rightIconImageView.center.x = translation.x + initialCenterLaterIcon.x + 35
            leftIconImageView.center.x = translation.x + initialCenterArchiveIcon.x - 35

            // when panning left.
            if velocity.x < 0 {
                if translation.x >= -60 && translation.x < 0 {
                    // Grey
                    self.backgroundView.backgroundColor = UIColor.init(hexString: "bfbfbf")
                    UIView.animateWithDuration(0.1, animations: {
                        () -> Void in
                        if translation.x <= 30 {
                            UIView.animateWithDuration(0.1, animations: {
                                () -> Void in
                                self.rightIconImageView.alpha = 1
                                self.rightIconImageView.image = UIImage(named: "later_icon")
                            })
                        }
                    })
                } else if translation.x <= -60 && translation.x > -220 {
                    command = .RemindLater
                    UIView.animateWithDuration(0.1, animations: {
                        () -> Void in
                        // Yellow
                        self.backgroundView.backgroundColor = UIColor.init(hexString: "ffd320")
                        self.rightIconImageView.alpha = 1
                    })
                } else if translation.x < -220 {
                    command = .List
                    UIView.animateWithDuration(0.1, animations: {
                        () -> Void in
                        // Brown
                        self.backgroundView.backgroundColor = UIColor.init(hexString: "d8a675")
                        self.rightIconImageView.alpha = 1
                        self.rightIconImageView.image = UIImage(named: "list_icon")
                    })
                }
            }
            // when panning right.
            if velocity.x > 0 {
                if translation.x > 0 && translation.x < 60 {
                    UIView.animateWithDuration(0.1, animations: {
                        () -> Void in
                        // Grey
                        self.backgroundView.backgroundColor = UIColor.init(hexString: "bfbfbf")
                        UIView.animateWithDuration(0.1, animations: {
                            () -> Void in
                            self.leftIconImageView.alpha = 1
                            self.leftIconImageView.image = UIImage(named: "archive_icon")
                        })
                    })
                } else if translation.x > 60 && translation.x < 260 {
                    command = .Archive
                    UIView.animateWithDuration(0.1, animations: {
                        () -> Void in
                        // Green
                        self.backgroundView.backgroundColor = UIColor.init(hexString: "62d962")
                        self.leftIconImageView.alpha = 1
                    })
                } else if translation.x > 260 {
                    command = .Delete
                    UIView.animateWithDuration(0.1, animations: {
                        () -> Void in
                        // Red
                        self.backgroundView.backgroundColor = UIColor.init(hexString: "ef540c")
                        self.leftIconImageView.image = UIImage(named: "delete_icon")
                    })
                }
            }
        } else if sender.state == UIGestureRecognizerState.Ended {
            if command == .Archive {
                let newMessageFrame = CGRect(x: 320, y: self.messageImageView.frame.origin.y, width: self.messageImageView.frame.size.width, height: self.messageImageView.frame.size.height)
                let newFeedImageFrame = CGRect(x: self.feedImageView.frame.origin.x, y: self.singleMessageView.frame.origin.y, width: self.feedImageView.frame.size.width, height: self.feedImageView.frame.size.height)
                self.leftIconImageView.alpha = 0
                
                UIView.animateWithDuration(0.4, animations: {
                    () -> Void in
                    self.backgroundView.backgroundColor = UIColor.init(hexString: "62d962")
                    self.messageImageView.frame = newMessageFrame
                }, completion: {
                    (complete) -> Void in
                    UIView.animateWithDuration(0.4, animations: {
                        () -> Void in
                        self.feedImageView.frame = newFeedImageFrame
                    })
                })

            } else if command == .RemindLater {
                let newMessageFrame = CGRect(x: -320, y: self.messageImageView.frame.origin.y, width: self.messageImageView.frame.size.width, height: self.messageImageView.frame.size.height)
                self.rightIconImageView.alpha = 0
                
                UIView.animateWithDuration(0.4, animations: {
                    () -> Void in
                    self.backgroundView.backgroundColor = UIColor.init(hexString: "ffd320")
                    self.messageImageView.frame = newMessageFrame
                }, completion: {
                    (complete) -> Void in
                    self.rescheduleView.alpha = 1
                })
            } else if command == .List {
                let newMessageFrame = CGRect(x: -320, y: self.messageImageView.frame.origin.y, width: self.messageImageView.frame.size.width, height: self.messageImageView.frame.size.height)
                self.rightIconImageView.alpha = 0
                
                UIView.animateWithDuration(0.4, animations: {
                    () -> Void in
                    self.backgroundView.backgroundColor = UIColor.init(hexString: "d8a675")
                    self.messageImageView.frame = newMessageFrame
                    }, completion: {
                        (complete) -> Void in
                        self.listImageView.alpha = 1
                })
            } else if command == .Delete {
                let newMessageFrame = CGRect(x: 320, y: self.messageImageView.frame.origin.y, width: self.messageImageView.frame.size.width, height: self.messageImageView.frame.size.height)
                let newFeedImageFrame = CGRect(x: self.feedImageView.frame.origin.x, y: self.singleMessageView.frame.origin.y, width: self.feedImageView.frame.size.width, height: self.feedImageView.frame.size.height)
                self.leftIconImageView.alpha = 0
                
                UIView.animateWithDuration(0.4, animations: {
                    () -> Void in
                    self.backgroundView.backgroundColor = UIColor.init(hexString: "ef540c")
                    self.messageImageView.frame = newMessageFrame
                     self.leftIconImageView.image = UIImage(named: "delete_icon")
                    }, completion: {
                        (complete) -> Void in
                        UIView.animateWithDuration(0.4, animations: {
                            () -> Void in
                            self.feedImageView.frame = newFeedImageFrame
                        })
                })
            } else {
                self.leftIconImageView.alpha = 0
                UIView.animateWithDuration(0.5, animations: {
                    () -> Void in
                    self.backgroundView.backgroundColor = UIColor.init(hexString: "bfbfbf")
                    self.messageImageView.center.x = self.initialCenter.x
                    self.rightIconImageView.center.x = self.initialCenterLaterIcon.x
                    self.rightIconImageView.alpha = 0

                    self.leftIconImageView.center.x = self.initialCenterArchiveIcon.x
        
                })
            }
        }
    }
}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.stringByTrimmingCharactersInSet(NSCharacterSet.alphanumericCharacterSet().invertedSet)
        var int = UInt32()
        NSScanner(string: hex).scanHexInt(&int)
        let a, r, g, b: UInt32
        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

