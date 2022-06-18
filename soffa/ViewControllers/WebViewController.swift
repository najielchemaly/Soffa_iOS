//
//  WebViewController.swift
//  soffa
//
//  Created by MR.CHEMALY on 1/27/18.
//  Copyright © 2018 we-devapp. All rights reserved.
//

import UIKit
import Alamofire

class WebViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        let urlString = "http://securepayment.mitch.solutions/payment_form.aspx"
        let urlString = Services.init().getPaymentUrl()
        let url = URL(string: urlString)
        if let callbackUrl = url {
            var request = URLRequest(url: callbackUrl)
            let headers: HTTPHeaders = [
                "Authorization": "Bearer " + Services.init().ACCESS_TOKEN
            ]
            request.allHTTPHeaderFields = headers
            self.webView.loadRequest(request)
            self.webView.delegate = self
            
            self.showWaitOverlay(color: Colors.text)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonCancelTapped(_ sender: Any) {
        self.dismissVC()
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        if let scheme = request.url?.scheme {
            if scheme.lowercased() == "callback" {
                self.dismissVC()
                
                if let paymentVC = currentVC as? PaymentViewController {
                    paymentVC.getPaymentMethodData()
                }
                
                return false
            }
        }
        
        return true
    }

    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.removeAllOverlays()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
