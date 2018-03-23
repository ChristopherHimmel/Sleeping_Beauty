//
//  Sleep.swift
//  SleepingBeauty
//
//  Created by Jane Appleseed on 11/10/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit
import os.log


class Sleep: NSObject, NSCoding {
    
    //MARK: Properties
    
    var hoursOverUnder: String
    var photo: UIImage?
    var rating: Int
    var entryTimeStamp: String
    
    //MARK: Archiving Paths
    static var DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("sleeps")
    
    //MARK: Types
    
    struct PropertyKey {
        static let hoursOverUnder = "hoursOverUnder"
        static let photo = "photo"
        static let rating = "rating"
        static let entryTimeStamp = "entryTimeStamp"
    }
    
    //MARK: Initialization
    
    init?(hoursOverUnder: String, photo: UIImage?, rating: Int, entryTimeStamp: String) {
        
        // The hoursOverUnder must not be empty
        guard !hoursOverUnder.isEmpty else {
            return nil
        }

        // The rating must be between 0 and 5 inclusively
        guard (rating >= 0) && (rating <= 5) else {
            return nil
        }
        
        // Initialize stored properties.
        self.hoursOverUnder = hoursOverUnder
        self.photo = photo
        self.rating = rating
        self.entryTimeStamp = entryTimeStamp
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(hoursOverUnder, forKey: PropertyKey.hoursOverUnder)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(rating, forKey: PropertyKey.rating)
        aCoder.encode(entryTimeStamp, forKey: PropertyKey.entryTimeStamp)
    }

    required convenience init?(coder aDecoder: NSCoder) {
        
        guard let hoursOverUnder = aDecoder.decodeObject(forKey: PropertyKey.hoursOverUnder) as? String else {
            os_log("Unable to decode the hoursOverUnder for a Sleep object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Because photo is an optional property of Sleep, just use conditional cast.
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        
        let rating = aDecoder.decodeInteger(forKey: PropertyKey.rating)

        let entryTimeStamp = aDecoder.decodeObject(forKey: PropertyKey.entryTimeStamp) as! String
        
        // Must call designated initializer.
        self.init(hoursOverUnder: hoursOverUnder, photo: photo, rating: rating, entryTimeStamp: entryTimeStamp)
    }

}
