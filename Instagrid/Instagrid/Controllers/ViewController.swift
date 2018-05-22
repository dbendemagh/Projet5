//
//  ViewController.swift
//  Instagrid
//
//  Created by Daniel BENDEMAGH on 08/05/2018.
//  Copyright © 2018 Daniel BENDEMAGH. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var gridView: GridView!

    @IBOutlet var layoutButtons: [UIButton]!
    
    @IBOutlet weak var topLeftImageView: UIImageView!
    @IBOutlet weak var topRightImageView: UIImageView!
    @IBOutlet weak var bottomLeftImageView: UIImageView!
    @IBOutlet weak var bottomRightImageView: UIImageView!
    
    enum imagePosition {
        case topLeft, topRight, bottomLeft, bottomRight
    }

    // Image destination on the layout
    var imageDestination: imagePosition? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gridView.displayLayout(buttonTag: 1)
        
    }

    // Select layout buttons
    @IBAction func patternButtonTapped(_ sender: UIButton) {
        unselectButtons()
        
        layoutButtons[sender.tag].isSelected = true
        gridView.displayLayout(buttonTag: sender.tag)
    }
    
    // Unselect buttons
    func unselectButtons() {
        layoutButtons.forEach { (button) in
            button.isSelected = false
        }
    }
    
    // Add image buttons
    @IBAction func topLeftButtonTapped(_ sender: UIButton) {
        imageDestination = imagePosition.topLeft
        getImageFromLibrary()
    }
    
    @IBAction func topRightButtonTapped(_ sender: UIButton) {
        imageDestination = imagePosition.topRight
        getImageFromLibrary()
    }
    
    @IBAction func bottomLeftButtonTapped(_ sender: UIButton) {
        imageDestination = imagePosition.bottomLeft
        getImageFromLibrary()
    }
    
    @IBAction func bottomRightButtonTapped(_ sender: UIButton) {
        imageDestination = imagePosition.bottomRight
        getImageFromLibrary()
    }
    
    // Call the Photo Library
    func getImageFromLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    // set Image from Photo Library at the right position
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            if let destination = imageDestination {
                switch destination {
                case .topLeft:
                    topLeftImageView.image = pickedImage
                case .topRight:
                    topRightImageView.image = pickedImage
                case .bottomLeft:
                    bottomLeftImageView.image = pickedImage
                case .bottomRight:
                    bottomRightImageView.image = pickedImage
                }
            }
            
            dismiss(animated: true, completion: nil)
        }
    }
}

extension ViewController {
    
    
}
