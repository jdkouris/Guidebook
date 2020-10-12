//
//  LocationViewController.swift
//  Guidebook
//
//  Created by John Kouris on 10/12/20.
//

import UIKit

class LocationViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var places = [Place]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get the places from core data
        getPlaces()
        
        // Set LocationViewController as delegate and data source of tableView
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func getPlaces() {
        do {
            places = try context.fetch(Place.fetchRequest())
        } catch {
            print("Error retrieving places from Core Data")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Double check that a row was selected
        if tableView.indexPathForSelectedRow == nil {
            return
        }
        
        // Get the selected place
        let selectedPlace = self.places[tableView.indexPathForSelectedRow!.row]
        
        // Get a reference to the place view controller
        let placeVC = segue.destination as! PlaceViewController
        
        // Set the place property
        placeVC.place = selectedPlace
    }
    
}

extension LocationViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TODO: Get a cell reference
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.PLACE_CELL, for: indexPath) as! PlaceTableViewCell
        
        // Get the place
        let place = self.places[indexPath.row]
        
        // Customize the cell for the place that we want to show
        cell.setCell(place)
        
        // Return the cell
        return cell
    }
    
}
