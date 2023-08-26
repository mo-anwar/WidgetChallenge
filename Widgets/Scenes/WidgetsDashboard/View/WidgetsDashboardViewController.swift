//
//  WidgetsDashboardViewController.swift
//  Widgets
//
//  Created by Mohamed anwar on 24/08/2023.
//

import UIKit
import Combine
import CombineDataSources

final class WidgetsDashboardViewController: ViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private lazy var collectionViewDataSource: CollectionViewItemsController<[[Widget]]> = {
        return .init { [weak self] _, collectionView, indexPath, item in
            guard let self = self else { return .init() }
            return self.createCell(item: item, at: indexPath, from: collectionView)
        }
    }()
    
    private let viewModel: WidgetsDashboardViewModelProtocol
        
    fileprivate init(viewModel: WidgetsDashboardViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func setupSubviews() {
        super.setupSubviews()
        
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectionView.registerNib(cell: LargeCollectionViewCell.self)
        collectionView.registerNib(cell: SquareCollectionViewCell.self)
        collectionView.registerNib(cell: MiniCollectionViewCell.self)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        viewModel.input.viewDidLoadTrigger.send()
        
        observeViewState(from: viewModel.output.$viewState)
        
        viewModel
            .output
            .$dataSource
            .subscribe(collectionView.sectionsSubscriber(collectionViewDataSource))
        
        
        viewModel
            .output
            .$dataSource
            .receive(on: DispatchQueue.main)
            .sink { [weak self] sections in
                guard let self else { return }
                let layout = DashboardLayoutCreator.create(sections: sections)
                collectionView.collectionViewLayout = layout
            }
            .store(in: &cancellables)
    }
    
    private func createCell(
        item: Widget,
        at indexPath: IndexPath,
        from CollectionView: UICollectionView
    ) -> UICollectionViewCell {
        switch item.style {
        case .mini:
            let cell: MiniCollectionViewCell = collectionView.dequeueCell(for: indexPath)
            return cell
            
        case .square:
            let cell: SquareCollectionViewCell = collectionView.dequeueCell(for: indexPath)
            return cell
            
        case .large:
            let cell: LargeCollectionViewCell = collectionView.dequeueCell(for: indexPath)
            return cell
        }
    }

}

extension WidgetsDashboardViewController {
    
    static func create() -> WidgetsDashboardViewController {
        let widgetsDashboardRepository = WidgetsDashboardRepository()
        let viewModel = WidgetsDashboardViewModel(widgetsDashboardRepository: widgetsDashboardRepository)
        return .init(viewModel: viewModel)
    }
    
}
