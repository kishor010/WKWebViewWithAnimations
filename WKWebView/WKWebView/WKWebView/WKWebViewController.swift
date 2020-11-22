//
//  WKWebViewController.swift
//  WKWebView
//
//  Created by Kishor Pahalwani on 30/05/18.
//  Copyright © 2018 Kishor Pahalwani. All rights reserved.
//

import UIKit
import WebKit

class WKWebViewController: UIViewController {

    var webView: WKWebView?
    @IBOutlet weak var barView: UIView!
    @IBOutlet weak var textFieldURL: UITextField!
    @IBOutlet weak var btnFor: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    
    let animation = CATransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFieldURL.delegate = self
        
        setUpWebView()
        
        navigationItem.titleView = barView
        
        btnBack.isEnabled = false
        btnFor.isEnabled = false
        
        btnBack.setTitleColor(.lightGray, for: .normal)
        btnFor.setTitleColor(.lightGray, for: .normal)
        
        self.view.bringSubview(toFront: btnBack)
        self.view.bringSubview(toFront: btnFor)
        self.view.bringSubview(toFront: progressView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let alert = UIAlertController(title: "Error", message: NSLocalizedString("error", comment: ""), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    fileprivate func setUpWebView() {
        
         self.webView = WKWebView(frame: CGRect(x: 0, y: 104, width: view.frame.width, height: view.frame.height - 194))
        //view.addSubview(webView!)
        view.insertSubview(webView!, belowSubview: progressView)
        
        //webView?.translatesAutoresizingMaskIntoConstraints = false
        //let height = NSLayoutConstraint(item: webView!, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 1, constant: 0)
        //let width = NSLayoutConstraint(item: webView!, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: 0)
        //view.addConstraints([height, width])
        
        if let url = URL(string:"http://www.google.com") {
            let request = URLRequest(url: url)
            webView?.load(request)
        }
        
        self.webView?.navigationDelegate = self
        self.webView?.uiDelegate = self
        webView?.addObserver(self, forKeyPath: "loading", options: .new, context: nil)
        webView?.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        webView?.allowsBackForwardNavigationGestures = true
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        //barView.frame = CGRect(x:0, y: 0, width: size.width, height: 30)
    }
    
    @IBAction func forwardButtonAction(_ sender: Any) {
         animation.subtype = kCATransitionFromRight //kCATransitionFromRight //kCATransitionFromBottom //kCATransitionFromTop //kCATransitionFromLeft  //"fromBottom" //"fromRight" //"fromLeft" //kCAFillModeForwards //kCATransitionMoveIn //"fromTop"
        animatePage()
        webView?.goForward()
    }
    
    
    @IBAction func backButtonAction(_ sender: Any) {
        animation.subtype = kCATransitionFromLeft //kCATransitionFromRight //kCATransitionFromBottom //kCATransitionFromTop //kCATransitionFromLeft  //"fromBottom" //"fromRight" //"fromLeft" //kCAFillModeForwards //kCATransitionMoveIn //"fromTop"
         animatePage()
         webView?.goBack()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "loading") {
            
            btnBack.isEnabled = webView?.canGoBack ?? false
            btnFor.isEnabled = webView?.canGoForward ?? false
            
            if btnBack.isEnabled {
                btnBack.setTitleColor(.black, for: .normal)
            }
            
            else {
                btnBack.setTitleColor(.lightGray, for: .normal)
            }
            
            if btnFor.isEnabled {
                btnFor.setTitleColor(.black, for: .normal)
            }
            
            else {
                btnFor.setTitleColor(.lightGray, for: .normal)
            }
        }
        
        if (keyPath == "estimatedProgress") {
            progressView.isHidden = webView?.estimatedProgress == 1
            progressView.setProgress(Float(webView?.estimatedProgress ?? 0), animated: true)
        }
    }
}

//Web Page Animation
extension WKWebViewController {
    fileprivate func animatePage() {
        
        animation.delegate = self
        animation.duration = 1.0
        animation.startProgress = 0.5
        animation.endProgress = 1
        
        animation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        
        animation.type = "pageCurl" //kCATransitionReveal//kCATransitionPush//kCATransitionMoveIn //kCATransitionFade //"pageCurl"
        
        animation.isRemovedOnCompletion = false
        //animation.fillMode = kCAFillModeForwards//"extended"
        webView?.layer.add(animation, forKey: "WebPageCurl")
    }
}

//MARK:- Text Field Delegates
extension WKWebViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textFieldURL.resignFirstResponder()
        
