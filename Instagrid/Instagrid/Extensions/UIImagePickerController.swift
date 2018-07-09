//
//  UIImagePickerController.swift
//  Instagrid
//
//  Created by Daniel BENDEMAGH on 30/05/2018.
//  Copyright © 2018 Daniel BENDEMAGH. All rights reserved.
//

import UIKit

extension UIImagePickerController {
    open override var shouldAutorotate: Bool { return true}
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask { return .all}
}
