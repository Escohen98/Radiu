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
import Kingfisher
import Alamofire

class StreamViewController: UIViewController,WKUIDelegate,WebSocketDelegate {
    
    var streamID : String = "fucknew"
    
    var isPlaying = false
    
    let imgPlay = #imageLiteral(resourceName: "play.png")
    let imgPause = #imageLiteral(resourceName: "stop.png")
    
    @IBOutlet weak var playPauseBtn: UIButton!
    
    @IBAction func togglePlay(_ sender: UIButton!) {
        if isPlaying{
            isPlaying = false;
            playPauseBtn.isSelected = true
            let audioPlay = "document.getElementById('audio-preview'); audioPreview.play()"
            webview.evaluateJavaScript(audioPlay);
        } else {
            isPlaying = true;
            playPauseBtn.isSelected = false
            let audioPause = "document.getElementById('audio-preview'); audioPreview.pause()"
            webview.evaluateJavaScript(audioPause);
        }
    }
    
    
    @IBOutlet weak var webview: WKWebView!
    
    var socket: WebSocket!
    
    
    var profileImg : URL?
    var profileImageView : UIImageView?
    
    var comments: [Comment]?

    @IBOutlet weak var tableView: UITableView!
    
    
    //comment buttons
    @IBOutlet weak var postCommentBtn: UIButton!
    @IBOutlet weak var commentTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playPauseBtn.isSelected = true
        
        profileImg = URL(string: "https://www.gravatar.com/avatar/8849642f880e4fa6dd04634efd44a87f")
        //profileImageView = UIImageView(image: profileImg!)
        comments = [Comment(text: "test comment i'm trying to make this really long just to see what happens", image: profileImg!, username:"username"), Comment(text: "test comment", image: profileImg!, username:"username"), Comment(text: "test comment", image: profileImg!, username:"username")]
        
        
        //self.comments = CommentRepository.getComments()
        
        //Kyles shit
        let text = "wss://audio-api.kjgoodwin.me/ws?auth="
        let header = "Bearer " + Repository.currentAuthToken
        
        let apiRequest = "https://audio-api.kjgoodwin.me/v1/audio/directclient/" + streamID + "?auth=" + header;
        
        let encodedRequest = apiRequest.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        
        webview.uiDelegate = self;
        let myURL = URL(string: encodedRequest)
        let myRequest = URLRequest(url:myURL!)
        webview.load(myRequest)
        
       
        
        let thing = text + header
        let ding = thing.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        //let request = URLRequest(url: URL(string: ding)!)
        socket = WebSocket(url: URL(string: ding)!)
        print("socket")
        print((socket))
        socket.delegate = self
        socket.enabledSSLCipherSuites = [TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384, TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256]
        socket.connect()
        
        ///End
        
        //comment posting
        commentTextField.placeholder = "Type a comment"
        postCommentBtn.setTitle("Post", for: .normal)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150
        print("streamIDText");
        print(streamID)
    }
    
    deinit {
        socket.disconnect(forceTimeout: 0)
        socket.delegate = nil
    }
    
    @IBAction func postComment(_ sender: Any) {
        
        if let commentText = commentTextField.text  {
        
            let endpoint = "https://audio-api.kjgoodwin.me/v1/comments/" + streamID
            
            let parameters: Parameters = ["body": commentText]
            
            //post message
            Repository.sessionManager.request(endpoint,
                                              method: .post,
                                              parameters: parameters,
                                              encoding: JSONEncoding.default).validate()
                .responseJSON { response in
                    guard response.result.isSuccess else {
                        print(response.result)
                        return
                    }
            }
        
            commentTextField.text = ""
        }
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
                let messageChannelID = json["message"]["channelID"].stringValue
                if messageChannelID == streamID {
                    let messageCreator = json["message"]["creator"]["userName"].stringValue
                    let message = json["message"]["body"].stringValue
                    let imgString = json["message"]["creator"]["photoURL"].stringValue
                    let imageURL = URL(string: imgString)
                   
                    //append comment to list and render new row
                    comments!.append(Comment(text: message, image: imageURL!, username:messageCreator))
                    tableView.beginUpdates()
                    tableView.insertRows(at: [
                        NSIndexPath(row: comments!.count-1, section: 0) as IndexPath], with: .automatic)
                    tableView.endUpdates()
                    print(message)
                }
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
