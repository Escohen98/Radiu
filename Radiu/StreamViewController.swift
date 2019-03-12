//
//  ViewController.swift
//  Radiu
//
//  Created by Student User on 3/5/19.
//  Copyright © 2019 University of Washington. All rights reserved.
//

import UIKit
import WebKit
import Starscream
import SwiftyJSON

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        webview.uiDelegate = self;
        let myURL = URL(string: "https://audio-api.kjgoodwin.me/v1/audio/directclient/new")
        let myRequest = URLRequest(url:myURL!)
        webview.load(myRequest)
        
        
        let ding = "wss://info-api.kylegoodwin.net/ws?auth=Bearer N8i27sDFQmafHJrQeVzoMHta6BdhCS7sCVfWt7t2-N42XVeu27yXQeQWIrpBDyRmkFgc6Op1YGkYryfQvK_eGA==".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        //let request = URLRequest(url: URL(string: ding)!)
        socket = WebSocket(url: URL(string: ding)!)
        socket.delegate = self
        socket.enabledSSLCipherSuites = [TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384, TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256]
        socket.connect()
    }
    
    deinit {
        socket.disconnect(forceTimeout: 0)
        socket.delegate = nil
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
                let message = json["message"]["body"].stringValue
                print(message)
            }
        }
    }
    
    public func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("data form websocket")
        print(data)
    }
    
    
}


