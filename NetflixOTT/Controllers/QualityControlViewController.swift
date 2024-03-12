//
//  QualityControlViewController.swift
//  NetflixOTT
//
//  Created by Perennials on 23/02/24.
//

import UIKit
import FirebaseAnalytics

protocol QualityConrolProtocol:AnyObject {
    func sendQualitySelection (qualityID:Int)
    func closeButtonClicked()
}

extension QualityConrolProtocol {
    func sendQualitySelection(qualityID:Int){
        // leaving this empty
    }
}

class QualityControlViewController: UIViewController {

    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var tableViewObj: UITableView!
    
    var newQualityControlVC_CallBack:((Int)->())?
    
    let qualityArr = ["low","medium","high"]
    
    var delegate:QualityConrolProtocol?
    
    class func instance() -> Self {
        let thisStoryBorad = UIStoryboard(name: "Main", bundle: nil)
        let thisVC = thisStoryBorad.instantiateViewController(withIdentifier: self.className())as! Self
        return thisVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUI()
        let nib = UINib(nibName: "QualityChangeCell", bundle: nil)
        tableViewObj.register(nib, forCellReuseIdentifier: "QualityChangeCell")
        tableViewObj.dataSource = self
        tableViewObj.delegate = self
        tableViewObj.reloadData()
    }
    
    func setUI () {
        titleLabel.text = "Quality control"
    }
    
    @IBAction func closeButtonAction(_ sender: Any) {
        self.newQualityControlVC_CallBack!(4)
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

extension QualityControlViewController:UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return qualityArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewObj.dequeueReusableCell(withIdentifier: "QualityChangeCell") as!QualityChangeCell
        cell.titleLabel.text = qualityArr[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
//            self.delegate?.sendQualitySelection(qualityID: 0)
            self.newQualityControlVC_CallBack!(0)
            changeQuality(qualityType: 0)
        } else if indexPath.row == 1 {
//            self.delegate?.sendQualitySelection(qualityID: 1)
            self.newQualityControlVC_CallBack!(1)
            changeQuality(qualityType: 1)
        } else if indexPath.row == 2 {
            self.newQualityControlVC_CallBack!(2)
            changeQuality(qualityType: 2)
        }
        else if indexPath.row == 3 {
//            self.delegate?.sendQualitySelection(qualityID: 2)
//            self.newQualityControlVC_CallBack!(3)
            self.newQualityControlVC_CallBack!(2)
            changeQuality(qualityType: 2)
        }
    }
    
    func changeQuality (qualityType:Int) {
        Generics.shared.logEvent(id: "QualityControlVC", itemName: "changeQuality \(qualityType)")
    }
}

