//
//  IntroPageViewController.swift
//  soffa
//
//  Created by MR.CHEMALY on 11/19/17.
//  Copyright © 2017 we-devapp. All rights reserved.
//

import UIKit

class IntroPageViewController: UIPageViewController {
    
    weak var introDelegate: IntroPageViewControllerDelegate?

    private(set) lazy var pagesViewControllers: [UIViewController] = {
        return [self.introViewController(intro: "Intro1"),
                self.introViewController(intro: "Intro2"),
                self.introViewController(intro: "Intro3"),
                self.introViewController(intro: "Intro4")]
    }()
    
    private func introViewController(intro: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil) .
            instantiateViewController(withIdentifier: "\(intro)ViewController")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dataSource = self
        delegate = self
        
        if let firstViewController = pagesViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
        
        introDelegate?.introPageViewController(introPageViewController: self, didUpdatePageCount: pagesViewControllers.count)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

// MARK: UIPageViewControllerDataSource

extension IntroPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pagesViewControllers.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let pagesViewControllersCount = pagesViewControllers.count
        
        guard pagesViewControllersCount != nextIndex else {
            return nil
        }
        
        guard pagesViewControllersCount > nextIndex else {
            return nil
        }
        
        return pagesViewControllers[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pagesViewControllers.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard pagesViewControllers.count > previousIndex else {
            return nil
        }
        
        return pagesViewControllers[previousIndex]
    }
    
}

extension IntroPageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        if let firstViewController = viewControllers?.first,
            let index = pagesViewControllers.index(of: firstViewController) {
            introDelegate?.introPageViewController(introPageViewController: self, didUpdatePageIndex: index)
        }
    }
    
}

protocol IntroPageViewControllerDelegate: class {
    
    /**
     Called when the number of pages is updated.
     
     - parameter tutorialPageViewController: the TutorialPageViewController instance
     - parameter count: the total number of pages.
     */
    func introPageViewController(introPageViewController: IntroPageViewController,
                                    didUpdatePageCount count: Int)
    
    /**
     Called when the current index is updated.
     
     - parameter tutorialPageViewController: the TutorialPageViewController instance
     - parameter index: the index of the currently visible page.
     */
    func introPageViewController(introPageViewController: IntroPageViewController,
                                    didUpdatePageIndex index: Int)
    
}
