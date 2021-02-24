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
        case character(SerieCharacter)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

