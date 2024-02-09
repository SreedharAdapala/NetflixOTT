//
//  HomeTabCell.swift
//  NetflixOTT
//
//  Created by Perennials on 06/02/24.
//

import UIKit

class HomeTabCell: UITableViewCell {

    static let identifier = "HomeTabCell"
    private var titles: [Title] = [Title]()
    
    @IBOutlet weak var collectionViewObj: UICollectionView!
    
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

        let timer =  Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.scrollAutomatically), userInfo: nil, repeats: true)
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
    
}
