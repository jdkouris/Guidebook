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

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let place = place else { return }
        
        // Set the image
        if place.imageName != nil {
            placeImageView.image = UIImage(named: place.imageName!)
        }
        
        // Set the name
        placeNameLabel.text = place.name
        
        // Create an instance of the info view controller
        switchChildViewControllers(infoViewController)
        
    }
    
    // MARK: - Methods
    
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
            switchChildViewControllers(infoViewController)
        case 1:
            switchChildViewControllers(mapViewController)
        case 2:
            switchChildViewControllers(notesViewController)
        default:
            switchChildViewControllers(infoViewController)
        }
    }
    
}
