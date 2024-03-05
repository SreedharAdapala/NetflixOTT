//
//  PlayVideoViewController.swift
//  NetflixOTT
//
//  Created by Perennials on 20/02/24.
//

import UIKit
import AVKit
//import MediaPlayer

enum VideoQuality: String {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
}

class PlayVideoViewController: UIViewController {
    
    @IBOutlet weak var videoPlayer: UIView!
    @IBOutlet weak var videoPlayerHeight: NSLayoutConstraint!
    @IBOutlet weak var viewControll: UIView!
    @IBOutlet weak var stackCtrView: UIStackView!
    @IBOutlet weak var img10SecBack: UIImageView! {
        didSet {
            self.img10SecBack.isUserInteractionEnabled = true
            self.img10SecBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTap10SecBack)))
        }
    }
    @IBOutlet weak var imgPlay: UIImageView! {
        didSet {
            self.imgPlay.isUserInteractionEnabled = true
            self.imgPlay.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapPlayPause)))
        }
    }
    @IBOutlet weak var img10SecFor: UIImageView! {
        didSet {
            self.img10SecFor.isUserInteractionEnabled = true
            self.img10SecFor.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTap10SecNext)))
        }
    }
    
    @IBOutlet weak var lbCurrentTime: UILabel!
    @IBOutlet weak var lbTotalTime: UILabel!
    @IBOutlet weak var seekSlider: UISlider! {
        didSet {
            self.seekSlider.addTarget(self, action: #selector(onTapToSlide), for: .valueChanged)
        }
    }
    @IBOutlet weak var imgFullScreenToggle: UIImageView! {
        didSet {
            self.imgFullScreenToggle.isUserInteractionEnabled = true
            self.imgFullScreenToggle.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapToggleScreen)))
        }
    }
    
    @IBOutlet weak var brightnessSlider: UISlider!{
        didSet{
            brightnessSlider.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
        }
    }
    @IBOutlet weak var settingsButton: UIButton!
    
    @IBOutlet weak var volumeObj: UISlider!
    
    //sample m3u8 URL's
