//
//  SplashViewController.swift
//  Universitet
//
//  Created by Karen Khachatryan on 11.09.24.
//

import UIKit

class SplashViewController: UIViewController {
    
    private var splashPageViewController: SplashPageViewController!

    @IBOutlet weak var firstDot: UIButton!
    @IBOutlet weak var secondDot: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var firstDotWidthConst: NSLayoutConstraint!
    @IBOutlet weak var secondDotWidthConst: NSLayoutConstraint!
    @IBOutlet weak var termsOfUse: UIButton!
    @IBOutlet weak var privacyPolicy: UIButton!
    private var currentIndex = -1
    private var pages: [UIViewController] = [FirstSplashViewController(nibName: "FirstSplashViewController", bundle: nil), SecondSplashViewController(nibName: "SecondSplashViewController", bundle: nil)]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        setCurrentPage(index: 0)
        nextButton.titleLabel?.font = .semibold(size: 18)
        termsOfUse.titleLabel?.font = .medium(size: 12)
        privacyPolicy.titleLabel?.font = .medium(size: 12)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let desinationViewController = segue.destination as? SplashPageViewController {
            splashPageViewController = desinationViewController
            splashPageViewController.delegate = self
            splashPageViewController.dataSource = self
        }
    }
    
    func pageChangedTo(index: Int) {
        switch index {
        case 0:
            firstDot.backgroundColor = .white
            secondDot.backgroundColor = #colorLiteral(red: 0.1674384475, green: 0.1674384475, blue: 0.1674384475, alpha: 1)
            firstDotWidthConst.constant = 40
            secondDotWidthConst.constant = 11
        case 1:
            secondDot.backgroundColor = .white
            firstDot.backgroundColor = #colorLiteral(red: 0.1674384475, green: 0.1674384475, blue: 0.1674384475, alpha: 1)
            secondDotWidthConst.constant = 40
            firstDotWidthConst.constant = 11
        default:
            break
        }
    }
    
    func setCurrentPage(index: Int) {
        if index == currentIndex { return }
        let direction: UIPageViewController.NavigationDirection = index < currentIndex ? .reverse : .forward
        currentIndex = index
        splashPageViewController.setViewControllers([pages[index]], direction: direction, animated: true, completion: nil)
        pageChangedTo(index: index)
    }
    
    @IBAction func chooseFirstPage(_ sender: UIButton) {
        setCurrentPage(index: 0)
    }

    @IBAction func chooseSecondPage(_ sender: UIButton) {
        setCurrentPage(index: 1)
    }

    @IBAction func clickedNext(_ sender: UIButton) {
        if currentIndex == 0 {
            setCurrentPage(index: 1)
        } else {
            UserDefaults.standard.set(true, forKey: .hasLaunchedBeforeKey)
            let welcomeVC = WelcomeViewController(nibName: "WelcomeViewController", bundle: nil)
            self.navigationController?.pushViewController(welcomeVC, animated: true)
        }
    }
    
}

extension SplashViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let currentPage = pageViewController.viewControllers?.first {
            let index = pages.firstIndex(of: currentPage)!
            currentIndex = index
            pageChangedTo(index: index)
        }
    }
}

extension SplashViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = self.pages.firstIndex(of: viewController)!
        if (index == 0) {
            return nil
        } else {
            return self.pages[index - 1]
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = self.pages.firstIndex(of: viewController)!
        if (index == self.pages.count - 1) {
            return nil
        } else {
            return self.pages[index + 1]
        }
    }
}

extension UIViewController {
    func setAsRoot() {
        UIApplication.shared.windows.first?.rootViewController = self
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
}
