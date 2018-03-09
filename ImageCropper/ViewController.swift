//
//  ViewController.swift
//  ImageCropper
//
//  Created by Jasmee Sengupta on 08/03/18.
//  Copyright © 2018 Jasmee Sengupta. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

@objc protocol CornerpointClientProtocol
{
    func cornerHasChanged(_: CornerpointView)
}

@objc protocol CroppableImageViewDelegateProtocol
{
    func haveValidCropRect(_: Bool)
}

class ViewController: UIViewController, CroppableImageViewDelegateProtocol, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //@IBOutlet weak var whiteView: UIView!
    @IBOutlet weak var cropButton: UIButton!
    @IBOutlet weak var cropView: CroppableImageView!
    
    var shutterSoundPlayer = loadShutterSoundPlayer()
    
    override func viewDidAppear(_ animated: Bool) {
        let status = PHPhotoLibrary.authorizationStatus()
        if status != .authorized {
            PHPhotoLibrary.requestAuthorization() {
                status in
            }
        }
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func saveImageToCameraRoll(_ image: UIImage) {
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
        
    }
    //-------------------------------------------------------------------------------------------------------
    // MARK: - IBAction methods -
    //-------------------------------------------------------------------------------------------------------
    
    @IBAction func cropButtonTapped(_ sender: UIButton)
    {
        //    var aFloat: Float
        //    aFloat = (sender.currentTitle! as NSString).floatValue
        //println("Button title = \(buttonTitle)")
        if let croppedImage = cropView.croppedImage()
        {
            //self.whiteView.isHidden = false
            delay(0)
            {
                self.shutterSoundPlayer?.play()
                self.saveImageToCameraRoll(croppedImage)
                //UIImageWriteToSavedPhotosAlbum(croppedImage, nil, nil, nil);
                
                delay(0.2)
                {
                    //self.whiteView.isHidden = true
                    self.shutterSoundPlayer?.prepareToPlay()
                }
            }
            
            
            //The code below saves the cropped image to a file in the user's documents directory.
            /*------------------------
             let jpegData = UIImageJPEGRepresentation(croppedImage, 0.9)
             let documentsPath:String = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory,
             NSSearchPathDomainMask.UserDomainMask,
             true).last as String
             let filename = "croppedImage.jpg"
             var filePath = documentsPath.stringByAppendingPathComponent(filename)
             if (jpegData.writeToFile(filePath, atomically: true))
             {
             println("Saved image to path \(filePath)")
             }
             else
             {
             println("Error saving file")
             }
             */
        }
    }
    
    //-------------------------------------------------------------------------------------------------------
    // MARK: - CroppableImageViewDelegateProtocol methods -
    //-------------------------------------------------------------------------------------------------------
    
    func haveValidCropRect(_ haveValidCropRect:Bool)
    {
        //println("In haveValidCropRect. Value = \(haveValidCropRect)")
        cropButton.isEnabled = haveValidCropRect
    }
    //-------------------------------------------------------------------------------------------------------
    // MARK: - UIImagePickerControllerDelegate methods -
    //-------------------------------------------------------------------------------------------------------
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : Any])
    {
        print("In \(#function)")
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            picker.dismiss(animated: true, completion: nil)
            cropView.imageToCrop = image
        }
        //cropView.setNeedsLayout()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        print("In \(#function)")
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func openCamera(_ sender: UIBarButtonItem) {
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("Camera not available")
            return
        }
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .camera
        cameraPicker.allowsEditing = false
        present(cameraPicker, animated: true, completion: nil)
    }
    
    @IBAction func openPhotoLibrary(_ sender: UIBarButtonItem) {
        let photoPicker = UIImagePickerController()
        photoPicker.delegate = self
        photoPicker.sourceType = .photoLibrary
        photoPicker.allowsEditing = false
        present(photoPicker, animated: true, completion: nil)
    }
}

func loadShutterSoundPlayer() -> AVAudioPlayer?
{
    let theMainBundle = Bundle.main
    let filename = "Shutter sound"
    let fileType = "mp3"
    let soundfilePath: String? = theMainBundle.path(forResource: filename,
                                                    ofType: fileType,
                                                    inDirectory: nil)
    if soundfilePath == nil
    {
        return nil
    }
    //println("soundfilePath = \(soundfilePath)")
    let fileURL = URL(fileURLWithPath: soundfilePath!)
    var error: NSError?
    let result: AVAudioPlayer?
    do {
        result = try AVAudioPlayer(contentsOf: fileURL)
    } catch let error1 as NSError {
        error = error1
        result = nil
    }
    if let requiredErr = error
    {
        print("AVAudioPlayer.init failed with error \(requiredErr.debugDescription)")
    }
    if result?.settings != nil
    {
        //println("soundplayer.settings = \(settings)")
    }
    result?.prepareToPlay()
    return result
}

func delay(_ delay: Double, block:@escaping ()->())
{
    let nSecDispatchTime = DispatchTime.now() + delay;
    let queue = DispatchQueue.main
    
    queue.asyncAfter(deadline: nSecDispatchTime, execute: block)
}
