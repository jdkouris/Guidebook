//
//  AddNoteViewController.swift
//  Guidebook
//
//  Created by John Kouris on 10/14/20.
//

import UIKit
import CoreData

protocol AddNoteDelegate {
    func noteAdded()
}

class AddNoteViewController: UIViewController {
    
    // MARK: - Properties and Variables
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    var place: Place?
    var delegate: AddNoteDelegate?
    var note: Note?
    
    // MARK: - ViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
    }
    
    // MARK: - Methods
    
    private func configureViews() {
        if note != nil {
            textView.text = note?.text
        }
        
        cardView.layer.cornerRadius = 20
        cardView.layer.shadowColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        cardView.layer.shadowOpacity = 1
        cardView.layer.shadowOffset = .zero
        cardView.layer.shadowRadius = 20
        
        cancelButton.layer.borderWidth = 2
        cancelButton.layer.borderColor = UIColor.red.cgColor
        cancelButton.layer.cornerRadius = 20
        
        saveButton.backgroundColor = .blue
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.layer.cornerRadius = 20
        
        textView.becomeFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        // create a new note if one doesn't already exist
        if note == nil {
            self.note = Note(context: context)
            
            // configure the properties
            note!.date = Date()
            note!.text = textView.text ?? ""
            note!.place = place
            
        } else {
            // update an existing note
            note?.date = Date()
            note?.text = textView.text
            note?.place = place
        }
        
        // save the cd context
        appDelegate.saveContext()
        
        // let the delegate know that the note was added
        delegate?.noteAdded()
        
        // dismiss the popup
        dismiss(animated: true, completion: nil)
    }
}
