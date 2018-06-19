//
//  GridConverter.swift
//  Instagrid
//
//  Created by Daniel BENDEMAGH on 13/06/2018.
//  Copyright © 2018 Daniel BENDEMAGH. All rights reserved.
//

//import Foundation
import UIKit

class GridConverter {
    static func convertViewToImage(gridView: GridView) -> UIImage? {
        UIGraphicsBeginImageContext(gridView.bounds.size)
        gridView.drawHierarchy(in: gridView.bounds, afterScreenUpdates: true)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return image
    }
}
