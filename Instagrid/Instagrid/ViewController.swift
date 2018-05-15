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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gridView.displayPattern(choice: 1)
        
    }

    


}

