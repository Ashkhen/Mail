//
//  MailboxViewController.swift
//  Mail
//
//  Created by Ashkhen Sargsyan on 2/16/16.
//  Copyright © 2016 Ashkhen Sargsyan. All rights reserved.
//

import UIKit

class MailboxViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var mailboxScrollView: UIScrollView!
    @IBOutlet weak var feedImageView: UIImageView!
    @IBOutlet weak var rightIconImageView: UIImageView!
    @IBOutlet weak var leftIconImageView: UIImageView!
    @IBOutlet weak var messageImageView: UIImageView!
    @IBOutlet weak var listImageView: UIImageView!
    @IBOutlet weak var rescheduleView: UIImageView!
    @IBOutlet weak var backgroundView: UIView!

    var initialCenter: CGPoint!
    var initialCenterLaterIcon: CGPoint!
    var initialCenterArchiveIcon: CGPoint!

    override func viewDidLoad() {
        super.viewDidLoad()

        mailboxScrollView.delegate = self
        mailboxScrollView.contentSize = CGSize(width: 320, height: 1420)

        rightIconImageView.alpha = 0
        leftIconImageView.alpha = 0
        listImageView.alpha = 0

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func onMessagePan(sender: UIPanGestureRecognizer) {
        var location = sender.locationInView(view)
        var translation = sender.translationInView(view)
        var velocity = sender.velocityInView(view)

        if sender.state == UIGestureRecognizerState.Began {
            initialCenter = messageImageView.center
            initialCenterLaterIcon = rightIconImageView.center
            initialCenterArchiveIcon = leftIconImageView.center

        } else if sender.state == UIGestureRecognizerState.Changed {
            messageImageView.center.x = translation.x + initialCenter.x
            rightIconImageView.center.x = translation.x + initialCenterLaterIcon.x + 35
            leftIconImageView.center.x = translation.x + initialCenterArchiveIcon.x - 35

            let messageCenter = CGFloat(messageImageView.center.x)

            if velocity.x < 0 {
                if translation.x >= -60 && translation.x < 0 {
                    self.backgroundView.backgroundColor = UIColor.init(hexString: "bfbfbf")
                    UIView.animateWithDuration(0.5, animations: {
                        () -> Void in
                        if translation.x <= 30 {
                            UIView.animateWithDuration(1.5, animations: {
                                () -> Void in
                                self.rightIconImageView.alpha = 1
                            })
                        }
                    })
                } else if translation.x <= -60 && translation.x > -220 {
                    UIView.animateWithDuration(0.5, animations: {
                        () -> Void in
                        self.backgroundView.backgroundColor = UIColor.init(hexString: "ffd320")
                        self.rightIconImageView.alpha = 1

                    })
                } else if translation.x < -220 {
                    UIView.animateWithDuration(0.5, animations: {
                        () -> Void in
                        self.backgroundView.backgroundColor = UIColor.init(hexString: "d8a675")
                        self.rightIconImageView.alpha = 1
                    })
                }
            }

            if velocity.x > 0 {
                if translation.x > 0 && translation.x < 60 {
                    UIView.animateWithDuration(0.5, animations: {
                        () -> Void in
                        self.backgroundView.backgroundColor = UIColor.init(hexString: "bfbfbf")
                        UIView.animateWithDuration(0.4, animations: {
                            () -> Void in
                            self.leftIconImageView.alpha = 1
                        })
                    })
                } else if translation.x > 60 && translation.x < 220 {
                    UIView.animateWithDuration(0.5, animations: {
                        () -> Void in
                        self.backgroundView.backgroundColor = UIColor.init(hexString: "62d962")
                        self.leftIconImageView.alpha = 1
                    })
                } else if translation.x > 220 {
                    UIView.animateWithDuration(0.5, animations: {
                        () -> Void in
                        self.backgroundView.backgroundColor = UIColor.init(hexString: "ef540c")
                        self.rightIconImageView.alpha = 1
                    })
                }
            }
//            if translation.x >= -60 && translation.x < 0 {
//                self.backgroundView.backgroundColor = UIColor.init(hexString: "bfbfbf")
//                UIView.animateWithDuration(0.5, animations: {
//                    () -> Void in
//                    if translation.x <= -30 {
//                        UIView.animateWithDuration(1.5, animations: {
//                            () -> Void in
//                            self.laterIconImageView.alpha = 1
//                        })
//                    }
//
//                })
//            } else if translation.x > 0 && translation.x < 60 {
//                print(translation)
//                UIView.animateWithDuration(0.5, animations: {
//                    () -> Void in
//                    self.backgroundView.backgroundColor = UIColor.init(hexString: "bfbfbf")
//                    UIView.animateWithDuration(0.4, animations: {
//                        () -> Void in
//                        self.archiveIconImageView.alpha = 1
//
//                    })
//                })
//            } else if translation.x <= -60 && translation.x > -220 {
//                UIView.animateWithDuration(0.5, animations: {
//                    () -> Void in
//                    self.backgroundView.backgroundColor = UIColor.init(hexString: "ffd320")
//                    self.laterIconImageView.alpha = 1
//
//                })
//            } else if translation.x < -220 {
//                UIView.animateWithDuration(0.5, animations: {
//                    () -> Void in
//                    self.backgroundView.backgroundColor = UIColor.init(hexString: "d8a675")
//                    self.laterIconImageView.alpha = 1
//
//                })
//            } else if translation.x > 60 && translation.x < 220 {
//                UIView.animateWithDuration(0.5, animations: { () -> Void in
//                    self.backgroundView.backgroundColor = UIColor.init(hexString: "62d962")
//                    self.archiveIconImageView.alpha = 1
//                })
//            } else if translation.x > 220 {
//                UIView.animateWithDuration(0.5, animations: {
//                    () -> Void in
//                    self.backgroundView.backgroundColor = UIColor.init(hexString: "ef540c")
//                    self.laterIconImageView.alpha = 1
//
//                })
//            }
        } else if sender.state == UIGestureRecognizerState.Ended {
            UIView.animateWithDuration(0.5, animations: {
                () -> Void in
                self.backgroundView.backgroundColor = UIColor.init(hexString: "bfbfbf")
                self.messageImageView.center.x = self.initialCenter.x
                self.rightIconImageView.center.x = self.initialCenterLaterIcon.x
                self.rightIconImageView.alpha = 0

                self.leftIconImageView.center.x = self.initialCenterArchiveIcon.x
                self.leftIconImageView.alpha = 0
            })
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

