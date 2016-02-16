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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mailboxScrollView.delegate = self
        mailboxScrollView.contentSize = CGSize(width: 320, height: 1420)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
