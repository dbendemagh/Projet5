//
//  GridView.swift
//  Instagrid
//
//  Created by Daniel BENDEMAGH on 09/05/2018.
//  Copyright © 2018 Daniel BENDEMAGH. All rights reserved.
//

import UIKit

class GridView: UIView {

    //@IBOutlet weak var topLeftView: UIView!
    //@IBOutlet weak var topRightView: UIView!
    //@IBOutlet weak var bottomLeftView: UIView!
    //@IBOutlet weak var bottomRigtView: UIView! // Right
    
    enum Position: Int {
        case topLeft, topRight, bottomLeft, bottomRight
    }
    @IBOutlet var containerView: [UIView]!
    @IBOutlet var photoImageView: [UIImageView]!
    @IBOutlet var plusButtons: [UIButton]!
    
    func sortIBOutletCollectionAscending() {
        containerView.sort(by: {$0.tag < $1.tag})
        photoImageView.sort(by: {$0.tag < $1.tag})
        //plusButtons = plusButtons.sorted(by: {$0.tag < $1.tag})
        plusButtons.sort(by: {$0.tag < $1.tag})
    }
    
    // imageview
    
    func displayLayout(buttonTag: Int) {
        
        switch buttonTag {
        case 0:
            containerView[Position.topRight.rawValue].isHidden = true
            containerView[Position.bottomRight.rawValue].isHidden = false
            //topRightView.isHidden = true
            //bottomRigtView.isHidden = false
        case 1:
            containerView[Position.topRight.rawValue].isHidden = false
            containerView[Position.bottomRight.rawValue].isHidden = true
            //topRightView.isHidden = false
            //bottomRigtView.isHidden = true
        case 2:
            containerView[Position.topRight.rawValue].isHidden = false
            containerView[Position.bottomRight.rawValue].isHidden = false
            //topRightView.isHidden = false
            //bottomRigtView.isHidden = false
        default:
            break
        }
    }
    
    func displayPlus(isHidden: Bool, tag: Int) {
//        plusButtons.forEach {
//            if $0.tag == tag {
//                $0.isHidden = isHidden
//            }
//        }
        plusButtons[tag].isHidden = isHidden
    }
    
    func plusIsHidden(tag: Int) -> Bool {
//        for button in plusButtons {
//            if button.tag == tag {
//                return button.isHidden
//            }
//        }
        
        return plusButtons[tag].isHidden
    }
    
    func setPhoto(photo: UIImage, tag: Int) {
        print("Placement image : \(tag)")
        photoImageView[tag].image = photo
//        photoImageView.forEach {
//            if $0.tag == tag {
//                $0.image = photo
//            }
//        }
        
        displayPlus(isHidden: true, tag: tag)
    }
    
    
}
