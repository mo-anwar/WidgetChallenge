//
//  WidgetsDashboardViewModel.swift
//  Widgets
//
//  Created by Mohamed anwar on 24/08/2023.
//

import Foundation
import Combine

protocol WidgetsDashboardViewModelProtocol {
    var input: WidgetsDashboardViewModel.Input { get }
    var output: WidgetsDashboardViewModel.Output { get }
}

final class WidgetsDashboardViewModel: ViewModel, WidgetsDashboardViewModelProtocol, ViewModelType {
    
    class Input {
        let viewDidLoadTrigger: AnyUIEvent<Void> = .create()
    }
    
    class Output {
        @Published fileprivate(set) var viewState: ViewState?
        @Published fileprivate(set) var dataSource: [[Widget]] = []
    }
    
    private let widgetsDashboardRepository: WidgetsDashboardRepositoryProtocol
    
    let input: Input
    let output: Output
    
    init(widgetsDashboardRepository: WidgetsDashboardRepositoryProtocol) {
        input = .init()
        
        output = .init()
        
        self.widgetsDashboardRepository = widgetsDashboardRepository
        
        super.init()
        
        observeViewDidLoadTrigger()
        
    }
}

// MARK: - Observers
extension WidgetsDashboardViewModel {
    
    private func observeViewDidLoadTrigger() {
        input
            .viewDidLoadTrigger
            .sink { [weak self] in
                guard let self else { return }
                self.loadInitialData()
            }
            .store(in: &cancellables)
    }
    
}

// MARK: - Network
extension WidgetsDashboardViewModel {
    
    private func loadInitialData() {
        Task { @MainActor in
            do {
                defer {
                    output.viewState = .idle
                }
                
                output.viewState = .loading(isUserInteractionEnabled: true)
                
                let widgets = try await widgetsDashboardRepository.getWidgets()
                
                output.dataSource = createDashboard(widgets: widgets)
                
            } catch {
                output.viewState = .error(message: error.localizedDescription)
            }
        }
    }
    
}

// MARK: - functions
extension WidgetsDashboardViewModel {
    
    func createDashboard(widgets: [Widget]) -> [[Widget]] {
        let squareSubArraySize = 2
        let miniSubArraySize = 8
        let maxMinisInSquareArray = 4
        
        func createSquareArrays(count: Int) -> [[Widget]] {
            return Array(repeating: [Widget(style: .square), Widget(style: .square)], count: count)
        }
        
        func createSquareArrayWithMinis(_ minis: [Widget]) -> [Widget] {
            var squareArray: [Widget] = [Widget(style: .square)]
            squareArray.append(contentsOf: minis.prefix(maxMinisInSquareArray))
            return squareArray
        }
        
        var largeWidgets = [Widget]()
        var squareWidgets = [Widget]()
        var miniWidgets = [Widget]()
        
        for widget in widgets {
            switch widget.style {
            case .large:
                largeWidgets.append(widget)
            case .square:
                squareWidgets.append(widget)
            case .mini:
                miniWidgets.append(widget)
            }
        }
        
        var result = largeWidgets.map { [$0] }
        let miniSubArrays = miniWidgets.chunked(into: miniSubArraySize)
        
        let squareCount = squareWidgets.count
        let isEven = squareCount.isMultiple(of: 2)
        
        result.append(contentsOf: createSquareArrays(count: squareCount / squareSubArraySize))
        
        if !isEven {
            result.append(createSquareArrayWithMinis(miniWidgets))
            let miniSubArray = Array(miniWidgets.dropFirst(maxMinisInSquareArray))
            result.append(contentsOf: miniSubArray.chunked(into: miniSubArraySize))
        } else {
            result.append(contentsOf: miniSubArrays)
        }
        
        return result
    }
    
}
