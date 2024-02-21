//
//  PlayVideoViewController.swift
//  NetflixOTT
//
//  Created by Perennials on 20/02/24.
//

import UIKit
import AVKit

class PlayVideoViewController: UIViewController {



    @IBOutlet weak var playerViewObj: UIView!
    
    @IBOutlet weak var playerViewHeightConstraint: NSLayoutConstraint!
    
    var playerViewController = AVPlayerViewController()
    
//    @IBOutlet weak var videoPlayerViewHeightConstraint: NSLayoutConstraint!
    //
    private var player : AVPlayer? = nil
    private var playerLayer : AVPlayerLayer? = nil
    
    private var urlStr : String? = nil
     var model :TitlePreviewViewModel? = nil
    
//    private let playerViewInstance: UIView = {
//       
//        let viewObj = UIView()
//        viewObj.frame = CGRect(x: 10, y: 20, width: UIScreen.main.bounds.size.width, height: 200)
//        viewObj.translatesAutoresizingMaskIntoConstraints = false
//        viewObj.backgroundColor = .red
////        viewObj.setTitle("Download", for: .normal)
////        viewObj.setTitleColor(.white, for: .normal)
//        viewObj.layer.cornerRadius = 8
//        viewObj.layer.masksToBounds = true
//        
//        return viewObj
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//      definesPresentationContext = true

        self.playerViewObj.backgroundColor = .red

        
       
    }
    
    /*
    //play particular video based on selection
    func playtheVideo (with model: TitlePreviewViewModel) {
        
//        let urlVal = "https://www.youtube.com/embed/\(model.youtubeView.id.videoId)"
//        print("urlVal is \(urlVal)")

        guard let urlVal = URL(string: "https://www.youtube.com/embed/\(model.youtubeView.id.videoId)")else {
            return
        }
                
        // Create AVPlayer instance with the video URL
        player = AVPlayer(url: urlVal)

        // Assign AVPlayer to AVPlayerViewController
        playerViewController.player = player
        playerViewController.allowsPictureInPicturePlayback = true
        playerViewController.delegate = self
        // Present the AVPlayerViewController
        present(playerViewController, animated: true) {
            // Start playing the video
            self.player?.play()
        }
    }
*/
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        urlStr = "https://www.youtube.com/embed/\(model?.youtubeView.id.videoId ?? "")"
print("url is \(urlStr)")
//        if let val = URL(string: "https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/720/Big_Buck_Bunny_720_10s_5MB.mp4") {
        
        if let urlVal = URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4") {
            let player = AVPlayer(url: urlVal)
                    let playerLayer = AVPlayerLayer(player: player)
                    playerLayer.frame = playerViewObj.bounds
                    playerLayer.videoGravity = .resizeAspectFill
                    playerViewObj.layer.addSublayer(playerLayer)
                    player.play()
        }
    }
    /*
    private func setVideoPlayer() {
        guard let url = URL(string: urlStr ?? "") else { return }
        
        if self.player == nil {
            self.player = AVPlayer(url: url)
            self.playerLayer = AVPlayerLayer(player: self.player)
//            self.playerLayer?.videoGravity = .resizeAspectFill
            
//            var v = self.view
            
         //   self.playerLayer?.frame = self.videoPlayerViewObj.bounds
                // Set the frame of the playerLayer to match the bounds of videoPlayerViewObj
                self.playerLayer?.frame = playerViewObj.bounds
                
                if let playerLayer = self.playerLayer {
                    playerViewObj.layer.addSublayer(playerLayer)
                }
            self.player?.play()
        }
    }
    */
    private var windowInterface : UIInterfaceOrientation? {
        return self.view.window?.windowScene?.interfaceOrientation
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        guard let windowInterface = self.windowInterface else { return }
        if #available(iOS 16.0, *) {
            if windowInterface.isPortrait ==  true {
                self.playerViewHeightConstraint.constant = 300
            } else {
                self.playerViewHeightConstraint.constant = self.view.layer.bounds.height
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                self.playerLayer?.frame = self.view.layer.bounds
            })
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PlayVideoViewController: AVPlayerViewControllerDelegate {
    
}
