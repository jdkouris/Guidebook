//
//  PlaceViewController.swift
//  Guidebook
//
//  Created by John Kouris on 10/12/20.
//

import UIKit

class PlaceViewController: UIViewController {
    
    // MARK: - Variables and Properties
    
    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var containerView: UIView!
    
    let dismissButton = UIButton()
    
    lazy var infoViewController: InfoViewController = {
        return self.storyboard?.instantiateViewController(identifier: Constants.INFO_VIEWCONTROLLER) as! InfoViewController
    }()
    
    lazy var mapViewController: MapViewController = {
        return self.storyboard?.instantiateViewController(identifier: Constants.MAP_VIEWCONTROLLER) as! MapViewController
    }()
    
    lazy var notesViewController: NotesViewController = {
        return self.storyboard?.instantiateViewController(identifier: Constants.NOTES_VIEWCONTROLLER) as! NotesViewController
    }()
    
    var place: Place?
    
    // MARK: - ViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureDismissButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let place = place else { return }
        
        // Set the image
        if place.imageName != nil {
            placeImageView.image = UIImage(named: place.imageName!)
        }
        
        // Set the name
        placeNameLabel.text = place.name
        
        // Make sure the first segment is displayed
        segmentChanged(self.segmentedControl)
    }
    
    // MARK: - Methods
    
    private func configureDismissButton() {
        view.addSubview(dismissButton)
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.setTitle("Close", for: .normal)
        
        dismissButton.setTitleColor(.white, for: .normal)
        dismissButton.layer.borderWidth = 2
        dismissButton.layer.borderColor = UIColor.white.cgColor
        dismissButton.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        dismissButton.layer.cornerRadius = 20
        
        dismissButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            dismissButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            dismissButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            dismissButton.widthAnchor.constraint(equalToConstant: 80),
            dismissButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc private func dismissVC() {
        dismiss(animated: true, completion: nil)
    }
    
    private func switchChildViewControllers(_ childVC: UIViewController) {
        // Add it as a child view controller of this one
        addChild(childVC)
        
        // Add its view as a subview of the container view
        containerView.addSubview(childVC.view)
        
        // Set its frame and sizing
        childVC.view.frame = containerView.bounds
        childVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Indicate that it's now a child view controller
        childVC.didMove(toParent: self)
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            infoViewController.place = self.place
            switchChildViewControllers(infoViewController)
        case 1:
            mapViewController.place = self.place
            switchChildViewControllers(mapViewController)
        case 2:
            notesViewController.place = self.place
            switchChildViewControllers(notesViewController)
        default:
            infoViewController.place = self.place
            switchChildViewControllers(infoViewController)
        }
    }
    
}
