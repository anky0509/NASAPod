//
//  FavoriteListViewController.swift
//  NASAPod
//
//  Created by Ankita Porwal on 10/04/22.
//

import UIKit

class FavoriteListViewController: UITableViewController {
    
    var pictures: [PictureDefinationManagedObject] = []
    private lazy var apiService = APIService.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Favorite Pictures"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    func fetchData() {
        apiService.fetchFavPictures { [unowned self] pictures, error in
            if let pictures = pictures {
                self.pictures = pictures
                self.tableView.reloadData()
            } else if let error = error as? Failure {
                self.showError(error) {}
            } else {
                self.showAlert(withTitle: "Error", message: "Something went wrong") {}
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PictureTableViewCell", for: indexPath) as! PictureTableViewCell

        let picture = pictures[indexPath.row]
        cell.loadData(picture: picture)
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pictureVC = PictureViewController.fromStoryboard()
        pictureVC.picture = pictures[indexPath.row]
        navigationController?.pushViewController(pictureVC, animated: true)
    }
}
