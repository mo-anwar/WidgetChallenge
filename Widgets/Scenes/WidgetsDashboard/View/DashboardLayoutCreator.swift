//
//  DashboardLayoutCreator.swift
//  Widgets
//
//  Created by Mohamed anwar on 26/08/2023.
//

import UIKit

enum DashboardLayoutCreator {
    static func create(sections: [[Widget]]) -> UICollectionViewCompositionalLayout {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.interSectionSpacing = 16
        
        return UICollectionViewCompositionalLayout(
            sectionProvider: { sectionIndex, _ in
                return createSection(for: sectionIndex, sections: sections)
            },
            configuration: configuration
        )
    }
    
    private static func createLargeGroup() -> NSCollectionLayoutGroup {
        let item = createLargeItem()
        
        return NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalWidth(1)
            ),
            subitems: [item]
        )
    }
    
    private static func createLargeItem() -> NSCollectionLayoutItem {
        let item = NSCollectionLayoutItem(layoutSize: .init(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        ))
        
        item.contentInsets = .init(top: 0, leading: 8, bottom: 0, trailing: 8)
        return item
    }
    
    
    private static func createSquareGroup() -> NSCollectionLayoutGroup {
        let item = createSquareItem()
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalWidth(0.5)
            ),
            subitems: [item, item]
        )
                
        return group
    }
    
    private static func createSquareItem() -> NSCollectionLayoutItem {
        let item = NSCollectionLayoutItem(layoutSize: .init(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1)
        ))
        
        item.contentInsets = .init(top: 0, leading: 8, bottom: 0, trailing: 8)
        return item
    }
    
    private static func createMiniItem() -> NSCollectionLayoutItem {
        let item = NSCollectionLayoutItem(layoutSize: .init(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(0.5)
        ))
        
        item.contentInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8)
        return item
    }
    
    private static func createSquareAndMiniGroup() -> NSCollectionLayoutGroup {
        let verticalGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: .init(
                widthDimension: .fractionalWidth(0.25),
                heightDimension: .fractionalHeight(1)),
            subitems: [createMiniItem()]
        )
        
        let outerGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalWidth(0.5)
        )

        let outerGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: outerGroupSize,
            subitems: [createSquareItem(), verticalGroup, verticalGroup]
        )

        return outerGroup
    }
    
    private static func createMiniGroup() -> NSCollectionLayoutGroup {
        let item = createMiniItem()
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: .init(
                widthDimension: .fractionalWidth(0.25),
                heightDimension: .fractionalHeight(1)
            ),
            subitems: [item]
        )
        
        let outerGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.5))

        let outerGroup = NSCollectionLayoutGroup.horizontal(layoutSize: outerGroupSize, subitems: [group, group, group, group])

        return outerGroup
    }
    
    private static func createSection(for index: Int, sections: [[Widget]]) -> NSCollectionLayoutSection {
        let section = sections[index]

        if section.isLargeSection {
            let group = createLargeGroup()
            return NSCollectionLayoutSection(group: group)
        } else if section.isSquareSection {
            let group = createSquareGroup()
            return NSCollectionLayoutSection(group: group)
        } else if section.isSquareAndMiniSection {
            let group = createSquareAndMiniGroup()
            return NSCollectionLayoutSection(group: group)
        } else if section.isMiniSection {
           let group = createMiniGroup()
            return NSCollectionLayoutSection(group: group)
        }
        return NSCollectionLayoutSection(group:createSquareGroup())
    }
}
