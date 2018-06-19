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
    
    @IBOutlet weak var gridView: GridView!
    @IBOutlet weak var gridViewView: UIView!
    
    @IBOutlet var containerViews: [UIView]!
    @IBOutlet var photoImageViews: [UIImageView]!
    @IBOutlet var plusButtons: [UIButton]!
    
    func sortIBOutletCollectionAscending() {
        containerViews.sort(by: {$0.tag < $1.tag})
        photoImageViews.sort(by: {$0.tag < $1.tag})
        //plusButtons = plusButtons.sorted(by: {$0.tag < $1.tag})
        plusButtons.sort(by: {$0.tag < $1.tag})
    }
    
    // imageview
    
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
    
    func setPhoto(photo: UIImage, tag: Int) {
        print("Placement image : \(tag)")
        photoImageViews[tag].image = photo
        
        displayPlus(isHidden: true, tag: tag)
    }
}