//http://playertest.longtailvideo.com/adaptive/wowzaid3/playlist.m3u8
//http://content.jwplatform.com/manifests/vM7nH0Kl.m3u8
//http://qthttp.apple.com.edgesuite.net/1010qwoeiuryfg/sl.m3u8
    
    var videoURL = "http://content.jwplatform.com/manifests/vM7nH0Kl.m3u8"
    var currentSeekTime = CMTime ()
    //for hiding/showing controls
    var showingControls = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the initial brightness level
                setScreenBrightness(level: 0.1)
        
    }
    
   @objc func viewTapped () {
       if showingControls == true {
           hideControlsOnTheScreen()
       } else {
           showControlsOnTap()
       }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.setVideoPlayer(qualityChanged: false)
        // Set the initial brightness level
//        brightnessSlider.value = 0.2
        self.view.bringSubviewToFront(settingsButton)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        stopVideoPlayer()
    }

    private var player : AVPlayer? = nil
    private var playerLayer : AVPlayerLayer? = nil
    
    private func setVideoPlayer(qualityChanged:Bool) {
        guard let url = URL(string: videoURL) else { return }
        
        if self.player == nil {
            self.player = AVPlayer(url: url)
            self.playerLayer = AVPlayerLayer(player: self.player)
            self.playerLayer?.videoGravity = .resizeAspectFill
            if self.videoPlayer != nil {
                self.playerLayer?.frame = self.videoPlayer.bounds
            } else {
                self.playerLayer?.frame = self.view.bounds
            }
            self.playerLayer?.addSublayer(self.viewControll.layer)
            if let playerLayer = self.playerLayer {
                self.view.layer.addSublayer(playerLayer)
            }
            // Add observer for playback status changes
                   player?.addObserver(self, forKeyPath: "status", options: .new, context: nil)
            
            //add tap gesture
            let tap = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
            self.viewControll.addGestureRecognizer(tap)
            self.player?.play()
            if qualityChanged == true {
                if self.player?.status == .readyToPlay {
                    self.player?.seek(to: currentSeekTime, completionHandler: { completed in
                        
                    })
                }
            }
        }
        self.setObserverToPlayer()
    }
    
    func switchToQuality(_ quality: VideoQuality, forURL url: URL) async {
           let asset = AVURLAsset(url: url)
           
           // Find the appropriate media selection group
           guard let group = asset.mediaSelectionGroup(forMediaCharacteristic: .audible) else {
               return
           }
           
           // Find the selected media option
           let options = group.options
           for option in options {
               do {
                   if option.displayName == quality.rawValue {
                       // Select the desired media option
                       try await asset.load(.preferredMediaSelection)
                       break
                   }
               } catch {
                   
               }
           }
           
           // Create a new AVPlayerItem with the updated asset
           let playerItem = AVPlayerItem(asset: asset)
           
           // Replace the current player item with the new one
           player?.replaceCurrentItem(with: playerItem)
           
           // Play the video
           player?.play()
       }

    // Observe changes in the AVPlayer status
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status" {
            if player?.status == .failed {
                print("Failed to load video")
            } else if player?.status == .readyToPlay {
                print("Video is ready to play")
                // You can adjust quality here if needed
                adjustVideoQuality()
            }
        }
    }
    
    // Adjust video quality based on your criteria
        private func adjustVideoQuality() {
            // You can implement logic here to dynamically adjust the video quality
            // For example, you can change the preferredPeakBitRate of the AVPlayerItem

            // Example: Set the preferredPeakBitRate to limit the video quality
            let maximumBitrate: Double = 1_000_000 // 1 Mbps
            if let currentItem = player?.currentItem {
                currentItem.preferredPeakBitRate = maximumBitrate
            }
        }

        deinit {
            // Remove the observer when the view controller is deallocated
            player?.removeObserver(self, forKeyPath: "status")
        }
    
    private var windowInterface : UIInterfaceOrientation? {
        return self.view.window?.windowScene?.interfaceOrientation
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        guard let windowInterface = self.windowInterface else { return }
        if windowInterface.isPortrait ==  true {
            self.videoPlayerHeight.constant = 280 //300
            navigationItem.hidesBackButton = false
        } else {
            self.videoPlayerHeight.constant = self.view.layer.bounds.width
            navigationItem.hidesBackButton = true

        }
        print(self.videoPlayerHeight.constant)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.playerLayer?.frame = self.videoPlayer.bounds
        })
    }
    
    
    private var timeObserver : Any? = nil
    private func setObserverToPlayer() {
        timeObserver = nil
        let interval = CMTime(seconds: 0.3, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserver = player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { elapsed in
            self.updatePlayerTime()
        })
    }
    
    func hideControlsOnTheScreen () {
        self.img10SecBack.isHidden = true
        self.img10SecFor.isHidden = true
        seekSlider.isHidden = true
        stackCtrView.isHidden = true
        brightnessSlider.isHidden = true
        imgFullScreenToggle.isHidden = true
        lbCurrentTime.isHidden = true
        lbTotalTime.isHidden = true
        settingsButton.isHidden = true
//        self.navigationController?.navigationItem.hidesBackButton = true
//        self.tabBarController?.navigationItem.hidesBackButton = true
        showingControls = false
    }
    
    func showControlsOnTap () {
        self.img10SecBack.isHidden = false
        self.img10SecFor.isHidden = false
        seekSlider.isHidden = false
        stackCtrView.isHidden = false
        brightnessSlider.isHidden = false
        showingControls = false
        imgFullScreenToggle.isHidden = false
        lbCurrentTime.isHidden = false
        lbTotalTime.isHidden = false
        settingsButton.isHidden = false
//        self.navigationController?.navigationItem.hidesBackButton = false
//        self.tabBarController?.navigationItem.hidesBackButton = false
        showingControls = true
    }
    
    private func updatePlayerTime() {
//        self.hideControlsOnTheScreen() //
        
        guard let currentTime = self.player?.currentTime() else { return }
        guard let duration = self.player?.currentItem?.duration else { return }
        
        let currentTimeInSecond = CMTimeGetSeconds(currentTime)
        let durationTimeInSecond = CMTimeGetSeconds(duration)
        
        if self.isThumbSeek == false {
            self.seekSlider.value = Float(currentTimeInSecond/durationTimeInSecond)
        }
        
        let value = Float64(self.seekSlider.value) * CMTimeGetSeconds(duration)
        
        var hours = value / 3600
        var mins =  (value / 60).truncatingRemainder(dividingBy: 60)
        var secs = value.truncatingRemainder(dividingBy: 60)
        var timeformatter = NumberFormatter()
        timeformatter.minimumIntegerDigits = 2
        timeformatter.minimumFractionDigits = 0
        timeformatter.roundingMode = .down
        guard let hoursStr = timeformatter.string(from: NSNumber(value: hours)), let minsStr = timeformatter.string(from: NSNumber(value: mins)), let secsStr = timeformatter.string(from: NSNumber(value: secs)) else {
            return
        }
        self.lbCurrentTime.text = "\(hoursStr):\(minsStr):\(secsStr)"
        
        hours = durationTimeInSecond / 3600
        mins = (durationTimeInSecond / 60).truncatingRemainder(dividingBy: 60)
        secs = durationTimeInSecond.truncatingRemainder(dividingBy: 60)
        timeformatter = NumberFormatter()
        timeformatter.minimumIntegerDigits = 2
        timeformatter.minimumFractionDigits = 0
        timeformatter.roundingMode = .down
        guard let hoursStr = timeformatter.string(from: NSNumber(value: hours)), let minsStr = timeformatter.string(from: NSNumber(value: mins)), let secsStr = timeformatter.string(from: NSNumber(value: secs)) else {
            return
        }
        self.lbTotalTime.text = "\(hoursStr):\(minsStr):\(secsStr)"
    }
    
    
    @objc private func onTap10SecNext() {
        guard let currentTime = self.player?.currentTime() else { return }
        let seekTime10Sec = CMTimeGetSeconds(currentTime).advanced(by: 10)
        let seekTime = CMTime(value: CMTimeValue(seekTime10Sec), timescale: 1)
        currentSeekTime = seekTime //ADDED
        
        self.player?.seek(to: seekTime, completionHandler: { completed in
            
        })
    }
    
    @objc private func onTap10SecBack() {
        guard let currentTime = self.player?.currentTime() else { return }
        let seekTime10Sec = CMTimeGetSeconds(currentTime).advanced(by: -10)
        let seekTime = CMTime(value: CMTimeValue(seekTime10Sec), timescale: 1)
        currentSeekTime = seekTime //ADDED
        self.player?.seek(to: seekTime, completionHandler: { completed in
            
        })
    }
    
    @objc private func onTapPlayPause() {
        if self.player?.timeControlStatus == .playing {
            self.imgPlay.image = UIImage(systemName: "play.circle")
            self.player?.pause()
        } else {
            self.imgPlay.image = UIImage(systemName: "pause.circle")
            self.player?.play()
        }
    }
    
    private var isThumbSeek : Bool = false
    @objc private func onTapToSlide() {
        self.isThumbSeek = true
        guard let duration = self.player?.currentItem?.duration else { return }
        let value = Float64(self.seekSlider.value) * CMTimeGetSeconds(duration)
        if value.isNaN == false {
            let seekTime = CMTime(value: CMTimeValue(value), timescale: 1)
            self.player?.seek(to: seekTime, completionHandler: { completed in
                if completed {
                    self.isThumbSeek = false
                }
            })
        }
    }
    
    @objc private func onTapToggleScreen() {
        if #available(iOS 16.0, *) {
            guard let windowSceen = self.view.window?.windowScene else { return }
            if windowSceen.interfaceOrientation == .portrait {
                //for hiding tabbar
                super.hidesBottomBarWhenPushed = true
                navigationItem.hidesBackButton = true //CHECK
                windowSceen.requestGeometryUpdate(.iOS(interfaceOrientations: .landscape)) { error in
                    print(error.localizedDescription)
                }
            } else {
                super.hidesBottomBarWhenPushed = false
                navigationItem.hidesBackButton = false //CHECK
                windowSceen.requestGeometryUpdate(.iOS(interfaceOrientations: .portrait)) { error in
                    print(error.localizedDescription)
                }
            }
        } else {
            if UIDevice.current.orientation == .portrait {
                hidesBottomBarWhenPushed = false
                navigationItem.hidesBackButton = true //CHECK
                let orientation = UIInterfaceOrientation.landscapeRight.rawValue
                UIDevice.current.setValue(orientation, forKey: "orientation")
            } else { //moving to landscape
                hidesBottomBarWhenPushed = true
                navigationItem.hidesBackButton = false
                let orientation = UIInterfaceOrientation.portrait.rawValue
                UIDevice.current.setValue(orientation, forKey: "orientation")
            }
        }
    }
    
    func setScreenBrightness(level: Float) {
            // Make sure the brightness level is within the valid range [0.0, 1.0]
            let validLevel = max(0.0, min(1.0, level))

            // Set the screen brightness
            UIScreen.main.brightness = CGFloat(validLevel)
        }
    
    //for brightness change while playing video
    @IBAction func brightnessSliderValueChanged(_ sender: UISlider) {
        let brightnessLevel = sender.value
                setScreenBrightness(level: brightnessLevel)
        }
    
    @IBAction func settingsButtonAction(_ sender: Any) {
        let contentvc = QualityControlViewController.instance()
        contentvc.view.layer.cornerRadius = 10
//        contentvc.delegate = self
        contentvc.newQualityControlVC_CallBack = {(selectedQuality) -> Void in
//            //
            self.stopVideoPlayer()
            DispatchQueue.main.async {
                if selectedQuality == 0 {
                    self.videoURL = "http://content.jwplatform.com/manifests/vM7nH0Kl.m3u8"
                    self.setVideoPlayer(qualityChanged: true) //call this to update player with new URL
                } else if selectedQuality == 1 {
                    self.videoURL = "http://qthttp.apple.com.edgesuite.net/1010qwoeiuryfg/sl.m3u8"
                    self.setVideoPlayer(qualityChanged: true) //call this to update player with new URL
                } else if selectedQuality == 2 {
                    self.videoURL = "http://playertest.longtailvideo.com/adaptive/wowzaid3/playlist.m3u8"
                    self.setVideoPlayer(qualityChanged: true) //call this to update player with new URL
                }
                contentvc.dismiss(animated: true)
            }
            
        }
        
        let popupVC = PopupViewController(contentController: contentvc,popupWidth: 200,popupHeight: 200)
        self.present(popupVC, animated: true)
    }
    
    // Function to stop the video player
       func stopVideoPlayer() {
           player?.pause()
           player = nil // Set to nil to release the AVPlayer instance
       }
    
}
