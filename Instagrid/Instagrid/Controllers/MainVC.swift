//
//  ViewController.swift
//  Instagrid
//
//  Created by Daniel BENDEMAGH on 08/05/2018.
//  Copyright © 2018 Daniel BENDEMAGH. All rights reserved.
//

import UIKit

class MainVC: UIViewController {

    @IBOutlet weak var gridView: GridView!
    
    @IBOutlet var layoutButtons: [UIButton]!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var shareStackView: UIStackView!
    
    var swipeGestureRecognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(moveGridview))
    
    var imageSelected: Int = 0
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sortIBOutletCollectionAscending()
        
        imagePicker.delegate = self
        
        addGesturesRecognizer()
        
        NotificationCenter.default.addObserver(self, selector: #selector(deviceOrientionDidChange), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        // start with the second layout
        gridView.displayLayout(buttonTag: 1)
    }
    
    // Each Item of IBOutlet Collection must match with View Tag (0, 1, 2, ...)
    func sortIBOutletCollectionAscending() {
        layoutButtons.sort(by: {$0.tag < $1.tag})
        gridView.sortIBOutletCollectionAscending()
    }
    
    // Manage Layout buttons
    @IBAction func layoutButtonTapped(_ sender: UIButton) {
        let tag = sender.tag
        //print("Tag bouton : \(tag)")
        unselectButtons()
        
        layoutButtons[sender.tag].isSelected = true
        gridView.displayLayout(buttonTag: tag)
    }
    
    // Unselect buttons
    func unselectButtons() {
        layoutButtons.forEach { (button) in
            button.isSelected = false
        }
    }
    
    @IBAction func plusButtonTapped(_ sender: UIButton) {
        let tag = sender.tag
        imageSelected = tag

        chooseMedia(title: "Add image")
    }
    
    @objc func deviceOrientionDidChange() {
        print(UIDevice.current.orientation)
        
        switch UIDevice.current.orientation {
        case .portrait:
            print("portrait")
            gridView.setLabelText(text: "Swipe up to share")
            swipeGestureRecognizer.direction = .up
        case .landscapeLeft, .landscapeRight:
            print("landscape")
            gridView.setLabelText(text: "Swipe left to share")
            swipeGestureRecognizer.direction = .left
        default:
            break
        }
    }
    
    @objc func moveGridview() {
        
        switch UIDevice.current.orientation {
        case .portrait:
            animateGridview(transform: CGAffineTransform(translationX: 0, y: -view.frame.height), duration: 0.5)
        case .landscapeLeft, .landscapeRight:
            animateGridview(transform: CGAffineTransform(translationX: -view.frame.width, y: 0), duration: 0.5)
        default:
            break
        }
    }
    
    func animateGridview(transform: CGAffineTransform, duration: TimeInterval) {
        
        UIView.animate(withDuration: duration, animations: {
            self.shareStackView.transform = transform
            self.gridView.transform = transform
        }) { _ in
            self.shareControl()
        }
    }
    
    func animateGridviewBack(duration: TimeInterval) {
        UIView.animate(withDuration: duration, animations: {
            self.shareStackView.transform = .identity
            self.gridView.transform = .identity
        })
    }
    
    func missingImage() -> Bool {
        for photo in gridView.photoImageViews {
            // If Parent View not hidden and image is nul, missing image
            guard let superview = photo.superview else { return false}
            if !superview.isHidden && photo.image == nil {
                return true
            }
        }
        
        return false
    }
    
    func shareControl() {
        if missingImage() {
            alert(title: "Missing image", message: "You have not selected all images.") {
                // Go back
                self.animateGridviewBack(duration: 0.3)
            }
        } else {
            shareImage()
        }
    }
    
    func shareImage() {
        guard let image = GridConverter.convertViewToImage(gridView: gridView) else { return }
        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
        
        activityController.completionWithItemsHandler = {(nil, completed: Bool, _, error) in
            if !completed {
                self.animateGridviewBack(duration: 0.5)
            }
        }
    }
    
    private func addGesturesRecognizer() {
        // Gesture for Images
        gridView.photoImageViews.forEach {
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped(gesture:))))
            $0.isUserInteractionEnabled = true
        }
        
        // Gesture for Arrow
        swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(moveGridview))
        swipeGestureRecognizer.direction = .up
        arrowImageView.addGestureRecognizer(swipeGestureRecognizer)
        arrowImageView.isUserInteractionEnabled = true
    }
    
    @objc func imageTapped(gesture: UIGestureRecognizer) {
        
        guard let tag = gesture.view?.tag else { return }
        
        if gridView.plusIsHidden(tag: tag) {
            chooseMedia(title: "Change image")
        }
    }
    
    func alert(title: String, message: String, actionButton: @escaping () -> ()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            actionButton()
        }))
        present(alert, animated: true, completion: nil)
    }
}

extension MainVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func chooseMedia(title: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "from Photo library", style: .default, handler: { (action) in
            self.getImageFrom(sourceType: .photoLibrary)
        }))
        
        alert.addAction(UIAlertAction(title: "from Camera", style: .default, handler: { (action) in
            self.getImageFrom(sourceType: .camera)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // Get image from Photo Library or Camera
    func getImageFrom(sourceType: UIImagePickerControllerSourceType) {
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }
    
    // set Image at the right position
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            gridView.setPhoto(photo: pickedImage, tag: imageSelected)
            
            dismiss(animated: true, completion: nil)
        }
    }
}

