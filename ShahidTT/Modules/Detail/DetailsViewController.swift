//
//  DetailsViewController.swift
//  ShahidTT
//
//  Created by atsmac on 31/08/2023.
//

import UIKit
import SafariServices

class DetailsViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var slugLabel: UILabel!
    @IBOutlet weak var URLButton: UIButton!
    
    var GIF: Datum?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        fillData()
    }
    
    private func fillData() {
        guard let GIF = GIF else { return }
        guard let imageURL = GIF.images.downsizedMedium.url else { return }
        loadImage(imageURL)
        self.title = GIF.title
        self.typeLabel.text = GIF.type.rawValue
        descriptionTextView.text = GIF.title
        slugLabel.text = GIF.slug
        URLButton.setTitle("View in browser", for: .normal)
    }
    
    private func loadImage(_ imageURL: String = "") {
        DispatchQueue.global(qos: .background).async {
            let imageURL = UIImage.gifImageWithURL(imageURL)
            DispatchQueue.main.async {
                self.imageView.image = imageURL
            }
        }
    }
    
    private func setupNavBar() {
        guard let image = UIImage(systemName: "star") else { return }
        let button = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(FavoriteTapped))
        button.tintColor = .systemYellow
        navigationItem.rightBarButtonItem = button
    }
    
    @objc func FavoriteTapped() {
        // Handle button tap event here
        // For example, you can navigate to another view controller
    }
    
    @IBAction func didTapURL(_ sender: UIButton) {
        guard let urlString = GIF?.url else { return }
        guard let url = URL(string: urlString) else { return }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
}
