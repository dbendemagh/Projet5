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
    
    private var imageSelected: Int = 0
    
    private lazy var shareSwipeGR: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(shareEvent))
    private lazy var eraseSwipeGR: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(eraseEvent))
    
    private lazy var imagePicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        return imagePicker
    }()
    
    enum ActionType {
        case share
        case erase
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gridView.displayAlertDelegate = self
        
        setupBehaviors()
    }
    
    private func setupBehaviors() {
        sortIBOutletCollectionAscending()
        
        addGesturesRecognizer()
        
        NotificationCenter.default.addObserver(self, selector: #selector(deviceOrientionDidChange), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        // start with the second layout
        gridView.displayLayout(buttonTag: 1)
    }
    
    // IBOutlets and View tags must be in the same order
    private func sortIBOutletCollectionAscending() {
        layoutButtons.sort(by: {$0.tag < $1.tag})
        gridView.sortIBOutletCollectionAscending()
    }
    
    private func addGesturesRecognizer() {
        // Images gesture recognizer
        gridView.photoImageViews.forEach {
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped(gesture:))))
            $0.isUserInteractionEnabled = true
        }
        
        // Share Gesture recognizer
        shareSwipeGR.direction = .up
        arrowImageView.addGestureRecognizer(shareSwipeGR)
        arrowImageView.isUserInteractionEnabled = true
        
        // Bonus - Double tap gesture recognizer on Gridview
        let TapGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(gridviewDoubleTapped(gesture:)))
        TapGestureRecogniser.numberOfTapsRequired = 2
        gridView.addGestureRecognizer(TapGestureRecogniser)
        
        // Bonus - Erase Gesture recognizer on Gridview
        eraseSwipeGR.direction = .down
        gridView.addGestureRecognizer(eraseSwipeGR)
    }
    
    // Manage Layout buttons
    @IBAction func layoutButtonTapped(_ sender: UIButton) {
        let tag = sender.tag
        unselectButtons()
        
        layoutButtons[sender.tag].isSelected = true
        gridView.displayLayout(buttonTag: tag)
    }
    
    // Unselect buttons
    private func unselectButtons() {
        layoutButtons.forEach { (button) in
            button.isSelected = false
        }
    }
    
    @IBAction func plusButtonTapped(_ sender: UIButton) {
        let tag = sender.tag
        imageSelected = tag
        
        chooseMedia(title: "Add image")
    }
    
    @objc private func deviceOrientionDidChange() {
        switch UIDevice.current.orientation {
        case .portrait:
            gridView.setLabelText(text: "Swipe up to share")
            shareSwipeGR.direction = .up
            eraseSwipeGR.direction = .down
        case .landscapeLeft, .landscapeRight:
            gridView.setLabelText(text: "Swipe left to share")
            shareSwipeGR.direction = .left
            eraseSwipeGR.direction = .right
        default:
            break
        }
    }
    
    @objc private func shareEvent() {
        gridAction(actionType: .share)
    }
    
    @objc private func eraseEvent() {
        gridAction(actionType: .erase)
    }
    
    private func gridAction(actionType: ActionType) {
        // Share : up or left animation
        var position = -view.frame.height
        
        if actionType == .erase {
            // Erase : right or down animation
            position = abs(position)
        }
        
        switch UIDevice.current.orientation {
        case .portrait:
            gridAnimation(actionType: actionType, transform: CGAffineTransform(translationX: 0, y: position))
            //shareAnimation(transform: CGAffineTransform(translationX: 0, y: position), duration: 0.5)
        case .landscapeLeft, .landscapeRight:
            gridAnimation(actionType: actionType, transform: CGAffineTransform(translationX: position, y: 0))
            //shareAnimation(transform: CGAffineTransform(translationX: position, y: 0), duration: 0.5)
        default:
            break
        }
    }
    
    private func gridAnimation(actionType: ActionType, transform: CGAffineTransform) {
        UIView.animate(withDuration: 0.5, animations: {
            if actionType == .share {
                self.shareStackView.transform = transform
            }
            self.gridView.transform = transform
        }) { _ in
            if actionType == .share {
                self.share()
            } else {
                self.gridView.eraseGrid()
            }
        }
    }
    
    private func gridAnimationBack(actionType: ActionType) {
        UIView.animate(withDuration: 0.3, animations: {
            if actionType == .share {
                self.shareStackView.transform = .identity
            }
            self.gridView.transform = .identity
        })
    }

    private func share() {
        if gridView.missingImage() {
            alert(title: "Missing image", message: "You have not selected all images.") {
                self.gridAnimationBack(actionType: .share)
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
                self.gridAnimationBack(actionType: .share)
            }
        }
    }
    
    @objc func imageTapped(gesture: UIGestureRecognizer) {
        
        guard let tag = gesture.view?.tag else { return }
        
        if gridView.plusIsHidden(tag: tag) {
            imageSelected = tag
            chooseMedia(title: "Change image")
        }
    }
    
    @objc func gridviewDoubleTapped(gesture: UITapGestureRecognizer) {
        gridView.setBackgroundColor()
    }
    
    /// Alert info
    ///
    /// - Parameters:
    ///   - title: Alert title
    ///   - message: Alert message
    ///   - actionButton: Method for OK button
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

extension MainVC: GridViewDelegate {
    // Question alert before erase grid
    func eraseAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            //self.gridView.eraseImages()
            self.gridView.resetGrid()
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            self.gridAnimationBack(actionType: .erase)
        }))
        present(alert, animated: true, completion: nil)
    }
    
}

