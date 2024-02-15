//
//  HeaderView.swift
//  NetflixOTT
//
//  Created by Perennials on 07/02/24.
//

import UIKit
import SDWebImage

class HeaderView: UIView {
    
    let imageView = UIImageView()
    
    lazy var view0: UIView = {
        
        let view = UIView.init(frame: self.frame)
        let imageView = UIImageView.init(frame: view.frame)
        imageView.image = UIImage(named: "RRR")
        view.addSubview(imageView)
        return view
        
    }()

    lazy var view1: UIView = {
        
        let view = UIView.init(frame: self.frame)
        let imageView = UIImageView.init(frame: view.frame)
        imageView.image = UIImage(named: "netflix")
        view.addSubview(imageView)
        return view
        
    }()
    
    lazy var view2: UIView = {
        
        let view = UIView.init(frame: self.frame)
        let imageView = UIImageView.init(frame: view.frame)
        imageView.image = UIImage(named: "RRR")
        view.addSubview(imageView)
        return view
        
    }()
    
    lazy var views = [view0,view1,view2]
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView.init(frame: self.frame)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.contentSize = CGSize(width: self.frame.width * CGFloat(views.count), height: self.frame.height)
        for i in 0..<views.count {
            scrollView.addSubview(views[i])
            views[i].frame = CGRect(x: self.frame.width * CGFloat(i), y: 0, width: self.frame.width, height: self.frame.height)
        }
        scrollView.delegate = self
        return scrollView
        
    }()
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl.init(frame: CGRect(x: 0, y: self.frame.height - 100, width: self.frame.width, height: 100))
        pageControl.numberOfPages = views.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .black
        pageControl.currentPageIndicatorTintColor = .red
    
        pageControl.addTarget(self, action: #selector(pageControlTaphandler(sendar:)), for: .touchUpInside)
        return pageControl
        
    }()
    
    
    //for pagination
    //private var pageControl = UIPageControl(frame: .zero)

    override init(frame: CGRect) {
        super.init(frame: frame)
        //Adding headerview with Imageview
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "RRR")
        
        //addSubview(imageView)
        addSubview(scrollView)
        addGradient()
        addSubview(pageControl)
        
        
//        imageView.isHidden = true
//        setupPageControl()
    }
    
    
//    private func setupPageControl() {
//
////        pageControl.frame = CGRect(x: self.frame.size.width/2-20, y: self.frame.size.height-100, width: pageControl.frame.width, height: pageControl.frame.height)
//        pageControl.numberOfPages = 3
//        pageControl.translatesAutoresizingMaskIntoConstraints = false
//        pageControl.currentPageIndicatorTintColor = UIColor.orange
//        pageControl.pageIndicatorTintColor = UIColor.lightGray.withAlphaComponent(0.8)
//
//        let leading = NSLayoutConstraint(item: pageControl, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
//        let trailing = NSLayoutConstraint(item: pageControl, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
//        let bottom = NSLayoutConstraint(item: pageControl, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
//        print(pageControl.frame)
////        self.insertSubview(pageControl, at: 0)
//        self.addSubview(pageControl)
//        self.bringSubviewToFront(pageControl)
////        self.addConstraints([leading, trailing, bottom])
//    }
    
//     func viewDidLayoutSubviews() {
//            for subView in self.subviews {
//                if  subView is  UIPageControl {
//                    subView.frame.origin.y = self.frame.size.height - 164
//                }
//            }
//        }
    
    //Adding gradien color to the header view
    private func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.systemBackground.cgColor
        ]
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
    }
    
    //downloading and setting up image for header view
    public func configure(with model: TitleViewModel) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.posterURL)") else {
            return
        }
        print("url is \(url)")
        imageView.sd_setImage(with: url, completed: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @objc func pageControlTaphandler(sendar: UIPageControl) {
        
        let frame = CGRect(x: self.frame.width * CGFloat(sendar.currentPage), y: 0, width: self.frame.width, height: self.frame.height)
        scrollView.scrollRectToVisible(frame, animated: true)
    }

}
extension HeaderView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / self.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
}
extension HeaderView: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
    }
}
