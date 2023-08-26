//
//  UICollectionViewExtension.swift
//  Widgets
//
//  Created by Mohamed anwar on 25/08/2023.
//

import UIKit

extension UICollectionView {
    
    func registerNib<T: UICollectionViewCell>(cell: T.Type) {
        register(cell.nib, forCellWithReuseIdentifier: cell.className)
    }
    
    func dequeueCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        return dequeueReusableCell(
            withReuseIdentifier: T.className,
            for: indexPath
        ) as! T
    }
    
}
