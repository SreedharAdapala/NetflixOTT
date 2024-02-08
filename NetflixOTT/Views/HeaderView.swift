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

    override init(frame: CGRect) {
        super.init(frame: frame)
        //Adding headerview with Imageview
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "RRR")
        addSubview(imageView)
        addGradient()
    }
    
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

}
