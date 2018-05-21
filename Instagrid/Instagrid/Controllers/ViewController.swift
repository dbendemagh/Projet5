//
//  ViewController.swift
//  Instagrid
//
//  Created by Daniel BENDEMAGH on 08/05/2018.
//  Copyright © 2018 Daniel BENDEMAGH. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var gridView: GridView!

    @IBOutlet var layoutButtons: [UIButton]!
    
    @IBOutlet weak var topLeftImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gridView.displayPattern(choice: 1)
        
    }

    @IBAction func patternButtonTapped(_ sender: UIButton) {
        unselectButtons()
        
        layoutButtons[sender.tag].isSelected = true
        gridView.displayPattern(choice: sender.tag)
    }
    
    func unselectButtons() {
        layoutButtons.forEach { (button) in
            button.isSelected = false
        }
    }
    
    
    @IBAction func topLeftButtonTapped(_ sender: UIButton) {
        
    }
}

extension ViewController {
    
    
}
