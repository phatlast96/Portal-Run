//
//  CDHighScores1+CoreDataProperties.swift
//  
//
//  Created by Phat Pham on 1/21/17.
//
//

import Foundation
import CoreData


extension CDHighScores1 {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDHighScores1> {
        return NSFetchRequest<CDHighScores1>(entityName: "CDHighScores1");
    }

    @NSManaged public var score: Int64

}
