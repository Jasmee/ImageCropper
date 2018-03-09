//
//  CroppedImageViewController.swift
//  ImageCropper
//
//  Created by Jasmee Sengupta on 09/03/18.
//  Copyright © 2018 Jasmee Sengupta. All rights reserved.
//  //try to save image in cropped ratio, not 300x300 uiimageview fixed size

import Foundation
import UIKit
import CoreImage

class CroppedImageViewController: UIViewController {
    
    @IBOutlet weak var croppedImageView : UIImageView!
    var croppedImage: UIImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.croppedImageView.image = croppedImage
    }
    
    @IBAction func cropAgainTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func SaveToAlbum(sender: AnyObject) {
        UIImageWriteToSavedPhotosAlbum(croppedImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if error != nil {
            let alert = UIAlertController(title: "Oops!", message: "Could not save image to photo album", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
        } else {
            print("Image saved successfully")
        }
    }
    
}
