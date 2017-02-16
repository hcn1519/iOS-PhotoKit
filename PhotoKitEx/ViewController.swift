//
//  ViewController.swift
//  PhotoKitEx
//
//  Created by 홍창남 on 2017. 2. 15..
//  Copyright © 2017년 홍창남. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var asset: PHAsset?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let effectBtn: UIBarButtonItem = UIBarButtonItem(title: "효과", style: UIBarButtonItemStyle.plain, target: self, action: #selector(applyEffect))
        
        if self.asset!.mediaType == PHAssetMediaType.image {
            self.navigationItem.rightBarButtonItem = effectBtn
        }
        showImage()
    }
    func showImage() {
        let scale = UIScreen.main.scale
        let size = CGSize(width: self.imageView.bounds.width * scale, height: self.imageView.bounds.height * scale)
        let _ = PHImageManager.default().requestImage(for: self.asset!, targetSize: size, contentMode: PHImageContentMode.aspectFit, options: nil, resultHandler: {(result: UIImage?, info: [AnyHashable: Any]?) in
            self.imageView.image = result
            })
    }
    func applyEffect() {
        // 버튼 클릭시 일어나는 action 연결
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Mono", style: UIAlertActionStyle.default, handler: {(action: UIAlertAction) in
        self.applyFilter("CIPhotoEffectMono")
        }))
        alertController.addAction(UIAlertAction(title: "Instant", style: UIAlertActionStyle.default, handler: {(action: UIAlertAction) in self.applyFilter("CIPhotoEffectInstant")
        }))
        alertController.modalPresentationStyle = UIModalPresentationStyle.popover
        
        self.present(alertController, animated: true, completion: nil)
    }
    func applyFilter(_ filterName: String) {
        self.asset?.requestContentEditingInput(with: nil, completionHandler: {(contentInput: PHContentEditingInput?, _: [AnyHashable: Any]?) in DispatchQueue.global().async(execute: { () in
            
            let url = contentInput?.fullSizeImageURL
            let orientation = contentInput?.fullSizeImageOrientation
            var inputImg = CIImage(contentsOf: url!)
            inputImg = inputImg?.applyingOrientation(orientation!)
            
            let filter = CIFilter(name: filterName)
            filter?.setDefaults()
            filter?.setValue(inputImg, forKey: kCIInputImageKey)
            let outputImg = filter?.outputImage
            
            let context = CIContext()
            let image = context.createCGImage(outputImg!, from: outputImg!.extent)
            let uiImage = UIImage(cgImage: image!)
            
            let contentOutput = PHContentEditingOutput(contentEditingInput: contentInput!)
            let renderedData = UIImageJPEGRepresentation(uiImage, 0.9)
            
            if (((try? renderedData?.write(to: contentOutput.renderedContentURL, options: [.atomic])) != nil) != nil) {
                let archiveData = NSKeyedArchiver.archivedData(withRootObject: filterName)
                let adjData = PHAdjustmentData(formatIdentifier: "com.gbustudio.photo", formatVersion: "1.0", data: archiveData)
                contentOutput.adjustmentData = adjData
                
                PHPhotoLibrary.shared().performChanges({
                    let request = PHAssetChangeRequest(for: self.asset!)
                    request.contentEditingOutput = contentOutput }, completionHandler: {(success: Bool, error: Error?) in
                        if success {
                            self.showImage()
                        }
                    })
            }
            
        })})
    }
}

