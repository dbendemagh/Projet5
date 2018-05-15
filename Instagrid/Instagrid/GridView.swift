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
    @IBOutlet weak var bottomRigtView: UIView!
    
    func displayPattern(choice: Int) {
        switch choice {
        case 1:
            topLeftView.isHidden = false
            topRightView.isHidden = true
            bottomLeftView.isHidden = false
            bottomRigtView.isHidden = false
        default: break
        //    <#code#>
        }
    }
}
