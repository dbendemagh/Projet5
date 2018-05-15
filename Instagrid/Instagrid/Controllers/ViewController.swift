//
//  ViewController.swift
//  Instagrid
//
//  Created by Daniel BENDEMAGH on 08/05/2018.
//  Copyright © 2018 Daniel BENDEMAGH. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var gridView: GridView!

    @IBOutlet var layoutButtons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gridView.displayPattern(choice: 1)
        
    }

}

extension ViewController {
    
    
}
