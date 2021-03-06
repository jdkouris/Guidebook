//
//  NotesViewController.swift
//  Guidebook
//
//  Created by John Kouris on 10/12/20.
//

import UIKit
import CoreData

class NotesViewController: UIViewController {
    
    // MARK: - Variables and Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    let addNoteButton = UIButton()
    
    var place: Place?
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var fetchedNotesRC: NSFetchedResultsController<Note>?
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // MARK: - ViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set table view delegate and data source
        tableView.delegate = self
        tableView.dataSource = self
        
        configureAddNoteButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refresh()
    }
    
    // MARK: - Methods
    
    private func configureAddNoteButton() {
        view.addSubview(addNoteButton)
        addNoteButton.translatesAutoresizingMaskIntoConstraints = false
        
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .large)
        addNoteButton.setImage(UIImage(systemName: "pencil", withConfiguration: largeConfig), for: .normal)
        
        addNoteButton.tintColor = .white
        addNoteButton.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        addNoteButton.layer.cornerRadius = 40
        
        addNoteButton.addTarget(self, action: #selector(addNoteTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            addNoteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            addNoteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addNoteButton.widthAnchor.constraint(equalToConstant: 80),
            addNoteButton.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    @objc func addNoteTapped() {
        // display the popup
        let addNoteVC = storyboard?.instantiateViewController(identifier: Constants.ADDNOTE_VIEWCONTROLLER) as! AddNoteViewController
        
        // set self as AddNoteDelegate to be notified of new notes
        addNoteVC.delegate = self
        
        // pass the place object through
        addNoteVC.place = place
        
        // configure the popup mode
        addNoteVC.modalPresentationStyle = .automatic
        
        // present it
        present(addNoteVC, animated: true, completion: nil)
    }
    
    func refresh() {
        // check if there's a place set
        guard let place = place else { return }
        
        // get a fetch request for the places
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        request.predicate = NSPredicate(format: "place = %@", place)
        
        // set a sort descriptor
        let dateSort = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [dateSort]
        
        do {
            // assign the fetched results controller
            fetchedNotesRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            
            // execute the fetch
            try fetchedNotesRC!.performFetch()
        } catch {
            print("Error fetching notes")
        }
        
        // refresh the table view
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}

// MARK: - Extension - Table View

extension NotesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedNotesRC?.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.NOTE_CELL, for: indexPath)
        
        // get references to the labels
        let dateLabel = cell.viewWithTag(1) as! UILabel
        let noteLabel = cell.viewWithTag(2) as! UILabel
        
        // get the note for this row
        guard let note = fetchedNotesRC?.object(at: indexPath) else { return UITableViewCell() }
        
        // set the content of the labels
        let df = DateFormatter()
        df.dateFormat = "MMM d, yyyy - h:mm a"
        
        dateLabel.text = df.string(from: note.date!)
        noteLabel.text = note.text
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let note = self.fetchedNotesRC?.object(at: indexPath) else { return }
        
        // display the popup
        let addNoteVC = storyboard?.instantiateViewController(identifier: Constants.ADDNOTE_VIEWCONTROLLER) as! AddNoteViewController
        
        // pass the selected note
        addNoteVC.note = note
        
        // set self as AddNoteDelegate to be notified of new notes
        addNoteVC.delegate = self
        
        // pass the place object through
        addNoteVC.place = place
        
        // configure the popup mode
        addNoteVC.modalPresentationStyle = .automatic
        
        // present it
        present(addNoteVC, animated: true, completion: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // get a reference to the note that is to be deleted
            guard let note = self.fetchedNotesRC?.object(at: indexPath) else { return }
            
            // delete the note from the context
            self.context.delete(note)
            
            // save the context
            self.appDelegate.saveContext()
            
            // reload the table view
            self.refresh()
        }
    }
    
}

// MARK: - Extension - Add Note Delegate

extension NotesViewController: AddNoteDelegate {
    
    func noteAdded() {
        // refetch the notes from CD and display in table view
        refresh()
    }
    
}
