//
//  NotesViewController.swift
//  Guidebook
//
//  Created by John Kouris on 10/12/20.
//

import UIKit

class NotesViewController: UIViewController {
    
    // MARK: - Variables and Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    var place: Place?
    
    // MARK: - ViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Methods
    
    @IBAction func addNoteTapped(_ sender: Any) {
        // display the popup
        let addNoteVC = storyboard?.instantiateViewController(identifier: Constants.ADDNOTE_VIEWCONTROLLER) as! AddNoteViewController
        
        // pass the place object through
        addNoteVC.place = place
        
        // configure the popup mode
//        addNoteVC.modalPresentationStyle = .overCurrentContext
        addNoteVC.modalPresentationStyle = .automatic
        
        // present it
        present(addNoteVC, animated: true, completion: nil)
    }
    
}
