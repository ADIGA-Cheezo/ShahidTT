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
    
    private let favoriteViewModel = FavoritesViewModel()
    private var activityIndicator: UIActivityIndicatorView!
    
    var GIF: Datum?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        addIndicator()
        fillData()
    }
    
    private func addIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        imageView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
        ])
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
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                self.imageView.image = imageURL
            }
        }
    }
    
    private func setupNavBar() {
        guard let image = UIImage(systemName: "star") else { return }
        let button = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(favoriteTapped(_:)))
        button.tintColor = .systemYellow
        navigationItem.rightBarButtonItem = button
    }
    
    @objc func favoriteTapped(_ sender: UIBarButtonItem) {
        guard let GIF = GIF else { return }
        favoriteViewModel.toggleFavoriteStatus(for: GIF)
    }
    
    @IBAction func didTapURL(_ sender: UIButton) {
        guard let urlString = GIF?.url else { return }
        guard let url = URL(string: urlString) else { return }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
}
