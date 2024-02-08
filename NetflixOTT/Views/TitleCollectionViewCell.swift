//
//  TitleCollectionViewCell.swift
//  NetflixOTT
//
//  Created by Perennials on 07/02/24.
//

import UIKit


class TitleCollectionViewCell: UICollectionViewCell {
    
    
    static let identifier = "TitleCollectionViewCell"
    
    var posterImageView = UIImageView ()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        posterImageView.contentMode = .scaleAspectFill
        contentView.addSubview(posterImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImageView.frame = contentView.bounds
    }
    
    public func configure(with model: String) {
        
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model)") else {
            return
        }
        posterImageView.sd_setImage(with: url, completed: nil)
    }
    
}
