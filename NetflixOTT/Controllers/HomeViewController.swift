//
//  ViewController.swift
//  NetflixOTT
//
//  Created by Perennials on 06/02/24.
//

import UIKit
import FirebaseAnalytics
import GoogleMobileAds

enum Sections: Int {
    case TrendingMovies = 0
    case TrendingTv = 1
    case Popular = 2
    case Upcoming = 3
    case TopRated = 4
}


class HomeViewController: UIViewController {

    
    @IBOutlet weak var tableViewObj: UITableView!
    var randomTrendingMovie: Title?
    private var headerView: HeaderView?

    let sectionTitles: [String] = ["Trending Movies", "Trending Tv", "Popular", "Upcoming Movies", "Top rated"]

    //for ad banner view
    var bannerView: GADBannerView!
    
    //MARK: - methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureNavbar()
        self.setTableView()
        
        Generics.shared.logEvent(id: "HomeVC", itemName: "viewdidload function call")
        designBannerView()
    }
   
    func setTableView () {
        tableViewObj.backgroundColor = .black
        let nib = UINib(nibName: "HomeTabCell", bundle: nil)
        tableViewObj.register(nib, forCellReuseIdentifier: "HomeTabCell")
        tableViewObj.dataSource = self
        tableViewObj.delegate = self
        self.tableViewObj.sectionHeaderHeight = 40
        headerView = HeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 500))
        tableViewObj.tableHeaderView = headerView
        configureHeaderView()
    }
    
    //configuring headerview
    private func configureHeaderView() {
        APICalls.shared.getTrendingMovies { [weak self] result in
            switch result {
            case .success(let titles):
                let selectedTitle = titles.randomElement()
                
                self?.randomTrendingMovie = selectedTitle
                self?.headerView?.configure(with: TitleViewModel(titleName: selectedTitle?.original_title ?? "", posterURL: selectedTitle?.poster_path ?? ""))
                
            case .failure(let erorr):
                print(erorr.localizedDescription)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableViewObj.frame = view.bounds
        for subView in view.subviews {
            if  subView is  UIPageControl {
                subView.frame.origin.y = self.view.frame.size.height - 164
            }
        }
    }

    private func configureNavbar() {
        var image = UIImage(named: "netflixLogo")
        image = image?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        navigationController?.navigationBar.tintColor = .white
    }
}

extension HomeViewController:UITableViewDataSource,UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTabCell.identifier, for: indexPath) as? HomeTabCell else {
            return UITableViewCell()
        }
        cell.delegate = self

        switch indexPath.section {
        case Sections.TrendingMovies.rawValue:
            APICalls.shared.getTrendingMovies { result in
                switch result {
                    
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
                        
        case Sections.TrendingTv.rawValue:
            APICalls.shared.getTrendingTvs { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.Popular.rawValue:
            APICalls.shared.getPopular { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.Upcoming.rawValue:
            
            APICalls.shared.getUpcomingMovies { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        case Sections.TopRated.rawValue:
            APICalls.shared.getTopRated { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error)
                }
            }
        default:
            return UITableViewCell()

        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {return}
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .white
        header.textLabel?.text = header.textLabel?.text?.capitalizeFirstLetter()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
    
    func designBannerView () {
        let viewWidth = view.frame.inset(by: view.safeAreaInsets).width

            // Here the current interface orientation is used. Use
            // GADLandscapeAnchoredAdaptiveBannerAdSizeWithWidth or
            // GADPortraitAnchoredAdaptiveBannerAdSizeWithWidth if you prefer to load an ad of a
            // particular orientation,
            let adaptiveSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)
            bannerView = GADBannerView(adSize: adaptiveSize)

            addBannerViewToView(bannerView)
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2435281174"
          bannerView.rootViewController = self

          bannerView.load(GADRequest())
        bannerView.delegate = self
//        self.view.bringSubviewToFront(bannerView)
    }

    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
          [NSLayoutConstraint(item: bannerView,
                              attribute: .bottom,
                              relatedBy: .equal,
                              toItem: view.safeAreaLayoutGuide,
                              attribute: .bottom,
                              multiplier: 1,
                              constant: 0),
           NSLayoutConstraint(item: bannerView,
                              attribute: .centerX,
                              relatedBy: .equal,
                              toItem: view,
                              attribute: .centerX,
                              multiplier: 1,
                              constant: 0)
          ])
       }
    
}

extension HomeViewController: HometabTableViewCellDelegate {
    func collectionViewTableViewCellDidTapCell(_ cell: HomeTabCell, viewModel: TitlePreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
//            let vc = PlayVideoViewController() //TitlePreviewViewController()
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PlayVideoViewController") as? PlayVideoViewController
            
            print("navigating to playvideo")
//            vc?.model = viewModel
            if let vcVal = vc {
                vcVal.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(vcVal, animated: true)
            }
        }
    }
       
}

extension HomeViewController {
    public func publicMethodToTestConfigureHeaderView() {
        self.configureHeaderView()
    }
}

extension HomeViewController:GADBannerViewDelegate {
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
      print("bannerViewDidReceiveAd")
        bannerView.alpha = 0 //Adding animation for bannerview
          UIView.animate(withDuration: 1, animations: {
            bannerView.alpha = 1
          })
    }

    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
      print("bannerView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }

    func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
      print("bannerViewDidRecordImpression")
    }

    func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
      print("bannerViewWillPresentScreen")
    }

    func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
      print("bannerViewWillDIsmissScreen")
    }

    func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
      print("bannerViewDidDismissScreen")
    }
    
    //this will be called when we click on ad
    func bannerViewDidRecordClick(_ bannerView: GADBannerView) {
        bannerView.removeFromSuperview()
    }
}
