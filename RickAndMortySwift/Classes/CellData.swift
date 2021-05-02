//
//  CellData.swift
//  RickAndMortySwift
//
//  Created by Sohayb Bahi on 02/05/2021.
//

import Foundation
import UIKit

class CellData: UICollectionViewCell {

    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var image: UIImageView!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}
