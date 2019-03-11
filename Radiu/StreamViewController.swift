//
//  ViewController.swift
//  Radiu
//
//  Created by Student User on 3/5/19.
//  Copyright © 2019 University of Washington. All rights reserved.
//

import UIKit
import WebKit

class StreamViewController: UIViewController,WKUIDelegate {
    
    @IBAction func playButtonPress(_ sender: Any) {
        let audioPlay = "document.getElementById('audio-preview'); audioPreview.play()"
        webview.evaluateJavaScript(audioPlay);
    }
    
    @IBAction func pausePress(_ sender: Any) {
        
        let audioPause = "document.getElementById('audio-preview'); audioPreview.pause()"
        webview.evaluateJavaScript(audioPause);
    }
    
    
    @IBOutlet weak var webview: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        webview.uiDelegate = self;
        let myURL = URL(string: "https://audio-api.kjgoodwin.me/v1/audio/directclient/new")
        let myRequest = URLRequest(url:myURL!)
        webview.load(myRequest)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let ac = UIAlertController(title: "Hey, listen!", message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true)
        completionHandler()
        print("alert was fired in the")
    }
    
    
}

