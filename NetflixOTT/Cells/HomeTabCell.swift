//
//  HomeTabCell.swift
//  NetflixOTT
//
//  Created by Perennials on 06/02/24.
//

import UIKit

protocol HometabTableViewCellDelegate: AnyObject {
    func collectionViewTableViewCellDidTapCell(_ cell: HomeTabCell, viewModel: TitlePreviewViewModel)
}


class HomeTabCell: UITableViewCell {

    static let identifier = "HomeTabCell"
    var titles: [Title] = [Title]()
    
    @IBOutlet weak var collectionViewObj: UICollectionView!
    
    weak var delegate: HometabTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal
        collectionViewObj.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        collectionViewObj.delegate = self
        collectionViewObj.dataSource = self
//        
        let flowLayout = UICollectionViewFlowLayout()
                flowLayout.scrollDirection = .horizontal
                flowLayout.itemSize = CGSize(width: 150, height: 180)
                flowLayout.minimumLineSpacing = 2.0
                flowLayout.minimumInteritemSpacing = 5.0
                self.collectionViewObj.collectionViewLayout = flowLayout
                self.collectionViewObj.showsHorizontalScrollIndicator = false
        startTimer()
    }
    
    //for collectionview auto scrollview
    func startTimer() {

        _ =  Timer.scheduledTimer(timeInterval: timeIntervalForHometabCollectionview, target: self, selector: #selector(self.scrollAutomatically), userInfo: nil, repeats: true)
    }

    var x = 1
    @objc func scrollAutomatically(_ timer1: Timer) {
        
        if self.x < self.titles.count {
              let indexPath = IndexPath(item: x, section: 0)
              self.collectionViewObj.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
              self.x = self.x + 1
            }else{
              self.x = 0
              self.collectionViewObj.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: true)
            }
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionViewObj.frame = contentView.bounds
    }
    
    public func configure(with titles: [Title]) {
        self.titles = titles
        DispatchQueue.main.async { [weak self] in
            self?.collectionViewObj.reloadData()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension HomeTabCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionViewObj.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        guard let model = titles[indexPath.row % titles.count].poster_path else {
            return UICollectionViewCell()
        }
        cell.configure(with: model)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        guard let titleName = title.original_title ?? title.original_name else {
            return
        }
        
        
        APICalls.shared.getMovie(with: titleName + " trailer") { [weak self] result in
            switch result {
            case .success(let videoElement):
                
                let title = self?.titles[indexPath.row]
                guard let titleOverview = title?.overview else {
                    return
                }
                guard let strongSelf = self else {
                    return
                }
                let viewModel = TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: titleOverview)
                self?.delegate?.collectionViewTableViewCellDidTapCell(strongSelf, viewModel: viewModel)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
    }
}
