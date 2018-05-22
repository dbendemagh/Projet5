//
//  GridView.swift
//  Instagrid
//
//  Created by Daniel BENDEMAGH on 09/05/2018.
//  Copyright © 2018 Daniel BENDEMAGH. All rights reserved.
//

import UIKit

class GridView: UIView {

    @IBOutlet weak var topLeftView: UIView!
    @IBOutlet weak var topRightView: UIView!
    @IBOutlet weak var bottomLeftView: UIView!
    @IBOutlet weak var bottomRigtView: UIView! // Right
    
    
    
    func displayLayout(buttonTag: Int) {
        
        switch buttonTag {
        case 0:
            topRightView.isHidden = true
            bottomRigtView.isHidden = false
        case 1:
            topRightView.isHidden = false
            bottomRigtView.isHidden = true
        case 2:
            topRightView.isHidden = false
            bottomRigtView.isHidden = false
        default:
            break
        }
    }
    
    
}
