//
//  IntroViewController.swift
//  soffa
//
//  Created by MR.CHEMALY on 11/19/17.
//  Copyright © 2017 we-devapp. All rights reserved.
//

import UIKit

class IntroViewController: BaseViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let introPageViewController = segue.destination as? IntroPageViewController {
            introPageViewController.introDelegate = self
        }
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

extension IntroViewController: IntroPageViewControllerDelegate {
    
    func introPageViewController(introPageViewController: IntroPageViewController,
                                    didUpdatePageCount count: Int) {
        pageControl.numberOfPages = count
    }
    
    func introPageViewController(introPageViewController: IntroPageViewController,
                                    didUpdatePageIndex index: Int) {
        
        if index == pageControl.numberOfPages-1 {
            pageControl.isHidden = true
        } else {
            pageControl.isHidden = false
        }
        
        pageControl.currentPage = index
    }
    
}
