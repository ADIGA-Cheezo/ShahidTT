//
//  FavoritesViewController.swift
//  ShahidTT
//
//  Created by atsmac on 31/08/2023.
//

import UIKit
import CoreData

class FavoritesViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let favoriteViewModel = FavoritesViewModel()
    
    private var images: [NSManagedObject] = [] {
        didSet {
            collectionView.reloadData()
            setupUI()
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        //had to place it in init as using viewdidload woul not allow the HomeController to present the tab bar with all tabs loaded
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchFavorites()
    }
    
    private func setupUI() {
        title = "Favorites (\(images.count))"
        tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "star"), tag: 0)
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "GiphyCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "GiphyCollectionViewCell")
    }
    
    private func fetchFavorites() {
        images = favoriteViewModel.loadPhotos(forUser: UserDataManager.shared.username)
    }

}

extension FavoritesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GiphyCollectionViewCell", for: indexPath) as? GiphyCollectionViewCell else {
            fatalError("Could not dequeue MyCollectionViewCell")
        }
        cell.favoriteButton.isHidden = true // should be placed in a config function inside cell class
        
        let cellData = images[indexPath.item]
        let GIFURL = cellData.value(forKey: "imageURLString") as? String ?? ""
        //this seemed to be the most efficient implementation to avoid memory leaks, cahcing is of course a better solution but due to time restriction i won't be able to implement it

        cell.GIFTitleLabel.text = cellData.value(forKey: "title") as? String ?? "No title"
        cell.descriptionTextView.text = cellData.value(forKey: "datumDescription") as? String ?? "No description" //couldn't find description in object

        DispatchQueue.global(qos: .background).async {
            if !GIFURL.isEmpty {
                let imageURL = UIImage.gifImageWithURL(GIFURL)
                DispatchQueue.main.async {
                    cell.GIFimageView.image = imageURL
                }
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let noOfCellsInRow = UIDevice.current.userInterfaceIdiom == .pad ? 5 : 2
        
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        
        let totalSpace = flowLayout.sectionInset.left
        + flowLayout.sectionInset.right
        + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
        
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
        
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let gif = viewModel.GIFs[indexPath.item]
//        let detailViewController = DetailsViewController(nibName: ControllerName.details, bundle: nil)
//        detailViewController.GIF = gif
//        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
