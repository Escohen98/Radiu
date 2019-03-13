//
//  StreamViewController.swift
//  Radiu
//
//  Created by Conor Reiland on 3/7/19.
//  Copyright © 2019 University of Washington. All rights reserved.
//

import UIKit
import WebKit
import SwiftyJSON
import Starscream




class StreamViewController: UIViewController,WKUIDelegate,WebSocketDelegate {
    
    @IBAction func playButtonPress(_ sender: Any) {
        let audioPlay = "document.getElementById('audio-preview'); audioPreview.play()"
        webview.evaluateJavaScript(audioPlay);
    }
    
    @IBAction func pausePress(_ sender: Any) {
        
        let audioPause = "document.getElementById('audio-preview'); audioPreview.pause()"
        webview.evaluateJavaScript(audioPause);
    }
    
    @IBOutlet weak var webview: WKWebView!
    
    var socket: WebSocket!
    
    
    var profileImg : UIImage?
    var profileImageView : UIImageView?
    
    var comments: [Comment]?

    @IBOutlet weak var tableView: UITableView!
    
    
    //comment buttons
    @IBOutlet weak var postCommentBtn: UIButton!
    @IBOutlet weak var commentTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImg = UIImage(named: "profile-user")
        profileImageView = UIImageView(image: profileImg)
        comments = [Comment(text: "test comment i'm trying to make this really long just to see what happens", image: profileImageView!, username:"username"), Comment(text: "test comment", image: profileImageView!, username:"username"), Comment(text: "test comment", image: profileImageView!, username:"username")]
        
        //self.comments = CommentRepository.getComments()
        
        //Kyles shit
        webview.uiDelegate = self;
        let myURL = URL(string: "https://audio-api.kjgoodwin.me/v1/audio/directclient/new")
        let myRequest = URLRequest(url:myURL!)
        webview.load(myRequest)
        
        let text = "wss://info-api.kylegoodwin.net/ws?auth="
        let header = "Bearer weXcEkKg4fZEVgtNhjQ7l1hwBKzQm9XMFJk7BZ7rhcsEpyHDRBIV-CiPQydsyVeVlxczgcNPRHj7T67s7uBqaw=="
        
        let thing = text + header
        let ding = thing.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        //let request = URLRequest(url: URL(string: ding)!)
        socket = WebSocket(url: URL(string: ding)!)
        socket.delegate = self
        socket.enabledSSLCipherSuites = [TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384, TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256]
        socket.connect()
        
        ///End
        
        //comment posting
        commentTextField.placeholder = "Type a comment"
        postCommentBtn.setTitle("Post", for: .normal)
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    deinit {
        socket.disconnect(forceTimeout: 0)
        socket.delegate = nil
    }
    
    @IBAction func postComment(_ sender: Any) {
        
        let commentText = commentTextField.text
        //post the comment
        print(commentText)
        
        commentTextField.text = ""
    }
    
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let ac = UIAlertController(title: "Hey, listen!", message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true)
        completionHandler()
        print("alert was fired in the")
    }
    
    public func websocketDidConnect(socket: WebSocketClient) {
        print("websocket connected")
        
    }
    
    public func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        
    }
    
    public func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print("message from websocket")
        print(text)
        
        if let data = text.data(using: .utf8) {
            if let json = try? JSON(data: data) {
                let messageCreator = json["message"]["creator"].stringValue
                let message = json["message"]["body"].stringValue
                comments!.append(Comment(text: message, image: profileImageView!, username:messageCreator))
                tableView.beginUpdates()
                tableView.insertRows(at: [
                    NSIndexPath(row: comments!.count-1, section: 0) as IndexPath], with: .automatic)
                tableView.endUpdates()
                print(message)
            }
        }
    }
    
    public func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("data form websocket")
        print(data)
    }

}

extension StreamViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let com = comments![indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTVCell") as! CommentTVCell
        
        cell.setComment(comment: com)
        return cell
    }
}
