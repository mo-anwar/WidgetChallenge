//
//  LargeCollectionViewCell.swift
//  Widgets
//
//  Created by Mohamed anwar on 25/08/2023.
//

import UIKit

final class LargeCollectionViewCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    private func setupView() {
        contentView.backgroundColor = .yellow
        contentView.layer.cornerRadius = 14
    }

}
