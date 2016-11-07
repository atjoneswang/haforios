//
//  ChatMessageCell.swift
//  hachat
//
//  Created by jones wang on 2016/10/31.
//  Copyright © 2016年 J40. All rights reserved.
//

import UIKit
import FontAwesome_swift

class ChatMessageCell: UICollectionViewCell {
    
    var message: Message? {
        didSet {
            if message != nil {
                textView.text = message?.text
                textView.textColor = UIColor.white
                self.fromId = message?.fromId
            }
            
        }
    }
    
    static let grayBackgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
    static let blueBackgroundColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
    var fromId: String?
    let textView: UITextView = {
        let tv = UITextView()
        //tv.text = "sample text"
        tv.font = UIFont.systemFont(ofSize: 16)
        //tv.textColor = UIColor.white
        tv.backgroundColor = UIColor.clear
        tv.isEditable = false
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    let likeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.fontAwesome(ofSize: 32)
        label.text = String.fontAwesomeIcon("fa-thumbs-o-up")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = ChatMessageCell.blueBackgroundColor
        view.layer.cornerRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        return view
    }()
    
    let profileImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 14
        image.layer.masksToBounds = true
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    var bubbleViewWidthAnchor: NSLayoutConstraint?
    var bubbleViewRightAnchor: NSLayoutConstraint?
    var bubbleViewLeftAnchor: NSLayoutConstraint?
    
    var likeLabelRightAnchor:NSLayoutConstraint?
    var likeLabelLeftAnchor:NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(profileImage)
        addSubview(bubbleView)
        
        profileImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 6).isActive = true
        profileImage.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 28).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 28).isActive = true
        
        bubbleViewRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
        bubbleViewRightAnchor?.isActive = true
        
        bubbleViewLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 8)
        //bubbleViewLeftAnchor?.isActive = true
        
        
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        bubbleViewWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleViewWidthAnchor?.isActive = true
        
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        bubbleView.addSubview(textView)
        
        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
        textView.topAnchor.constraint(equalTo: bubbleView.topAnchor).isActive = true
        textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
        textView.heightAnchor.constraint(equalTo: bubbleView.heightAnchor).isActive = true
        
        bubbleView.addSubview(likeLabel)
        
        likeLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor).isActive = true
        
        likeLabelRightAnchor = likeLabel.rightAnchor.constraint(equalTo: bubbleView.rightAnchor, constant: 10)
        likeLabelRightAnchor?.isActive = true
        
        likeLabelLeftAnchor = likeLabel.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 10)
        
        likeLabel.heightAnchor.constraint(equalTo: bubbleView.heightAnchor).isActive = true
        likeLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
