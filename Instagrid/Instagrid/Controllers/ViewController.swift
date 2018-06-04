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

    // pluriel
    @IBOutlet var photoImageView: [UIImageView]!
    @IBOutlet var layoutButtons: [UIButton]!
    @IBOutlet weak var arrowUpImageView: UIImageView!
    
    var imageSelected: Int = 0
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sortIBOutletCollectionAscending()
        
        imagePicker.delegate = self
        
        addGesturesRecognizer()
        
        // start with the second layout
        gridView.displayLayout(buttonTag: 1)
        
        
    }
    
    
    // Each Item of IBOutlet Collection must match with View Tag (0, 1, 2, ...)
    func sortIBOutletCollectionAscending() {
        layoutButtons.sort(by: {$0.tag < $1.tag})
        photoImageView.sort(by: {$0.tag < $1.tag})
        gridView.sortIBOutletCollectionAscending()
    }
    
    // Manage Layout buttons
    @IBAction func layoutButtonTapped(_ sender: UIButton) {
        //debugPrint(sender.tag)
        let tag = sender.tag
        print("Tag bouton : \(tag)")
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
        print("Tag plus : \(tag)")
        imageSelected = tag
        //getImageFromLibrary()
        chooseMedia(title: "Add image")
    }
    
    func chooseMedia(title: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Take from Photo Library", style: .default, handler: { (action) in
            self.getImageFromLibrary()
        }))
        
        alert.addAction(UIAlertAction(title: "Take a photo", style: .default, handler: { (action) in
            self.getImageFromLibrary()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension ViewController {
    
    private func addGesturesRecognizer() {
        [photoImageView[0], photoImageView[1], photoImageView[2],photoImageView[3]].forEach {
            swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(imageTapped(gesture:)))
            
            
            $0.addGestureRecognizer(UISwipeGestureRecognizer(target: self, action: #selector(imageTapped(gesture:))))
            //$0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped(gesture:))))
            $0.isUserInteractionEnabled = true
        }
        
        arrowUpImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped(gesture:))))
        
        // ???????
        photoImageView.forEach {
            //(element: [UIImageView]?) in
            
//            if let e = element as? UIImageView {
                $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped(gesture:))))
//            }
        }
        
        //let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dragQuestionView(_:)))
        //arrowUpImageView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(dragArrowView(_:))))
        
    }
    
    
        @objc func imageTapped(gesture: UIGestureRecognizer) {
        
        guard let tag = gesture.view?.tag else { return }
        
        //if !layoutButtons[tag].isHidden {
        if gridView.plusIsHidden(tag: tag) {
            //print("\(tag) Plus caché")
            chooseMedia(title: "Change image")
        } else {
            print("\(tag) Pas caché")
            
        }
    }
    
    @objc func dragArrowView(_ sender: UIPanGestureRecognizer) {
        
    }
    
    // Call the Photo Library
    func getImageFromLibrary() {
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    // set Image from Photo Library at the right position
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            gridView.setPhoto(photo: pickedImage, tag: imageSelected)
            
            dismiss(animated: true, completion: nil)
        }
    }
}

