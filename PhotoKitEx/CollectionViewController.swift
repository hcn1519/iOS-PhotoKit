//
//  CollectionViewController.swift
//  PhotoKitEx
//
//  Created by 홍창남 on 2017. 2. 15..
//  Copyright © 2017년 홍창남. All rights reserved.
//

import UIKit
import Photos

class CollectionViewController: UICollectionViewController {
    
    var assetsFetchResults: PHFetchResult<PHAsset> = PHFetchResult<PHAsset>()
    var imageManger: PHCachingImageManager!
    
    override func viewDidLoad() {
        PHPhotoLibrary.requestAuthorization() {(status) in switch status {
        case .authorized:
            self.imageManger = PHCachingImageManager()
            let options = PHFetchOptions()
            options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
            self.assetsFetchResults = PHAsset.fetchAssets(with: options)
            self.collectionView?.reloadData()
        default:
            NSLog("사진에 접근할 수 없습니다.")
            }
            
        }
    }
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.assetsFetchResults.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! CollectionViewCell
        
        let asset: PHAsset = self.assetsFetchResults[indexPath.item]
        self.imageManger.requestImage(for: asset, targetSize: cell.frame.size, contentMode: PHImageContentMode.aspectFit, options: nil, resultHandler: { (result: UIImage?, info: [AnyHashable: Any]?) in
            cell.imageView.image = result
            })
        
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = self.collectionView?.indexPath(for: sender as! CollectionViewCell)
        (segue.destination as! ViewController).asset = self.assetsFetchResults[indexPath!.row]
    }
}
