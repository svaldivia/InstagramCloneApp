//
//  PostImageViewController.swift
//  InstagramAppClone
//
//  Created by Sebastian Valdivia on 2016-05-04.
//  Copyright © 2016 Sebastian Valdivia. All rights reserved.
//

import UIKit
import Parse

class PostImageViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var activityIndicator = UIActivityIndicatorView()
    
    @IBOutlet weak var imageToPost: UIImageView!
    @IBOutlet weak var comment: UITextField!
    
    func displayAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func chooseImage(sender: AnyObject) {
        
        let image = UIImagePickerController()
        image.delegate = self
        
        //CHALLENGE: Choose between the photolibrary or the camera
        image.sourceType = .PhotoLibrary
        image.allowsEditing = false
        
        self.presentViewController(image, animated: true, completion: nil)
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        imageToPost.image = image
        
    }
    
    @IBAction func submitImage(sender: AnyObject) {
        
        if imageToPost.image == UIImage(named: "photo.png") || comment.text == "" {
            displayAlert("Please provide an image and text", message: ":)")
            return
        }
        
        
        activityIndicator = UIActivityIndicatorView(frame: self.view.frame)
        activityIndicator.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true;
        activityIndicator.activityIndicatorViewStyle = .Gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        let post = PFObject(className: "Post")
        
        post["message"] = comment.text
        post["userId"] = PFUser.currentUser()?.objectId!
        
        let imageData = UIImagePNGRepresentation(imageToPost.image!)
        
        let imageFile = PFFile(name: "image.png", data: imageData!)
        
        post["imageFile"] = imageFile
        
        post.saveInBackgroundWithBlock { (success, error) in
            
            self.activityIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
            if error == nil {
                
                self.displayAlert("Image Posted", message:"Your image has been posted successfully")
                
                self.imageToPost.image = UIImage(named: "photo.png")
                self.comment.text = ""
                
            }else {
                //TODO: Show parse error message
                self.displayAlert("Could not post image :(", message:"Please try again later")
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
