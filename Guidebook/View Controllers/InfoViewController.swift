//
//  InfoViewController.swift
//  Guidebook
//
//  Created by John Kouris on 10/12/20.
//

import UIKit

class InfoViewController: UIViewController {
    
    // MARK: - Variables and Properties
    
    @IBOutlet weak var summaryLabel: UILabel!
    
    var place: Place?
    
    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        summaryLabel.text = place?.summary
    }
    
}
