//
//  ViewController.swift
//  RickAndMortySwift
//
//  Created by Sohayb Bahi on 24/02/2021.
//

import UIKit

class ViewController: UITableViewController {
    
    private enum Section {
        case main
    }

    private enum Item: Hashable {
        case character(Character)
    }
    
    private var diffableDataSource: UITableViewDiffableDataSource<Section, Item>!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    private func createSnapshot(characters : [Character]) -> NSDiffableDataSourceSnapshot<Section,Item> {
        var snapshot = NSDiffableDataSourceSnapshot<Section,Item>()
        snapshot.appendSections([.main])
        
        let items = characters.map(Item.character)
        
        snapshot.appendItems(items,toSection: .main)
        
        return snapshot
    }

}

