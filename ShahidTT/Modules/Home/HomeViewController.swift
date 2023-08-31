//
//  HomeViewController.swift
//  ShahidTT
//
//  Created by atsmac on 31/08/2023.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let viewModel = HomeViewModel()
    private let favoriteViewModel = FavoritesViewModel()
    
    private var isLoading = false
    private var reachedEnd = false
    private var searchActive = false {
        didSet {
            if searchActive {
                collectionView.reloadData()
            } else {
                fetchData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureCollectionView()
        fetchData()
    }
    
    private func fetchData() {
        isLoading = true
        viewModel.fetchData { [weak self] in
            self?.isLoading = false
            self?.collectionView.reloadData()
        }
    }
    
    private func setupUI() {
        title = "Home"
        tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        setupNavBar()
    }
    
    private func setupNavBar() {
        guard let image = UIImage(systemName: "magnifyingglass") else { return }
        let button = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(search))
        navigationItem.rightBarButtonItem = button
    }
    
    @objc func search() {
        UIView.animate(withDuration: 0.5) {
            self.searchBar.isHidden = !self.searchBar.isHidden
            if self.searchBar.isHidden {
                self.searchBar.resignFirstResponder()
            } else {
                self.searchBar.becomeFirstResponder()
            }
        }
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
        collectionView.register(UINib(nibName: "GiphyCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "GiphyCollectionViewCell")
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.GIFs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GiphyCollectionViewCell", for: indexPath) as? GiphyCollectionViewCell else {
            fatalError("Could not dequeue MyCollectionViewCell")
        }
        let cellData = viewModel.GIFs
        guard let GIFURL = cellData[indexPath.item].images.fixedWidthDownsampled.url else { return cell }
        //this seemed to be the most efficient implementation to avoid memory leaks, cahcing is of course a better solution but due to time restriction i won't be able to implement it
        
        cell.GIFTitleLabel.text = cellData[indexPath.item].title
        cell.descriptionTextView.text = cellData[indexPath.item].title //couldn't find description in object
        
        DispatchQueue.global(qos: .background).async {
            let imageURL = UIImage.gifImageWithURL(GIFURL)
            DispatchQueue.main.async {
                cell.GIFimageView.image = imageURL
            }
        }
        
        cell.toggleFavoriteHandler = { [weak self] in
            self?.favoriteViewModel.toggleFavoriteStatus(for: cellData[indexPath.item])
            cell.favoriteButton.isSelected = !cell.favoriteButton.isSelected
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
        let gif = viewModel.GIFs[indexPath.item]
        let detailViewController = DetailsViewController(nibName: ControllerName.details, bundle: nil)
        detailViewController.GIF = gif
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let screenHeight = scrollView.frame.height
        
        if offsetY > contentHeight - screenHeight && !isLoading && !reachedEnd {
            viewModel.currentPage += 1
            fetchData()
        }
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = true;
        
        viewModel.search(query: searchBar.text ?? "") { [weak self] in
            self?.isLoading = false
            self?.collectionView.reloadData()
        }
    }
}
