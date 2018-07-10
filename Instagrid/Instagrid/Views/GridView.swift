//
//  GridView.swift
//  Instagrid
//
//  Created by Daniel BENDEMAGH on 09/05/2018.
//  Copyright © 2018 Daniel BENDEMAGH. All rights reserved.
//

import UIKit

protocol GridViewDelegate {
    func showEraseAlert(title: String, message: String)
}

class GridView: UIView {
    
    var displayAlertDelegate: GridViewDelegate!
    
    private let backgroundColors = [#colorLiteral(red: 0.06274509804, green: 0.4, blue: 0.5960784314, alpha: 1),#colorLiteral(red: 0, green: 0.5690457821, blue: 0.5746168494, alpha: 1),#colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1),#colorLiteral(red: 0.5704585314, green: 0.5704723597, blue: 0.5704649091, alpha: 1),#colorLiteral(red: 0.5058823824, green: 0.3372549117, blue: 0.06666667014, alpha: 1)]
    private var colorIndex = 0
    
    enum Position: Int {
        case topLeft, topRight, bottomLeft, bottomRight
    }
    
    @IBOutlet private weak var swipeLabel: UILabel!
    @IBOutlet private var containerViews: [UIView]!
    @IBOutlet var photoImageViews: [UIImageView]!
    @IBOutlet private var plusButtons: [UIButton]!
    
    // IBOutlets and View tags must be in the same order
    func sortIBOutletCollectionAscending() {
        containerViews.sort(by: {$0.tag < $1.tag})
        photoImageViews.sort(by: {$0.tag < $1.tag})
        plusButtons.sort(by: {$0.tag < $1.tag})
    }
    
    func displayLayout(buttonTag: Int) {
        
        switch buttonTag {
        case 0:
            containerViews[Position.topRight.rawValue].isHidden = true
            containerViews[Position.bottomRight.rawValue].isHidden = false
        case 1:
            containerViews[Position.topRight.rawValue].isHidden = false
            containerViews[Position.bottomRight.rawValue].isHidden = true
        case 2:
            containerViews[Position.topRight.rawValue].isHidden = false
            containerViews[Position.bottomRight.rawValue].isHidden = false
        default:
            break
        }
    }
    
    func displayPlus(isHidden: Bool, tag: Int) {
        plusButtons[tag].isHidden = isHidden
    }
    
    func plusIsHidden(tag: Int) -> Bool {
        return plusButtons[tag].isHidden
    }
    
    func setLabelText(text: String) {
        swipeLabel.text = text
    }
    
    func setPhoto(photo: UIImage, tag: Int) {
        photoImageViews[tag].image = photo
        
        displayPlus(isHidden: true, tag: tag)
    }
    
    func eraseGrid() {
        if isEmpty() {
            // Grid empty, no alert message needed
            resetGrid()
        } else {
            displayAlertDelegate.showEraseAlert(title: "Erase", message: "Do you want to erase grid ?")
        }
    }
    
    // Verify if the grid contain at least one image
    private func isEmpty() -> Bool {
        for photo in photoImageViews {
            if let superview = photo.superview {
                // If Parent View not hidden and image not nul, grid is not empty
                if !superview.isHidden && photo.image != nil {
                    return false
                }
            }
        }
        
        return true
    }
    
    func eraseImages() {
        for photo in photoImageViews {
            photo.image = nil
        }
        
        for button in plusButtons {
            button.isHidden = false
        }
    }
    
    func resetGrid() {
        eraseImages()
        // Original background color
        backgroundColor = #colorLiteral(red: 0.06274509804, green: 0.4, blue: 0.5960784314, alpha: 1)
        colorIndex = 0
        
        UIView.animate(withDuration: 0.3, animations: {
            self.transform = .identity
        })
    }
    
    // Make sure the grid selection is complete
    func missingImage() -> Bool {
        for photo in photoImageViews {
            guard let superview = photo.superview else { return false}
            // If Parent View not hidden and image is nul, missing image
            if !superview.isHidden && photo.image == nil {
                return true
            }
        }
        
        return false
    }
    
    func setBackgroundColor() {
        backgroundColor = nextBackgroundColor()
    }
    
    private func nextBackgroundColor() -> UIColor {
        colorIndex += 1
        if colorIndex > backgroundColors.count - 1 {
            colorIndex = 0
        }
        
        return backgroundColors[colorIndex]
    }
}
