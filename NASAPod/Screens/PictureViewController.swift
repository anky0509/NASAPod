//
//  PictureViewController.swift
//  NASAPod
//
//  Created by Ankita Porwal on 09/04/22.
//

import Foundation
import UIKit
import CoreData
import SDWebImage

class PictureViewController: UIViewController {
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var datePublishedLabel: UILabel!
    @IBOutlet weak var explanationLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var selectedDate: String?
    var picture: PictureDefinationManagedObject?
    private lazy var apiService = APIService.init()
    var favButton: UIBarButtonItem?
    
    class func fromStoryboard() -> PictureViewController {
        let viewController = UIStoryboard (name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: PictureViewController.self)) as! PictureViewController
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if picture != nil {
            loadData()
        } else if selectedDate != nil {
            fetchData()
        }
    }
    
    func setupView() {
        setOrUpdateBarButton()
    }
    
    func setOrUpdateBarButton() {
        var image: UIImage?
        if picture != nil, picture?.isFavorite == true {
            image = UIImage(named: "starFilled")?.withRenderingMode(.alwaysTemplate).withTintColor(.systemTeal)
        } else {
            image = UIImage(named: "star")?.withRenderingMode(.alwaysTemplate).withTintColor(.systemTeal)
        }
         
        if favButton == nil {
            favButton = UIBarButtonItem.init(image: image, style: .plain, target: self, action: #selector(toggleFavorite))
            navigationItem.rightBarButtonItem = favButton
        } else {
            favButton?.image = image
        }
    }
    
    func fetchData() {
        guard selectedDate != nil else {
            return
            
        }
        activityIndicator.startAnimating()
        apiService.fetchPicture(forDate: selectedDate!) {[unowned self] picture, error in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                if let picture = picture {
                    self.picture = picture
                    self.loadData()
                } else if let error = error as? Failure {
                    self.showError(error) {
                        self.navigationController?.popViewController(animated: true)
                    }
                } else {
                    self.showAlert(withTitle: "Error", message: "Something went wrong") {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
    
    private func loadData() {
        guard let picture = picture else {
            return
        }
        
        setOrUpdateBarButton()
        
        if let url = picture.imageUrl {
            headerImageView.sd_imageIndicator = SDWebImageActivityIndicator.medium
            headerImageView.sd_imageTransition = .fade
            headerImageView.sd_setImage(with: URL(string: url), completed: { [unowned self] (image, error, cache, url) in
                self.headerImageView.image = image
            })
        }
        
        headerImageView.contentMode = .scaleAspectFill
        headerImageView.clipsToBounds = true
        titleLabel.text = picture.title
        datePublishedLabel.text = picture.date
        explanationLabel.text = picture.explanation
    }
    
    @objc func toggleFavorite() {
        guard let picture = picture else {
            return
        }
            
        apiService.toggleFavorite(picture) { [unowned self] success, error in
            if success {
                self.setOrUpdateBarButton()
            } else if let error = error as? Failure {
                self.showError(error) {}
            }
        }
    }
    
}
