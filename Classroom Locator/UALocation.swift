//
//  UALocation.swift
//  Classroom Locator
//
//  Created by Wenkang Zhou on 2018/1/12.
//  Copyright © 2018年 Wenkang Zhou. All rights reserved.
//

import Foundation
import os.log

class UALocation: NSObject, NSCoding{
    
    let locationName : String
    let courseCode : String
    let courseNum : String
    let sectionNum : String
    let courseType : String
    var latitude : String?
    var longitude : String?
    var altitude : String?
    let roomNo : String
    
    //MARK: Types
    struct PropertyKey {
        static let locationName = "locationName"
        static let courseCode = "courseCode"
        static let courseNum = "courseNum"
        static let sectionNum = "sectionNum"
        static let courseType = "courseType"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let altitude = "altitude"
        static let roomNo = "roomNo"
    }
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("ualocations")
    
    
    init(locationName : String, courseCode : String, courseNum : String, sectionNum : String, courseType : String, latitude : String, longitude : String, altitude : String, roomNo : String) {
        self.locationName = locationName
        self.courseCode = courseCode
        self.courseNum = courseNum
        self.sectionNum = sectionNum
        self.courseType = courseType
        self.latitude = latitude
        self.longitude = longitude
        self.altitude = altitude
        self.roomNo = roomNo
    }
    
    // this initializer only used for first fetching data
    init(locationName : String, courseCode : String, courseNum : String, sectionNum : String, courseType : String, roomNo : String) {
        self.locationName = locationName
        self.courseCode = courseCode
        self.courseNum = courseNum
        self.sectionNum = sectionNum
        self.courseType = courseType
        
        self.latitude = ""
        self.longitude = ""
        self.altitude = ""

        self.roomNo = roomNo
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(locationName, forKey: PropertyKey.locationName)
        aCoder.encode(courseCode, forKey: PropertyKey.courseCode)
        aCoder.encode(courseNum, forKey: PropertyKey.courseNum)
        aCoder.encode(sectionNum, forKey: PropertyKey.sectionNum)
        aCoder.encode(courseType, forKey: PropertyKey.courseType)
        aCoder.encode(latitude, forKey: PropertyKey.latitude)
        aCoder.encode(longitude, forKey: PropertyKey.longitude)
        aCoder.encode(altitude, forKey: PropertyKey.altitude)
        aCoder.encode(roomNo, forKey: PropertyKey.roomNo)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let locationName = aDecoder.decodeObject(forKey: PropertyKey.locationName) as? String else {
            os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let courseCode = aDecoder.decodeObject(forKey: PropertyKey.courseCode) as? String else {
            os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let courseNum = aDecoder.decodeObject(forKey: PropertyKey.courseNum) as? String else {
            os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let sectionNum = aDecoder.decodeObject(forKey: PropertyKey.sectionNum) as? String else {
            os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let courseType = aDecoder.decodeObject(forKey: PropertyKey.courseType) as? String else {
            os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        let latitude = aDecoder.decodeObject(forKey: PropertyKey.latitude) as? String
        
        let longitude = aDecoder.decodeObject(forKey: PropertyKey.latitude) as? String
        
        let altitude = aDecoder.decodeObject(forKey: PropertyKey.altitude) as? String
        
        guard let roomNo = aDecoder.decodeObject(forKey: PropertyKey.roomNo) as? String else {
            os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        self.init(locationName : locationName, courseCode : courseCode, courseNum : courseNum, sectionNum : sectionNum, courseType : courseType, latitude : latitude!, longitude : longitude!, altitude : altitude!, roomNo : roomNo)
    }
}
