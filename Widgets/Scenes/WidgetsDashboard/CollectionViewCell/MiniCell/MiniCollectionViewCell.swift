//
//  MiniCollectionViewCell.swift
//  Widgets
//
//  Created by Mohamed anwar on 25/08/2023.
//

import UIKit

final class MiniCollectionViewCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    private func setupView() {
        contentView.backgroundColor = .green
        contentView.layer.cornerRadius = 14
    }
    
}
