//
//  ManageOnBoardingViewController.swift
//  CalculateNote
//
//  Created by Onur Emren on 4.01.2024.
//

import UIKit

class ManageOnBoardingViewController: UIPageViewController, Coordinating {
    var coordinator: Coordinator?
    var pages = [UIViewController]()
    let pageControl = UIPageControl()
    let initialPage = 0
    let skipButton = UIButton()
    let nextButton = UIButton()
    
    var skipButtonTopAnchor: NSLayoutConstraint?
    var nextButtonTopAnchor: NSLayoutConstraint?
    var pageControlBottomAnchor: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Colors.darkThemeColor
        setup()
        style()
        layout()
    }
}

extension ManageOnBoardingViewController {
    
    func setup() {
        dataSource = self
        delegate = self
        
        pageControl.addTarget(self, action: #selector(pageControlTapped(_:)), for: .valueChanged)
        
        let page1 = OnBoardingViewController1(imageName: "page",
                                              titleText: "Kolayca not hesapla!",
                                              subtitleText: "Yazma,konuşma ve dinleme sınavlarını tek tuşla hesapla.")
        
        let page2 = OnBoardingViewController2(imageName: "page",
                                              titleText: "Yeni sınıf oluşturun",
                                              subtitleText: "Öğrenci isimlerini girin ve kaydedin")
        
        let page3 = OnBoardingViewController3(imageName: "page",
                                              titleText: "Eksikleri Görün",
                                              subtitleText: "'Hesapla ve Kaydet' butonuna tıklayın. Eksik notları tespit edin.")
        
        let page4 = OnBoardingViewController4(imageName: "page",
                                              titleText: "Not alanları",
                                              subtitleText: "1. Yazılı Sınav Not Alanı 2. Dinleme Sınavı Not Alanı 3. Konuşma Sınavı Alanı")
        
        
        pages.append(page1)
        pages.append(page2)
        pages.append(page3)
        pages.append(page4)
        
        setViewControllers([pages[initialPage]], direction: .forward, animated: true, completion: nil)
    }
    
    func style() {
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.pageIndicatorTintColor = .white
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = initialPage
        
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        skipButton.setTitleColor(.systemBlue, for: .normal)
        skipButton.setTitle("Skip", for: .normal)
        skipButton.addTarget(self, action: #selector(skipTapped(_:)), for: .primaryActionTriggered)

        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.setTitleColor(.systemBlue, for: .normal)
        nextButton.setTitle("Next", for: .normal)
        nextButton.addTarget(self, action: #selector(nextTapped(_:)), for: .primaryActionTriggered)
    }
    
    @objc
    private func pageControlTapped(_ sender: UIPageControl) {
        setViewControllers([pages[sender.currentPage]], direction: .forward, animated: true, completion: nil)
    }

    @objc
    private func skipTapped(_ sender: UIButton) {
        let lastPageIndex = pages.count - 1
        pageControl.currentPage = lastPageIndex
        goToSpecificPage(index: lastPageIndex, ofViewControllers: pages)
    }
    
    @objc
    private func nextTapped(_ sender: UIButton) {
        pageControl.currentPage += 1
        coordinator?.eventOccured(with: .goToSquareViewController)
        goToNextPage()
    }
    
    private func goToNextPage(animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        guard let currentPage = viewControllers?[0] else { return }
        guard let nextPage = dataSource?.pageViewController(self, viewControllerAfter: currentPage) else { return }
        
        setViewControllers([nextPage], direction: .forward, animated: animated, completion: completion)
    }
    
    private func goToPreviousPage(animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        guard let currentPage = viewControllers?[0] else { return }
        guard let prevPage = dataSource?.pageViewController(self, viewControllerBefore: currentPage) else { return }
        
        setViewControllers([prevPage], direction: .forward, animated: animated, completion: completion)
    }
    
    private func goToSpecificPage(index: Int, ofViewControllers pages: [UIViewController]) {
        let vc = SquareViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func layout() {
        let horizontalSpacing: CGFloat = 16
        let verticalOffset: CGFloat = -20
        

        view.addSubview(pageControl)
        view.addSubview(nextButton)
        view.addSubview(skipButton)
        
        pageControl.snp.makeConstraints { make in
            make.width.equalTo(view.snp.width)
            make.height.equalTo(20)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).offset(horizontalSpacing)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(verticalOffset)
        }
        
        skipButton.snp.makeConstraints { make in
            make.trailing.equalTo(view.snp.trailing).offset(-horizontalSpacing)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(verticalOffset)
        }
        
        skipButton.setTitleColor(Colors.darkThemeColor, for: .normal)
        nextButton.setTitleColor(Colors.darkThemeColor, for: .normal)
    }

}

extension ManageOnBoardingViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else  {
            return nil
        }
        
        if currentIndex == 0 {
            return pages.last
        } else {
            return pages[currentIndex - 1]
        }
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else  {
            return nil
        }
        
        if currentIndex < pages.count - 1 {
            return pages[currentIndex + 1]
        } else {
            return pages.first
        }
    }
}

extension ManageOnBoardingViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        guard let viewControllers = pageViewController.viewControllers else {
            return
        }
        
        guard let currentIndex = pages.firstIndex(of: viewControllers[0]) else {
            return
        }
        
        pageControl.currentPage = currentIndex
        
    }
}
