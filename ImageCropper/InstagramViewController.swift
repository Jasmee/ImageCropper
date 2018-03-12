//
//  InstagramViewController.swift
//  ImageCropper
//
//  Created by Jasmee Sengupta on 08/03/18.
//  Copyright © 2018 Jasmee Sengupta. All rights reserved.
// crash fix

import UIKit

class InstagramViewController: UIViewController, UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var imageViewWidth: NSLayoutConstraint!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Scrollview delegates
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    @IBAction func openPhotoLibrary(_ sender: UIBarButtonItem) {
        let photoPicker = UIImagePickerController()
        photoPicker.delegate = self
        photoPicker.sourceType = .photoLibrary
        photoPicker.allowsEditing = false
        present(photoPicker, animated: true, completion: nil)
    }
    
    @IBAction func cropTapped(_ sender: UIButton) {
        crop()
    }
    
    func setImageToCrop(image: UIImage) {
        imageView.image = image
        imageViewHeight.constant = image.size.height
        imageViewWidth.constant = image.size.width
        let scaleWidth = scrollView.frame.size.width/image.size.width
        let scaleHeight = scrollView.frame.size.height/image.size.height
        let maxScale = max(scaleHeight, scaleWidth)
        scrollView.minimumZoomScale = maxScale
        scrollView.zoomScale = maxScale
    }
    
    func crop() {
        let scale:CGFloat = 1/scrollView.zoomScale
        
        let x:CGFloat = scrollView.contentOffset.x * scale
        let y:CGFloat = scrollView.contentOffset.y * scale
        
        let width:CGFloat = scrollView.frame.size.width * scale
        let height:CGFloat = scrollView.frame.size.height * scale
        
        let croppedCGImage = imageView.image?.cgImage?.cropping(to: CGRect(x: x, y: y, width: width, height: height))
        let croppedImage = UIImage(cgImage: croppedCGImage!) // crash
        setImageToCrop(image: croppedImage)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let selectedImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            setImageToCrop(image: selectedImage)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}


