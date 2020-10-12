//
//  Note+CoreDataProperties.swift
//  Guidebook
//
//  Created by John Kouris on 10/12/20.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var text: String?
    @NSManaged public var date: Date?

}

extension Note : Identifiable {

}
