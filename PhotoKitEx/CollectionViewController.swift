//
//  CollectionViewController.swift
//  PhotoKitEx
//
//  Created by 홍창남 on 2017. 2. 15..
//  Copyright © 2017년 홍창남. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! CollectionViewCell
        let image = UIImage(named: "0\(indexPath.row + 1).jpeg")
        cell.imageView.image = image
        
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        (segue.destination as! ViewController).image = (sender as! CollectionViewCell).imageView.image!
    }
}
