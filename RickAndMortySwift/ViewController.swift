//
//  ViewController.swift
//  RickAndMortySwift
//
//  Created by Sohayb Bahi on 24/02/2021.
//

import UIKit

class ViewController: UICollectionViewController {
    
    @IBOutlet weak var imageInCell: UIImageView!
    var serieCharactersLocal :[Character] = []
    private enum Section {
        case main
    }

    private enum Item: Hashable {
        case character(Character)
    }
    
    private var diffableDataSource: UICollectionViewDiffableDataSource<Section, Item>!

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.collectionViewLayout = createLayout()
        setupView()
        diffableDataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            switch item {
            case .character(let character):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CellData
                /*if cell.contentView.subviews.count != 0 {

                        cell.contentView.subviews[0].removeFromSuperview()

                    }*/
                
                /*
                imageView.translatesAutoresizingMaskIntoConstraints = false
             
                imageView.heightAnchor.constraint(equalToConstant: 300).isActive = true*/
                //let imageView = UIImageView()
                cell.image.loadImage(from: character.imageUrl, completion: nil)/* {
                    cell.setNeedsLayout()
                }*/
                cell.name.text = character.name
                //cell.contentView.addSubview(imageView)
                /*
                cell.iconImageView.image = UIImage(named: icon.name)
                cell.iconPriceLabel.text = "$\(icon.price)"*/
                /*cell.textLabel?.text = character.name
                cell.imageView?.loadImage(from: character.imageUrl) {
                    cell.setNeedsLayout()
                }
                cell.detailTextLabel?.text = DateFormatter.localizedString(from: character.createdDate,
                                                                           dateStyle: .medium,
                                                                        timeStyle: .short)*/
                return cell
            }
        })
        
        
        let snapshot = createSnapshot(characters: [])
        diffableDataSource.apply(snapshot)
        
        
        
        NetworkManager.staticNetworkManager.fetchCharacters { (result) in
            switch result {
            case .failure(let error):
                print(error)

            case .success(let paginatedElements):
                let serieCharacters = paginatedElements.decodedElements
                self.serieCharactersLocal = serieCharacters
                let snapshot = self.createSnapshot(characters: serieCharacters)

                DispatchQueue.main.async {
                    self.diffableDataSource.apply(snapshot)
                }
            }
        }
    }
    
    private func createLayout() -> UICollectionViewLayout {
     
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            
            let layout = UICollectionViewCompositionalLayout(section: section)
            return layout
        
    }

    private func createSnapshot(characters : [Character]? = nil,searchQuery: String? = nil) -> NSDiffableDataSourceSnapshot<Section,Item> {
        var snapshot = NSDiffableDataSourceSnapshot<Section,Item>()
        snapshot.appendSections([.main])
        let filteredCharacters: [Character]
        if let characters = characters {
                    if let searchQuery = searchQuery, !searchQuery.isEmpty {
                        filteredCharacters = characters.filter { character in
                            return character.name.contains(searchQuery)
                        }
                    } else {
                        filteredCharacters = characters
                    }
        } else {
            if let searchQuery = searchQuery, !searchQuery.isEmpty {
                filteredCharacters = serieCharactersLocal.filter { character in
                    return character.name.contains(searchQuery)
                }
            } else {
                filteredCharacters = serieCharactersLocal
            }
        }
        
                  
        let items = filteredCharacters.map(Item.character)
        snapshot.appendItems(items,toSection: .main)
        return snapshot
    }
    
    private func setupView() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
//        tableView.tableFooterView = UIView()
    }
}


class ImageCell: UITableViewCell {
  @IBOutlet var cellImageView: UIImageView!
  var onReuse: () -> Void = {}

  override func prepareForReuse() {
    super.prepareForReuse()
    onReuse()
    cellImageView.image = nil
  }
}


extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchQuery = searchController.searchBar.text
        let snapshot = createSnapshot(searchQuery: searchQuery)
        diffableDataSource.apply(snapshot)
    }
}
