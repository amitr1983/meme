//
//  MemeCollectionViewController.swift
//  Meme
//
//  Created by amit kumar on 7/8/18.
//  Copyright © 2018 amit kumar. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var MemeFlowLayout: UICollectionViewFlowLayout!
    
    @IBOutlet weak var memecollection: UICollectionView!

    var memes: [Meme]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space: CGFloat = 3.0
        
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        MemeFlowLayout?.minimumLineSpacing = space
        MemeFlowLayout?.minimumInteritemSpacing = space
        MemeFlowLayout?.itemSize = CGSize(width: dimension, height: dimension)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let memeObject = UIApplication.shared.delegate
        let appDelegate =  memeObject as! AppDelegate
        memes = appDelegate.memes
        collectionView!.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Counting")
        print(memes)
        print(memes.count)
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionCell", for: indexPath) as! MemeCollectionCell
        
        let savedMemeImage = memes[(indexPath as NSIndexPath).row]
        
        cell.memeImage?.image = savedMemeImage.memedImage
        
        return cell
    }
}
