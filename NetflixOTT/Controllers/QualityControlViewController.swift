//
//  QualityControlViewController.swift
//  NetflixOTT
//
//  Created by Perennials on 23/02/24.
//

import UIKit

class QualityControlViewController: UIViewController {

    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var tableViewObj: UITableView!
    
    var newQualityControlVC_CallBack:(()->())?
    
    let qualityArr = ["low","medium","high"]
    
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
        self.newQualityControlVC_CallBack!()
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
}

