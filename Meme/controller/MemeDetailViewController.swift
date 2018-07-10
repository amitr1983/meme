//
//  MemeDetailViewController.swift
//  Meme
//
//  Created by amit kumar on 7/9/18.
//  Copyright © 2018 amit kumar. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    @IBOutlet weak var memeDetailImageView: UIImageView!
    
    var memeDetails: Meme!
    
    override func viewWillAppear(_ animated: Bool) {
        self.memeDetailImageView?.image = memeDetails.memedImage
    }
    
    @IBAction func backBtnClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
