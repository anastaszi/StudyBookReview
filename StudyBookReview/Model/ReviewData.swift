//
//  ReviewData.swift
//  StudyBookReviews
//
//  Created by Anastasia Zimina on 3/21/21.
//
import Foundation
import UIKit
import os.log

class ReviewData {
    var id: Int
    var title: String
    var author: String?
    var review: String?
    var photo: UIImage?
    var rating: Int
    var userName: String
    var amazonLink: URL?
    
    
    init?(id: Int, title: String, author: String?, review: String?, photo: UIImage?, rating: Int, userName: String, shopLink: URL?) {
        guard !title.isEmpty  else {
            return nil
        }
        
        guard (rating >= 0) && (rating <= 10) else {
            return nil
        }
        
        self.id = id;
        self.title = title;
        self.author = author;
        self.review = review;
        self.photo = photo;
        self.rating = rating;
        self.userName = userName;
        self.amazonLink = shopLink
    }
    
    static var defaultData: [ReviewData] = {
        return loadDataFromPlistNamed("localdata");
    }()
    
    static func saveMyData(mydata: [ReviewData]) {
        do {
           // let needsavedata = try NSKeyedArchiver.archivedData(withRootObject: mydata, requiringSecureCoding: false)
            //try needsavedata.write(to: ArchiveURL)
        } catch {
            //fatalError("Unable to save data")
            print(error)
            os_log("Failed to save data...", log: OSLog.default, type: .error)
        }
    }
    
    
    static func loadDataFromPlistNamed(_ plistName: String) -> [ReviewData] {
        guard
            let path = Bundle.main.path(forResource: plistName, ofType: "plist"),
            let dictArray = NSArray(contentsOfFile: path) as? [[String: AnyObject]]
        else {
            fatalError("An error occured while reading \(plistName).plist")
        }
        
        var reviewDataReturn: [ReviewData] = [];
        
        for dict in dictArray {
            guard
                let id = dict["id"] as? Int,
                let title = dict["title"] as? String,
                let author = dict["author"] as? String,
                let review = dict["review"] as? String,
                let photo = dict["thumbnailPic"] as? String,
                let rating = dict["rating"] as? Int,
                let userName = dict["userName"] as? String,
                let amazonLink = dict["link"] as? String
            else {
                fatalError("error parsing data \(dict)")
            }
            
            let webUrl = URL(string: amazonLink)
            
            guard let newReview = ReviewData.init(id: id, title: title, author: author, review: review, photo: UIImage(named: photo), rating: rating, userName: userName, shopLink: webUrl) else {
                fatalError("Error creating review")
            }
            
           reviewDataReturn.append(newReview)
                
        }
        return reviewDataReturn
    }
}