        if let url = URL(string: "http://" + textFieldURL.text! + ".com") {
            let urlReq = URLRequest(url: url)
            webView?.load(urlReq)
        }
        
        //webView?.load(URLRequest(url: URL(string: "http://" + textFieldURL.text! + ".com" )!))
        return false
    }
}

extension WKWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
         progressView.setProgress(0.0, animated: false)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
}

extension WKWebViewController: WKUIDelegate {
    /*func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressView.setProgress(0.0, animated: false)
    }*/
}

extension WKWebViewController: CAAnimationDelegate {
    
    func animationDidStart(_ anim: CAAnimation) {
    
        print("start")
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        print("finish")
    }
}






/*fileprivate func leftPageCurl() {
    let tr = CATransition()
    tr.duration = 0.5
    tr.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)//[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    tr.type = "pageUnCurl"
    tr.subtype = "fromLeft"
    tr.fillMode = kCAFillModeForwards;
    tr.fillMode = "extended"
    tr.isRemovedOnCompletion = false
    tr.delegate=self;
    webView?.layer.add(tr, forKey: "pageCurlAnimation")
}

fileprivate func rightPageCurl() {
    /*CATransition *tr=[CATransition  animation];
     tr.duration=0.5;
     tr.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
     tr.type = @"pageUnCurl";
     tr.Subtype=@"fromRight";
     tr.fillMode = kCAFillModeForwards;
     [tr setFillMode:@"extended"];
     [tr setRemovedOnCompletion:NO];
     
     [self.imgV setImage:@"Image1.png"];
     
     tr.delegate=self;
     [self.imgV.layer addAnimation:tr forKey:@"pageCurlAnimation"];*/
}

fileprivate func animatePage() {
    
    let animation = CATransition()//= [CATransition animation];
    animation.delegate = self
    animation.duration = 1.0
    animation.startProgress = 0.5
    animation.endProgress = 1
    
    animation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)//CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseOut)//kCAMediaTimingFunctionEaseInEaseOut)//kCAMediaTimingFunctionEaseOut
    
    animation.type = "pageCurl"//kCATransitionReveal//kCATransitionPush//kCATransitionMoveIn //kCATransitionFade //"pageCurl"
    
    animation.subtype = kCATransitionFromTop //kCATransitionFromRight //kCATransitionFromBottom //kCATransitionFromTop //kCATransitionFromLeft  //"fromBottom" //"fromRight" //"fromLeft" //kCAFillModeForwards //kCATransitionMoveIn //"fromTop"
    
    animation.isRemovedOnCompletion = false
    //animation.fillMode = kCAFillModeForwards//"extended"
    
    animation.isRemovedOnCompletion = false
    webView?.layer.add(animation, forKey: "WebPageCurl")
    
    /*let animation = CATransition()//= [CATransition animation];
     animation.delegate = self
     animation.duration = 1.0
     animation.startProgress = 0.5
     animation.endProgress = 1
     animation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionLinear)//kCAMediaTimingFunctionEaseInEaseOut)//kCAMediaTimingFunctionEaseOut
     animation.type = "pageCurl"
     
     animation.subtype = "fromRight"//"fromLeft"//kCAFillModeForwards//kCATransitionMoveIn
     animation.isRemovedOnCompletion = false
     animation.fillMode = "extended"
     animation.isRemovedOnCompletion = false
     webView?.layer.add(animation, forKey: "WebPageCurl")*/
    
    
    /*[UIView beginAnimations:nil context:NULL];
     [UIView setAnimationDuration: 0.90];
     [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.navigationController.view cache:YES];
     [self.imgV setImage:@"Image2.png"];
     [UIView commitAnimations];*/
    
    /*/* The amount of progress through to the transition at which to begin
     * and end execution. Legal values are numbers in the range [0,1].
     * `endProgress' must be greater than or equal to `startProgress'.
     * Default values are 0 and 1 respectively. */
     
     @property float startProgress;
     @property float endProgress;*/
 
 //[animation setType:kcat];
 /*[animation setSubtype:kCATransitionMoveIn];
 
 [animation setRemovedOnCompletion:NO];
 [animation setFillMode: @"extended"];
 [animation setRemovedOnCompletion: NO];
 [[myWebView layer] addAnimation:animation forKey:@"WebPageCurl"];*/
}*/

