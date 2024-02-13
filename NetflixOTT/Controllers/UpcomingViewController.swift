//
//  UpcomingViewController.swift
//  NetflixOTT
//
//  Created by Perennials on 06/02/24.
//

import UIKit

class UpcomingViewController: UIViewController {

    @IBOutlet weak var upcomingTableviewObj: UITableView!
    
    private var titles: [Title] = [Title]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
       setupView()
        setupTableView()
        upcomingTableviewObj.delegate = self
        upcomingTableviewObj.dataSource = self
        fetchUpcoming()
            
    }
    

    func setupTableView () {
        upcomingTableviewObj.register(UpcomingTitleTableViewCell.self, forCellReuseIdentifier: UpcomingTitleTableViewCell.identifier)
    }
    
    func setupView () {
        view.backgroundColor = .systemBackground
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
    }
    
    private func fetchUpcoming() {
        APICalls.shared.getUpcomingMovies { [weak self] result in
            switch result {
            case .success(let titles):
                self?.titles = titles
                DispatchQueue.main.async {
                    self?.upcomingTableviewObj.reloadData()
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
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

extension UpcomingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UpcomingTitleTableViewCell.identifier, for: indexPath) as? UpcomingTitleTableViewCell else {
            return UITableViewCell()
        }
        
        let title = titles[indexPath.row]
        cell.configure(with: TitleViewModel(titleName: (title.original_title ?? title.original_name) ?? "Unknown title name", posterURL: title.poster_path ?? ""))
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        
        guard let titleName = title.original_title ?? title.original_name else {
            return
        }
        
        
        APICalls.shared.getMovie(with: titleName) { [weak self] result in
            switch result {
            case .success(let videoElement):
                DispatchQueue.main.async {
                    let vc = TitlePreviewViewController()
                    vc.configure(with: TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: title.overview ?? ""))
                    self?.navigationController?.pushViewController(vc, animated: true)
                }

                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
 
    

    
}

