//
//  PickImageViewController
//  ImageCropper
//
//  Created by Jasmee Sengupta on 08/03/18.
//  Copyright © 2018 Jasmee Sengupta. All rights reserved.
//

import UIKit
import AVFoundation

class PickImageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var imageView: UIImageView!// remove FU later, if required.
    var cropview: UIView!// remove FU later.
    var imgviewrect: CGRect!
    var selectedImage: UIImage!
    var added = false
    var croptype = CROP_TYPE.square
    var croppedImg: UIImage?

    override func viewDidLoad()
    {
        super.viewDidLoad()
        addImageView()
    }
    
    func addImageView() {
        imageView = UIImageView(frame: self.view.bounds)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        self.view.addSubview(imageView)
    }
    
//    func addCropView() {
//        self.view.addSubview(cropview)
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pickImageTapped(_ sender: UIBarButtonItem) {
        let photoPicker = UIImagePickerController()
        photoPicker.delegate = self
        photoPicker.sourceType = .photoLibrary
        photoPicker.allowsEditing = false
        present(photoPicker, animated: true, completion: nil)
    }
    
    @IBAction func cropRatioTapped(_ sender: UIBarButtonItem) {
        print("Choose crop options \(croptype.Name()))")
        let myActionSheet = UIAlertController(title: "Crop Options[\(croptype.Name())]", message: "Select Crop Ratio (width: height) ", preferredStyle: UIAlertControllerStyle.actionSheet)
        let op1 = UIAlertAction(title: CROP_TYPE.square.Name(), style: UIAlertActionStyle.default) { (action) in
            self.croptype = CROP_TYPE.square
            self.makeCropAreaVisible()
        }
        
        let op2 = UIAlertAction(title: CROP_TYPE.rect3x2.Name(), style: UIAlertActionStyle.default) { (action) in
            self.croptype = CROP_TYPE.rect3x2
            self.makeCropAreaVisible()
        }
        
        let op3 = UIAlertAction(title: CROP_TYPE.rect2x3.Name(), style: UIAlertActionStyle.default) { (action) in
            self.croptype = CROP_TYPE.rect2x3
            self.makeCropAreaVisible()
        }
        
        let op4 = UIAlertAction(title: CROP_TYPE.rect3x4.Name(), style: UIAlertActionStyle.default) { (action) in
            self.croptype = CROP_TYPE.rect3x4
            self.makeCropAreaVisible()
        }
        
        let op5 = UIAlertAction(title: CROP_TYPE.rect4x3.Name(), style: UIAlertActionStyle.default) { (action) in
            self.croptype = CROP_TYPE.rect4x3
            self.makeCropAreaVisible()
        }
        
        let op6 = UIAlertAction(title: CROP_TYPE.rect2x5.Name(), style: UIAlertActionStyle.default) { (action) in
            self.croptype = CROP_TYPE.rect2x5
            self.makeCropAreaVisible()
        }
        
        let op7 = UIAlertAction(title: CROP_TYPE.rect5x2.Name(), style: UIAlertActionStyle.default) { (action) in
            self.croptype = CROP_TYPE.rect5x2
            self.makeCropAreaVisible()
        }
        
        let op10 = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (action) in
            print("Cancel action button tapped")
        }
        
        myActionSheet.addAction(op1)
        myActionSheet.addAction(op2)
        myActionSheet.addAction(op3)
        myActionSheet.addAction(op4)
        myActionSheet.addAction(op5)
        myActionSheet.addAction(op6)
        myActionSheet.addAction(op7)
        myActionSheet.addAction(op10)
        
        present(myActionSheet, animated: true, completion: nil)
    }
    
    @IBAction func cropTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "showCroppedImage", sender: nil)
    }

    // MARK: Image picker delegates
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.selectedImage = selectedImage
            imageView.image = selectedImage
            calculateRect()
            if !added {
                self.makeCropAreaVisible()
                added = true
            }
            print("now crop area on top \(cropview.frame) ")
            dismiss(animated: true, completion: nil)
            print("image found with width \(selectedImage.size.width) and height \(selectedImage.size.height)")
            print("image view frame width \(imageView.frame.width) and height \(imageView.frame.height)")
        }
        picker.dismiss(animated: true, completion: nil)// why have to add explicitly?
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // MARK:
    
    func makeCropAreaVisible(){ //making selected crop area
        if added == true {
            cropview.removeFromSuperview()
            cropview = nil
        }
        let min: CGFloat = imgviewrect.size.height > imgviewrect.size.width ? imgviewrect.size.width:imgviewrect.size.height
        cropview = CropAreaView(origin: self.view.center, width: min * croptype.Muls().x, height: min * croptype.Muls().y)
        self.view.addSubview(cropview)
    }
    
    func calculateRect(){ // getting same value from the image
        imgviewrect = AVMakeRect(aspectRatio: selectedImage.size, insideRect: imageView.bounds)
        print (" Image Frame height:\(imgviewrect.size.height) width:\(imgviewrect.size.width) and x,y =( \(imgviewrect.origin.x) ,\(imgviewrect.origin.y) )" )
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCroppedImage" {
            if let vc = segue.destination as? CroppedImageViewController {
                vc.croppedImage = retriveCroppedImage()
            }
        }
    }
    
    func retriveCroppedImage() -> UIImage {
        let yratio: CGFloat = imgviewrect.size.height / selectedImage.size.height
        let xratio: CGFloat = imgviewrect.size.width / selectedImage.size.width
        var cliprect = CGRect(x: _cropoptions.Center.x - _cropoptions.Width/2, y: _cropoptions.Center.y - _cropoptions.Height/2, width: _cropoptions.Width, height: _cropoptions.Height)
        
        print("cliprect top  \(cliprect.size)")
        cliprect.size.height =  cliprect.size.height / xratio;
        cliprect.size.width =  cliprect.size.width / xratio;
        cliprect.origin.x = cliprect.origin.x / xratio + imgviewrect.origin.x  / xratio
        cliprect.origin.y = cliprect.origin.y / yratio - imgviewrect.origin.y  / xratio
        print("cliprect  On Image \(cliprect)")
        
        let imageRef =  selectedImage.cgImage?.cropping(to: cliprect)
        croppedImg  = UIImage(cgImage: imageRef!, scale: UIScreen.main.scale, orientation: selectedImage.imageOrientation)
        print("Operation complete")
        return croppedImg!
    }

}

