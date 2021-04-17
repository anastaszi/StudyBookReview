//
//  ReviewData.swift
//  StudyBookReviews
//
//  Created by Anastasia Zimina on 3/21/21.
//
import Foundation
import UIKit
import os.log

class ReviewData: NSObject, NSCoding {
    
    func encode(with coder: NSCoder) {
        coder.encode(id, forKey: PropertyKey.id)
        coder.encode(title, forKey: PropertyKey.title)
        coder.encode(author, forKey: PropertyKey.author)
        coder.encode(review, forKey: PropertyKey.review)
        coder.encode(photo, forKey: PropertyKey.photo)
        coder.encode(attitude, forKey: PropertyKey.attitude)
        coder.encode(userName, forKey: PropertyKey.userName)
        coder.encode(link, forKey: PropertyKey.link)
    }
    
    struct PropertyKey {
        static let id = "id"
        static let title = "title"
        static let author = "author"
        static let review = "review"
        static let photo = "photo"
        static let attitude = "attitude"
        static let userName = "userName"
        static let link = "link"
    }
    
    required convenience init?(coder: NSCoder) {
        let id = coder.decodeInteger(forKey: PropertyKey.id);
        guard let title = coder.decodeObject(forKey: PropertyKey.title) as? String else {
            os_log("Unable to decode the title", log: OSLog.default, type: .debug)
            return nil
        }
        let author = coder.decodeObject(forKey: PropertyKey.author) as? String
        let review = coder.decodeObject(forKey: PropertyKey.review) as? String
        let photo = coder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        let attitude = coder.decodeObject(forKey: PropertyKey.attitude) as? String
        guard let userName = coder.decodeObject(forKey: PropertyKey.userName) as? String else {
            os_log("Unable to decode userName", log: OSLog.default, type: .debug)
            return nil
        }
        let link = coder.decodeObject(forKey: PropertyKey.link) as? URL
        
        self.init(id: id, title: title, author: author, review: review, photo: photo, attitude: attitude, userName: userName, link: link)
    }
    
    var id: Int
    var title: String
    var author: String?
    var review: String?
    var photo: UIImage?
    var attitude: String?
    var userName: String
    var link: URL?
    
    
    init?(id: Int, title: String, author: String?, review: String?, photo: UIImage?, attitude: String?, userName: String, link: URL?) {
        guard !title.isEmpty  else {
            return nil
        }
        guard !userName.isEmpty  else {
            return nil
        }
        
        self.id = id;
        self.title = title;
        self.author = author;
        self.review = review;
        self.photo = photo;
        self.attitude = attitude;
        self.userName = userName;
        self.link = link
    }
    
    static var defaultData: [ReviewData] = {
        if let savedData = loadMyDataFromArchive() {
            return savedData
        }
        if let localData = loadDataFromPlistNamed("localdata") {
            return localData
        } else {
            return ([])
        }
    }()
    
    static func saveMyData(mydata: [ReviewData]) {
        do {
            let needsavedata = try NSKeyedArchiver.archivedData(withRootObject: mydata, requiringSecureCoding: false)
            try needsavedata.write(to: ArchiveURL)
        } catch {
            //fatalError("Unable to save data")
            print(error)
            os_log("Failed to save data...", log: OSLog.default, type: .error)
        }
    }
    
    static func loadMyDataFromArchive() -> [ReviewData]? {
        do {
            guard let codedData = try? Data(contentsOf: ReviewData.ArchiveURL) else {
                return nil
            }
            let loadedData = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(codedData) as? [ReviewData]
            return loadedData
        } catch {
            os_log("Failed to load data ....", log: OSLog.default, type: .error)
        }
        return nil
    }
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("MyModelData")
    
    
    static func loadDataFromPlistNamed(_ plistName: String) -> [ReviewData]? {
        guard
            let path = Bundle.main.path(forResource: plistName, ofType: "plist"),
            let dictArray = NSArray(contentsOfFile: path) as? [[String: AnyObject]]
        else {
            fatalError("An error occured while reading \(plistName).plist")
            return nil
        }
        
        var reviewDataReturn: [ReviewData] = [];
        
        for dict in dictArray {
            guard
                let id = dict["id"] as? Int,
                let title = dict["title"] as? String,
                let author = dict["author"] as? String,
                let review = dict["review"] as? String,
                let photo = dict["thumbnailPic"] as? String,
                let attitude = dict["attitude"] as? String,
                let userName = dict["userName"] as? String,
                let link = dict["link"] as? String
            else {
                fatalError("error parsing data \(dict)")
            }
            
            let webUrl = URL(string: link)
            
            guard let newReview = ReviewData.init(id: id, title: title, author: author, review: review, photo: UIImage(named: photo), attitude: attitude, userName: userName, link: webUrl) else {
                fatalError("Error creating review")
            }
            
           reviewDataReturn.append(newReview)
                
        }
        return reviewDataReturn
    }
    
}
