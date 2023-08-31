//
//  GiphyCollectionViewCell.swift
//  ShahidTT
//
//  Created by atsmac on 31/08/2023.
//

import UIKit

class GiphyCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var GIFimageView: UIImageView!
    @IBOutlet weak var GIFTitleLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var toggleFavoriteHandler: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.containerView.layer.cornerRadius = 10
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        GIFTitleLabel.text = nil
        GIFimageView.image = nil
        descriptionTextView.text = nil
    }
    
    @IBAction func didTapFavoriteButton(_ sender: Any) {
        toggleFavoriteHandler?()
    }
}
