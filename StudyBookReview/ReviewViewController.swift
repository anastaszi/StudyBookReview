//
//  ViewController.swift
//  StudyBookReview
//
//  Created by Anastasia Zimina on 3/21/21.
//

import UIKit
import PhotosUI
import os.log


class ReviewViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, PHPickerViewControllerDelegate {
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var authorField: UITextField!
    @IBOutlet weak var reviewField: UITextView!
    @IBOutlet weak var bookImg: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var amazonLinkField: UITextField!
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    var newReview: ReviewData?
    var imgUpdated = false;
    
    weak var activeField: UIView?
    
    var textViewHeight: CGFloat = 0;
    
    @IBAction func addReview(_ sender: UIButton) {
        let defaultAction = UIAlertAction(title: "OK",
                            style: .default) { (action) in
            // Respond to user selection of the action.
            print("User pressed OK")
        }
        // Create and configure the alert controller.
        let alert = UIAlertController(title: "Tile is empty",
             message: "You need to add title.",
             preferredStyle: .alert)
        alert.addAction(defaultAction)
        
        if titleField.text?.isEmpty == true {
            self.present(alert, animated: true) {
                  // The alert was presented
                print("alert was presented")
            }
        }else{
            print("save data")
        }
    }
    
    @IBAction func imgUpload(_ sender: UITapGestureRecognizer) {
        reviewField.resignFirstResponder();
        var configuration = PHPickerConfiguration();
        configuration.selectionLimit = 1;
        configuration.filter = .images;
        
        let picker = PHPickerViewController(configuration: configuration);
        picker.delegate = self;
        present(picker, animated: true);
        imgUpdated = true;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        reviewField.delegate = self;
        
        titleField.delegate = self;
        titleField.tag = 0;
              
        authorField.delegate = self;
        authorField.tag = 1;
        
        amazonLinkField.delegate = self;
        amazonLinkField.tag = 2;
        
        reviewField.placeholder = "Enter your review";
        reviewField.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)));
        //reviewField.backgroundColor = .secondarySystemBackground
        reviewField.textColor = .secondaryLabel;
        reviewField.font = UIFont.preferredFont(forTextStyle: .body);
        reviewField.layer.cornerRadius = 4;
        reviewField.textContainerInset = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10);
        reviewField.layer.borderWidth = 1;
        reviewField.layer.borderColor = UIColor.lightGray.cgColor;
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidShow(notification:)),
                name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(notification:)),
                name: UIResponder.keyboardWillHideNotification, object: nil)
        updateSaveButtonState()
    }
    
    @objc func keyboardDidShow(notification:NSNotification) {
         let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
         guard let activeField = activeField, let keyboardHeight = keyboardSize?.height else { return }

         let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardHeight, right: 0.0)
         scrollView.contentInset = contentInsets
         scrollView.scrollIndicatorInsets = contentInsets
         var activeRect = activeField.convert(activeField.bounds,to: scrollView)
         if activeField is UITextView
         {
             activeRect.size.height = reviewField.contentSize.height+20
         }
         scrollView.scrollRectToVisible(activeRect, animated: true)
     }
     
     @objc func keyboardWillBeHidden(notification:NSNotification) {
         
     }
    
    deinit {
          NotificationCenter.default.removeObserver(self)
      }
    
    @objc func tapDone(sender: Any) {
        self.view.endEditing(true);
        updateSaveButtonState()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // this method and the next one are override of the Delegate protocol methods for TextView
        // main goal is too hide keayboard afthe the input of the second field is done and auto focus on the second field after the first input field is done.
        
        //textField.resignFirstResponder()
        
        //Option2
//        if (textField.tag == 0) {
//            titleTxtfield.resignFirstResponder()
//        }
//        if (textField.tag == 1) {
//            nameTxtfield.resignFirstResponder()
//        }

        //Option3
        switch textField {
            case titleField:
                authorField.becomeFirstResponder()
            case authorField:
                authorField.resignFirstResponder()
            default:
                textField.resignFirstResponder()
            }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
        saveButton.isEnabled = false;
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // this methods allows read and process information
        print(textField.text ?? "  ")
        activeField = nil
        updateSaveButtonState()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        activeField = textView
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print(textView.text ?? "  ")
        activeField = nil
        updateSaveButtonState()
    }
    
    func textViewDidChange(_ textView: UITextView) {
          if activeField != nil && textViewHeight>0 {
              if textView.contentSize.height > textViewHeight && textView.contentSize.height <= activeField!.bounds.height
              {
                  var activeRect = activeField!.convert(activeField!.bounds,to: scrollView)
                  activeRect.size.height = textView.contentSize.height
                  scrollView.scrollRectToVisible(activeRect, animated: true)
              }
          }
          textViewHeight = textView.contentSize.height
      }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        let imgToUpload: UIImage;
        if (!imgUpdated) {
            imgToUpload = UIImage(named: "book")!;
        }
        else {
            imgToUpload = bookImg.image!
        }
        
        
        newReview = ReviewData.init(id: 45, title: titleField.text!, author: authorField.text, review: reviewField.text, photo: imgToUpload, attitude: "", userName: "Anastasia", link: URL(string: amazonLinkField.text ?? ""))
    }
    
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let review = reviewField.text ?? ""
        let title = titleField.text ?? ""
        saveButton.isEnabled = !review.isEmpty && !title.isEmpty
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true);
        
        if let itemProvider = results.first?.itemProvider,
           itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in DispatchQueue.main.async {
                    guard let self = self, let image = image as? UIImage else {
                        print(error ?? "Cannot load image")
                        return
                }
                    self.bookImg.image = image;
            }}
            
        }
        
    }

}

