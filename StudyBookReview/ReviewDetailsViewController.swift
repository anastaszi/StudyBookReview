//
//  ReviewDetailsViewController.swift
//  StudyBookReview
//
//  Created by Anastasia Zimina on 3/22/21.
//

import UIKit
import SafariServices

class ReviewDetailsViewController: UITableViewController, SFSafariViewControllerDelegate, UIViewControllerTransitioningDelegate {

    @IBOutlet var tableview: UITableView!
    
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var authorName: UILabel!
    
    @IBOutlet weak var reviewText: UILabel!
    @IBOutlet weak var reviewerName: UILabel!
    //@IBOutlet weak var likeControl: LikeControl!
    @IBOutlet weak var likeControl: LikeControl!
    var reviewData: ReviewData?
    private var webLink: URL?
    @IBOutlet weak var webButton: UIButton!
    
    @IBAction func amazonBtn(_ sender: UIButton) {
        if (webLink != nil) {
            let safariVC = SFSafariViewController(url: webLink!)
            safariVC.delegate = self
            safariVC.transitioningDelegate = self
            present(safariVC, animated: true, completion: nil)
        }
        else {
            print("No Amazon Link added")
        }
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
      controller.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundView = UIImageView(image: UIImage(named: "Group 12.png"))
        
        webButton.backgroundColor = #colorLiteral(red: 0.899363637, green: 0.8210355639, blue: 0.2810002863, alpha: 1)
        webButton.tintColor = #colorLiteral(red: 0.7027593851, green: 0.3648658991, blue: 0.2622417212, alpha: 1)
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "< All Reviews", style: UIBarButtonItem.Style.plain, target: self, action: #selector(ReviewDetailsViewController.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
        likeControl.delegate = self
        let headerView = StratchyTableHeaderView(frame: CGRect(x: 0, y: 0, width: 150, height: 250))
        if let reviewData = reviewData {
            print(reviewData.title)
            headerView.imageView.image = reviewData.photo

            bookTitle.text = reviewData.title
            authorName.text = reviewData.author
            reviewText.text = reviewData.review
            reviewerName.text = reviewData.userName
            
            if (reviewData.link != nil) {
                self.webLink = reviewData.link
                webButton.isEnabled = true;
            } else
            {
                webButton.isEnabled = false;
            }
        }
        
        self.tableView.tableHeaderView = headerView
       self.tableView.rowHeight = UITableView.automaticDimension
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @objc func back(sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "returnback", sender:self)
    }

    // MARK: - Table view data source
/*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
*/
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Make the Navigation Bar background transparent
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.7064098716, green: 0.3690130115, blue: 0.2619327307, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize:24, weight: .bold)]
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
          super.viewWillTransition(to: size, with: coordinator)
          if UIDevice.current.orientation.isLandscape {
              print("Landscape")
            tableView.backgroundView = UIImageView(image: UIImage(named: "Group 11.png"))
          } else {
              print("Portrait")
            tableView.backgroundView = UIImageView(image: UIImage(named: "Group 12.png"))
          }
      }
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //if not using Tableview, need to conform to UIScrollViewDelegate


}

extension ReviewDetailsViewController {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let headerView = self.tableView.tableHeaderView as! StratchyTableHeaderView
        headerView.scrollViewDidScroll(scrollView: scrollView)
    }
}

extension ReviewDetailsViewController: LikeDelegate {
    func LikeButtonClicked(value: String) {
        reviewData!.attitude = value;
        print("New status: \(value)")
    }
}



