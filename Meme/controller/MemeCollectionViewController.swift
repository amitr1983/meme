//
//  MemeCollectionViewController.swift
//  Meme
//
//  Created by amit kumar on 7/8/18.
//  Copyright © 2018 amit kumar. All rights reserved.
//

import UIKit

// Viewcontroller for showing image tiles in collection view
class MemeCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var MemeFlowLayout: UICollectionViewFlowLayout!

    var memes: [Meme]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Create object for shared data
        let memeObject = UIApplication.shared.delegate as! AppDelegate
        memes = memeObject.memes
        
        // Reload the content of table
        collectionView!.reloadData()
        
        // Set spacing & dimension for collection tiles in both portrait and landscape view
        setDimension()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(memes.count)
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionCell", for: indexPath) as! MemeCollectionCell

        // Get memes detailed based on index number
        let savedMemeImage = memes[(indexPath as NSIndexPath).row]
        // Fetch and set image for imageview
        cell.memeImage?.image = savedMemeImage.memedImage
        
        return cell
    }
    
    // Trigger action when select a tile in collection view
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let memeDetailVC = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        let object = UIApplication.shared.delegate as! AppDelegate
        let memeDetail = object.memes[indexPath.item]
        memeDetailVC.memeDetails = memeDetail

        navigationController?.pushViewController(memeDetailVC, animated: true)
    }
    
    // Set spacing & dimension for collection tiles in both portrait and landscape view
    func setDimension() {
        let space: CGFloat = 3.0
        
        var dimension: CGFloat
        
        if UIDevice.current.orientation.isLandscape {
            print("landscape")
            dimension = (view.frame.size.height - (4 * space)) / 5.0
        } else {
            print("portrait")
            dimension = (view.frame.size.width - (2 * space)) / 3.0
        }
        
        MemeFlowLayout?.minimumLineSpacing = space
        MemeFlowLayout?.minimumInteritemSpacing = space
        MemeFlowLayout?.itemSize = CGSize(width: dimension, height: dimension)
    }
}