struct xy {
    var x: CGFloat!
    var y: CGFloat!
    mutating func xy(_x: CGFloat , _y: CGFloat){
        self.x = _x
        self.y = _y
    }
}
enum CROP_TYPE{
    case square, rect3x2,  rect2x3,  rect3x4,  rect4x3,  rect2x5,  rect5x2
    static let divs = [square : 1, rect3x2 : 5, rect2x3 : 5,rect3x4 : 7, rect4x3 : 7, rect2x5 : 7,rect5x2 : 7]
    static let muls = [square : xy(x: 0.5, y: 0.5), rect3x2 : xy(x: 3/5, y: 2/5), rect2x3 : xy(x: 2/5, y: 2/5),rect3x4 : xy(x: 3/7, y: 4/7), rect4x3 : xy(x: 4/7, y: 3/7), rect2x5 : xy(x: 2/7, y: 5/7),rect5x2 : xy(x: 5/7, y: 2/7)]
    static let names = [square : " 1:1 ", rect3x2 : " 3:2 ", rect2x3 : " 2:3 ",rect3x4 : " 3:4 ", rect4x3 : " 4:3 ", rect2x5 : " 2:5 ",rect5x2 : " 5:2 "]
    func Div()-> Int{
        if let ret = CROP_TYPE.divs[self]{
            return ret
        }else{
            return -1
        }
    }
    func Muls()-> xy{
        if let ret = CROP_TYPE.muls[self]{
            return ret
        }else{
            return xy(x: 0.5,y: 0.5)
        }
    }
    func Name()-> String{
        if let ret = CROP_TYPE.names[self]{
            return ret
        }else{
            return "n.a."
        }
    }
}
struct CROP_OPTIONS {
    var Height: CGFloat!
    var Width: CGFloat!
    var Center: CGPoint!
}
struct FRAME {
    var Height: CGFloat!
    var Width: CGFloat!
}
var  _cropoptions: CROP_OPTIONS!
var _frame: CROP_OPTIONS!
var croptype: CROP_TYPE!

/*func saveImageToCameraRoll(_ image: UIImage) {
 PHPhotoLibrary.shared().performChanges({
 PHAssetChangeRequest.creationRequestForAsset(from: image)
 }, completionHandler: { success, error in
 if success {
 // Saved successfully!
 }
 else if let error = error {
 print("Save failed with error " + String(describing: error))
 }
 else {
 }
 })
 
 }*/
