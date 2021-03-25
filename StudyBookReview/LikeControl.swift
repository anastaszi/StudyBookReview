//
//  LikeControl.swift
//  StudyBookReview
//
//  Created by Anastasia Zimina on 3/24/21.
//

import UIKit

protocol LikeDelegate: class {
    func LikeButtonClicked(value: String)
}

@IBDesignable class LikeControl: UIStackView {
    
    weak var delegate: LikeDelegate? = nil
    
    var status: String = "" {
        didSet {
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLikeButton()
        setupDislikeButton()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupLikeButton()
        setupDislikeButton()
       // fatalError("init(coder:) has not been implemented")
    }
    
    @IBInspectable var buttonSize: CGSize = CGSize(width: 44.0, height: 44.0) {
        didSet {
            setupLikeButton()
            setupDislikeButton()
        }
    }
    var buttonArray = [UIButton]()
    
    private func setupLikeButton() {
        let button = UIButton()
        let likeImgFill = UIImage(named: "emoji-heart-eyes-fill");
        let likeImg = UIImage(named: "emoji-heart-eyes");
        //button.backgroundColor = #colorLiteral(red: 0, green: 0.6900390387, blue: 0.5257087946, alpha: 1)
        //button.setTitle("Agree", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: buttonSize.height).isActive = true;
        button.widthAnchor.constraint(equalToConstant: buttonSize.width).isActive = true;
        button.setImage(likeImg, for: .normal)
        button.setImage(likeImgFill, for: .selected)
        button.addTarget(self, action: #selector(likeBtnTapped(button:)), for: .touchUpInside)
        buttonArray.append(button)
        addArrangedSubview(button)
    }
    
    private func setupDislikeButton(){
        let button = UIButton()
        let dislikeImgFill = UIImage(named: "emoji-frown-fill");
        let dislikeImg = UIImage(named: "emoji-frown");
        button.translatesAutoresizingMaskIntoConstraints = false
        //button.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)
        button.setImage(dislikeImg, for: .normal)
        button.setImage(dislikeImgFill, for: .selected)
        button.heightAnchor.constraint(equalToConstant: buttonSize.height).isActive = true;
        button.widthAnchor.constraint(equalToConstant: buttonSize.width).isActive = true;
        button.addTarget(self, action: #selector(dislikeBtnTapped(button:)), for: .touchUpInside)
        buttonArray.append(button)
        addArrangedSubview(button)
        
    }
    
    @objc func dislikeBtnTapped(button: UIButton) {
        print("dislike")
        if status == "dislike" {
            status = ""
            button.isSelected = false;
        } else {
            status = "dislike"
            let _ = buttonArray.map({$0.isSelected = false})
            button.isSelected = true;
        }
        
        guard let delegate = delegate else {return}
        delegate.LikeButtonClicked(value: status)
    }
    @objc func likeBtnTapped(button: UIButton) {
        print("like")
        if status == "like" {
            status = ""
            button.isSelected = false;
        } else {
            status = "like"
            let _ = buttonArray.map({$0.isSelected = false})
            button.isSelected = true;
        }
        
        guard let delegate = delegate else {return}
        delegate.LikeButtonClicked(value: status)
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
