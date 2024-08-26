//
//  PhotoTableViewCell.swift
//  picsum
//
//  Created by Tieu Viet Trong Nghia on 25/8/24.
//

import UIKit

class PhotoTableViewCell: UITableViewCell {
    static let identifier = "PhotoTableViewCell"
    
    @IBOutlet weak var photo: UIImageView!
    
    @IBOutlet weak var authorLabel: UILabel!
    
    @IBOutlet weak var imageSizeLabel: UILabel!
    
    internal var aspectConstraint: NSLayoutConstraint? {
        didSet {
            if oldValue != nil {
                photo.removeConstraint(oldValue!)
            }
            if aspectConstraint != nil {
                photo.addConstraint(aspectConstraint!)
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        aspectConstraint = nil
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configure(with data: Photo) {
        authorLabel.text = data.author
        imageSizeLabel.text = data.sizeDescription
        let aspect = data.width / data.height

        let constraint = NSLayoutConstraint(item: photo, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: photo, attribute: NSLayoutConstraint.Attribute.height, multiplier: CGFloat(aspect), constant: 0.0)
        
        constraint.priority = UILayoutPriority(999)
        aspectConstraint = constraint
        
        self.photo.loadImageUsingCache(withUrl: data.download_url)
        
//        if let url = URL(string: data.download_url) {
//            DispatchQueue.global().async {
//                if let dataUrl = try? Data(contentsOf: url) {
//                    DispatchQueue.main.async {
//                        self.photo.image = UIImage(data: dataUrl)
//                    }
//                }
//            }
//        }
        
    }
}
