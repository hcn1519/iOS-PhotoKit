//
//  ViewController.swift
//  PhotoKitEx
//
//  Created by 홍창남 on 2017. 2. 15..
//  Copyright © 2017년 홍창남. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var image: UIImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = image
        
        let effectBtn: UIBarButtonItem = UIBarButtonItem(title: "효과", style: UIBarButtonItemStyle.plain, target: self, action: #selector(applyEffect))
        self.navigationItem.rightBarButtonItem = effectBtn
    }
    func applyEffect() {
        // 버튼 클릭시 일어나는 action 연결
    }
}

