//
//  MemeTableViewController.swift
//  Meme
//
//  Created by amit kumar on 7/8/18.
//  Copyright © 2018 amit kumar. All rights reserved.
//

import UIKit

// Viewcontroller for showing images and text in table view
class MemeTableViewController: UITableViewController {
    
    @IBOutlet var memetableView: UITableView!
    
    var memes: [Meme]!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Fetch shared data
        let memeObject = UIApplication.shared.delegate as! AppDelegate
        memes = memeObject.memes
        
        // Reload table data
        tableView!.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(memes)
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let memeImage = memes[(indexPath as NSIndexPath).row]
        let cell = memetableView.dequeueReusableCell(withIdentifier: "MemeTableCell") as! MemeTableCell
        cell.tableCellImage?.image = memeImage.memedImage
        cell.topLabel?.text = memeImage.topText
        cell.bottomLabel?.text = memeImage.bottomText
        
        return cell
    }
    
    // Trigger action when select a row in table view
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let memeDetailVC = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        let object = UIApplication.shared.delegate as! AppDelegate
        let memeDetail = object.memes[indexPath.item]
        memeDetailVC.memeDetails = memeDetail
        
        show(memeDetailVC, sender: self)
    }

}
