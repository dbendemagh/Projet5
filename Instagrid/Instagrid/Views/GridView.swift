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
    
    // buttonTag
    func displayPattern(choice: Int) {
        switch choice {
        case 0:
            topRightView.isHidden = true
            bottomRigtView.isHidden = false
            
        case 1:
            print("1")
        case 2:
            print("2")
        default:
            break
        }
    }
}
