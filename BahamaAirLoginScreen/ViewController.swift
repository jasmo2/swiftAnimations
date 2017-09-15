/*
 * Copyright (c) 2014-2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

// A delay function
// A delay function
func delay(_ seconds: Double, completion: @escaping ()->Void) {
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(Int(seconds * 1000.0))) {
        completion()
    }
}

class ViewController: UIViewController {
    
    // MARK: IB outlets
    
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var heading: UILabel!
    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    
    @IBOutlet var cloud1: UIImageView!
    @IBOutlet var cloud2: UIImageView!
    @IBOutlet var cloud3: UIImageView!
    @IBOutlet var cloud4: UIImageView!
    
    // MARK: further UI
    
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    let status = UIImageView(image: UIImage(named: "banner"))
    let label = UILabel()
    let messages = ["Connecting ...", "Authorizing ...", "Sending credentials ...", "Failed"]
    
    var statusPosition = CGPoint.zero
    
    // MARK: subviews
    var animationContainerView: UIView!
    // MARK: view controller methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        heading.layer.add(getFlyRightAnimation(), forKey: nil)
        
        //set up the UI
        loginButton.layer.cornerRadius = 8.0
        loginButton.layer.masksToBounds = true
        
        spinner.frame = CGRect(x: -20.0, y: 6.0, width: 20.0, height: 20.0)
        spinner.startAnimating()
        spinner.alpha = 0.0
        loginButton.addSubview(spinner)
        
        status.isHidden = true
        status.center = loginButton.center
        view.addSubview(status)
        
        
        label.frame = CGRect(x: 0.0, y: 0.0, width: status.frame.size.width, height: status.frame.size.height)
        label.font = UIFont(name: "HelveticaNeue", size: 18.0)
        label.textColor = UIColor(red: 0.89, green: 0.38, blue: 0.0, alpha: 1.0)
        label.textAlignment = .center
        status.addSubview(label)
        
        
        statusPosition = status.center
        //set up animation container
        animationContainerView = UIView(frame: view.bounds)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let flyRight = getFlyRightAnimation()
        flyRight.fillMode = kCAFillModeBoth
        flyRight.beginTime = CACurrentMediaTime() + 0.3

        username.layer.add(flyRight, forKey: nil)
        
        flyRight.beginTime = CACurrentMediaTime() + 0.45
        password.layer.add(flyRight, forKey: nil)
        
        loginButton.center.y += 30.0
        loginButton.alpha = 0.0
        
        username.layer.position.x = view.bounds.size.width / 2
        password.layer.position.x = view.bounds.size.width / 2
        
        let opacityAnimation = CABasicAnimation(keyPath: "alpha")
        opacityAnimation.fromValue = 0
        opacityAnimation.toValue = 1.0
        opacityAnimation.duration = 0.5
        opacityAnimation.fillMode = kCAFillModeBackwards
        
        opacityAnimation.beginTime = CACurrentMediaTime() + 0.5
        cloud2.layer.add(opacityAnimation, forKey: nil)
        
        opacityAnimation.beginTime = CACurrentMediaTime() + 0.7
        cloud2.layer.add(opacityAnimation, forKey: nil)
        
        opacityAnimation.beginTime = CACurrentMediaTime() + 0.9
        cloud3.layer.add(opacityAnimation, forKey: nil)
        
        opacityAnimation.beginTime = CACurrentMediaTime() + 1.1
        cloud4.layer.add(opacityAnimation, forKey: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.5, delay: 0.5,
                       usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: [],
                       animations: {
                        self.loginButton.center.y -= 30.0
                        self.loginButton.alpha = 1.0
        }, completion: nil)
        
        //create new view
        let newView = UIImageView(image: UIImage(named: "banner")!)
        newView.center = animationContainerView.center
        
        //add the new view via transition
        UIView.transition(
            with: animationContainerView,
            duration: 0.33,
            options: [.curveEaseOut, .transitionFlipFromBottom],
            animations: {
                self.animationContainerView.addSubview(newView)
        },
            completion: nil
        )
        
        
    }
    
    // MARK: further methods
    
    @IBAction func login() {
        view.endEditing(true)
        UIView.animate(withDuration: 1.5, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.1,options: [], animations: {
            self.loginButton.bounds.size.width += 80
        }, completion: { _ in
            self.showMessage(index: 0)
        })
        
        UIView.animate(withDuration: 0.33, delay: 0.0, usingSpringWithDamping:
            0.7, initialSpringVelocity: 0.0, options: [], animations: {
                self.loginButton.center.y += 60.0

                self.spinner.center = CGPoint(x: 40.0, y: (self.loginButton.bounds.height / 2))
                self.spinner.alpha = 1
        }, completion: nil)
        
        let tintColor = UIColor(red: 0.85, green: 0.83, blue: 0.45, alpha: 1.0)
        
        tintBackgroundColor(layer: loginButton.layer, toColor: tintColor)
        roundCorners(layer: loginButton.layer, toRadius: 25.0)
        
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextField = (textField === username) ? password : username
        nextField?.becomeFirstResponder()
        return true
    }
    
    func showMessage(index: Int) {
        label.text = messages[index]
        UIView.transition(with: status, duration: 0.33,
                          options: [.curveEaseOut, .transitionCurlDown],
                          animations: {
                            self.status.isHidden = false
        },
          completion: {_ in
            delay(2) {
                if index < 1 {
                    self.removeMessage(index: index)
                } else {
                    self.resetForm()
                }
            }
        } )
    }
    
    func getFlyRightAnimation() -> CABasicAnimation {
        let flyRight = CABasicAnimation(keyPath: "position.x")
        flyRight.fromValue = -view.bounds.size.width/2
        flyRight.toValue = view.bounds.size.width/2
        flyRight.duration = 0.5
        
        return flyRight
    }
    
    func tintBackgroundColor(layer: CALayer, toColor: UIColor) {
        let animationLayer = CABasicAnimation(keyPath: "backgroundColor")
        animationLayer.fromValue = layer.backgroundColor
        animationLayer.toValue = toColor.cgColor
        animationLayer.duration = 1.0
        
        layer.add(animationLayer, forKey: nil)
        layer.backgroundColor = toColor.cgColor
    }

    
    
    func removeMessage(index: Int) {
        UIView.animate(withDuration: 0.33, delay: 0.0, options: [],
                       animations: {
                        self.status.center.x += self.view.frame.size.width
        },
                       completion: {_ in
                        self.status.isHidden = true
                        self.status.center = self.statusPosition
                        self.showMessage(index: index+1)
        }
        )
    }
    
    func roundCorners(layer: CALayer, toRadius: CGFloat) {
        let animationLayer = CABasicAnimation(keyPath: "cornerRadius")
        animationLayer.fromValue = layer.cornerRadius
        animationLayer.toValue = toRadius
        animationLayer.duration = 0.33
        animationLayer.isRemovedOnCompletion = false
        
        layer.add(animationLayer, forKey: nil)
        layer.cornerRadius = toRadius
    }

    func resetForm() {
       UIView.transition(with: status, duration: 0.2,
                         options: [.transitionCurlUp],
                         animations: {
                            self.status.isHidden =  true
                            },
                         completion: nil
        )
        UIView.animate(withDuration: 0.2, delay: 0.2,
                       options: [.curveEaseOut],
                       animations: {
                        self.spinner.center = CGPoint(x: -20.0, y: 16.0)
                        self.spinner.alpha = 0

                        self.loginButton.bounds.size.width -= 80.0
                        self.loginButton.center.y -= 60.0
        }, completion: {_ in
            let tintColor = UIColor(red: 0.63, green: 0.84, blue: 0.35, alpha: 1.0)
            self.tintBackgroundColor(layer: self.loginButton.layer, toColor: tintColor)
        })

        roundCorners(layer: self.loginButton.layer, toRadius: 10.0)
    }
}
