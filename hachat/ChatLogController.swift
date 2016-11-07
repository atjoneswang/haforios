//
//  ChatLogController.swift
//  hachat
//
//  Created by jones wang on 2016/10/30.
//  Copyright © 2016年 J40. All rights reserved.
//

import UIKit
import Starscream
import Kingfisher
import FontAwesome_swift

class ChatLogController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let socket = WebSocket(url: URL(string: "wss://hachatserver.herokuapp.com/hachat")!)
    
    static let haText = "[[HA]]"
    
    lazy var inputContainerView: UIView = {
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = UIColor.white
        
        
        let uploadImageButton = UIButton(type: UIButtonType.system)
        uploadImageButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 26)
        uploadImageButton.setTitle(String.fontAwesomeIcon("fa-picture-o"), for: .normal)
        uploadImageButton.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(uploadImageButton)
        uploadImageButton.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 3).isActive = true
        uploadImageButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        uploadImageButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        uploadImageButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        uploadImageButton.tintColor = UIColor.darkGray
        
        
        containerView.addSubview(self.sendButton)
        
        self.sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        self.sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        self.sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        self.sendButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        self.sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        
        
        containerView.addSubview(self.inputTextfield)
        
        self.inputTextfield.leftAnchor.constraint(equalTo: uploadImageButton.rightAnchor, constant: 2).isActive = true
        self.inputTextfield.rightAnchor.constraint(equalTo: self.sendButton.leftAnchor).isActive = true
        self.inputTextfield.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        self.inputTextfield.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        
        let separatorLineView = UIView()
        separatorLineView.backgroundColor = UIColor.gray
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(separatorLineView)
        separatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        separatorLineView.leftAnchor.constraint(equalTo:containerView.leftAnchor).isActive = true
        separatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        return containerView
    }()
    
    let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.fontAwesome(ofSize: 24)
        button.setTitle(String.fontAwesomeIcon("fa-thumbs-o-up"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = UIColor.darkGray
        button.tag = 101
        return button
    }()
    
    lazy var inputTextfield: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Enter message.."
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.delegate = self
        return textfield
    }()
    
    var messages = [Message]()
    //var haMessages = [Hamessage]()
    
    let cellId = "cellId"
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        socket.delegate = self
        socket.connect()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        socket.disconnect()
        NotificationCenter.default.removeObserver(self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Ha Chat"
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.alwaysBounceVertical = true
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        
        collectionView?.keyboardDismissMode = .interactive
        
        setupKeyboardObservers()
        
        
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        inputContainerView.resignFirstResponder()
    }
    
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override var inputAccessoryView: UIView?{
        get {
            return inputContainerView
        }
    }
    
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDidShow), name: Notification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleButton), name: Notification.Name.UITextFieldTextDidChange, object: nil)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    func handleKeyboardDidShow(notification: Notification) {
        if messages.count > 0 {
            let indexpath = IndexPath(item: messages.count-1, section: 0)
            self.collectionView?.scrollToItem(at: indexpath, at: .top, animated: true)
        }
    }
    
    func handleButton() {
        if (inputTextfield.text?.trimmingCharacters(in: .whitespaces).characters.count)! > 0 {
            sendButton.setTitle(String.fontAwesomeIcon("fa-hand-pointer-o"), for: .normal)
            sendButton.tag = 100
        }else {
            
            sendButton.setTitle(String.fontAwesomeIcon("fa-thumbs-o-up"), for: .normal)
            sendButton.tag = 101
        }
    }
    
    func dismissKeyboard() {
        self.inputTextfield.resignFirstResponder()
    }
    
    func handleSend() {
        if !socket.isConnected {
            socket.connect()
        }
        if inputTextfield.text! != "" {
            
            
            sendMessage(inputTextfield.text!)
            
            inputTextfield.text = ""
        }else{
            let tag = sendButton.tag
            
            if tag == 101 {
                sendMessage(ChatLogController.haText)
            }
        }
    }
    
    private func sendMessage(_ text: String) {
        do {
            let msgdata = try createMessage(text)
            socket.write(data: msgdata)
        }catch{
            
        }
    }
    
    private func createMessage(_ text: String) throws -> Data{
        let msgBuilder = Hamessage.Builder()
        msgBuilder.event = "chat"
        msgBuilder.name = getFBName()
        msgBuilder.email = getFBId()
        msgBuilder.text = text
        msgBuilder.profileimage = getFBCover()
        return try msgBuilder.build().data()
    }
    
    func updateCollectionView() {
        let indexptah = IndexPath(item: messages.count-1, section: 0)
        collectionView?.performBatchUpdates({
            self.collectionView?.insertItems(at: [indexptah])
        }, completion: nil)
        collectionView?.scrollToItem(at: indexptah, at: .bottom, animated: true)
    }
    
    func setupCell(cell: ChatMessageCell, message: Message) {
        
        if message.text == ChatLogController.haText {
            cell.bubbleView.backgroundColor = UIColor.clear
        }
        
        if message.email! == getFBId() {
            if message.text == ChatLogController.haText {
                cell.bubbleView.backgroundColor = UIColor.clear
                cell.textView.isHidden = true
                cell.likeLabel.textColor = UIColor.blue
                cell.likeLabel.isHidden = false
                cell.likeLabelLeftAnchor?.isActive = false
                cell.likeLabelRightAnchor?.isActive = true
            }else{
                cell.bubbleView.backgroundColor = ChatMessageCell.blueBackgroundColor
                cell.textView.isHidden = false
                cell.likeLabel.isHidden = true
                cell.textView.textColor = UIColor.white
            }
            
            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false
            
            
            cell.profileImage.isHidden = true
        } else{
            if message.text == ChatLogController.haText {
                cell.bubbleView.backgroundColor = UIColor.clear
                cell.textView.isHidden = true
                cell.likeLabel.textColor = UIColor.blue
                cell.likeLabel.isHidden = false
                cell.likeLabelLeftAnchor?.isActive = true
                cell.likeLabelRightAnchor?.isActive = false
            }else{
                cell.bubbleView.backgroundColor = ChatMessageCell.grayBackgroundColor
                cell.textView.isHidden = false
                cell.likeLabel.isHidden = true
                cell.textView.textColor = UIColor.black
            }
            
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
            
            
            cell.profileImage.isHidden = false
            let url = URL(string: message.profileImage!)
            cell.profileImage.kf.setImage(with: url)
        }
    }
    
    func estimateFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        
        
        let message = messages[indexPath.item]
        cell.message = message
        setupCell(cell: cell, message: message)
        let textWidth = estimateFrameForText(text: message.text!).width
        if message.text == ChatLogController.haText{
            cell.bubbleViewWidthAnchor?.constant = 200
        }else{
            cell.bubbleViewWidthAnchor?.constant = textWidth + 32
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        
        let message = messages[indexPath.row]
        height = estimateFrameForText(text: message.text!).height + 14
        
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: height)
    }
    
}

extension ChatLogController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        handleButton()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
}

extension ChatLogController: WebSocketDelegate, WebSocketPongDelegate {
    func websocketDidConnect(socket: WebSocket) {
        let msgBuilder = Hamessage.Builder()
        msgBuilder.event = "join"
        msgBuilder.name = getFBName()
        msgBuilder.email = getFBMail()
        do {
            let msgbuild = try msgBuilder.build()
            socket.write(data: msgbuild.data())
        }catch {
            
        }
        
        print("websocket is connected")
    }
    
    func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
        if let e = error {
            print("websocket is disconnected: \(e.localizedDescription)")
        } else {
            print("websocket disconnected")
        }
    }
    
    func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        print("Received text: \(text)")
    }
    
    func websocketDidReceiveData(socket: WebSocket, data: Data) {
        
        do {
            let newmsg = try Hamessage.parseFrom(data: data)
            let message = Message(fromId: newmsg.name, msg: newmsg.text, img: newmsg.profileimage, email: newmsg.email)
            messages.insert(message, at: messages.count)
            
            updateCollectionView()
        }catch{
            
        }
        
    }
    
    func websocketDidReceivePong(socket: WebSocket, data: Data?) {
        print("Got pong! data: \(data?.count)")
    }
}
