//
//  PictureTableViewCell.swift
//  NASAPod
//
//  Created by Ankita Porwal on 10/04/22.
//

import UIKit
import SDWebImage

class PictureTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pictureImageView: UIImageView!
    
    override func prepareForReuse() {
        imageView?.image = nil
        dateLabel.text = nil
        titleLabel.text = nil
    }

    func loadData(picture: PictureDefinationManagedObject) {
        if let url = picture.imageUrl {
            pictureImageView.sd_imageIndicator = SDWebImageActivityIndicator.medium
            pictureImageView.sd_imageTransition = .fade
            pictureImageView.sd_setImage(with: URL(string: url), completed: { [unowned self] (image, error, cache, url) in
                self.pictureImageView.image = image
            })
        }
        
        pictureImageView.contentMode = .scaleAspectFill
        pictureImageView.clipsToBounds = true
        titleLabel.text = picture.title
        dateLabel.text = picture.date
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
