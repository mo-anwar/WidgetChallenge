//
//  WidgetsTests.swift
//  WidgetsTests
//
//  Created by Mohamed anwar on 26/08/2023.
//

import XCTest
import CombineTestExtensions
@testable import Widgets

final class WidgetsTests: XCTestCase {

    private var widgetsDashboardRepository: WidgetsDashboardRepositoryStub!
    private var viewModel: WidgetsDashboardViewModelProtocol!
    
    override func setUp() {
        super.setUp()
        widgetsDashboardRepository = .init()
        viewModel = WidgetsDashboardViewModel(widgetsDashboardRepository: widgetsDashboardRepository)
    }
    
    override func tearDown() {
        widgetsDashboardRepository = nil
        viewModel = nil
        super.tearDown()
    }
    
    func testFetchWigetSuccess() {
        //GIVEN
        let viewStateRecorder = viewModel.output.$viewState.record(numberOfRecords: 3)
        let widgetRecorder = viewModel.output.$dataSource.record(numberOfRecords: 2)
        
        let widgets: [Widget] = [
            .init(style: .mini),
            .init(style: .large),
            .init(style: .mini),
            .init(style: .square),
            .init(style: .mini),
            .init(style: .mini)
        ]
        
        let expectedWidgets: [[Widget]] = [
            [.init(style: .large)],
            [
                .init(style: .square),
                .init(style: .mini),
                .init(style: .mini),
                .init(style: .mini),
                .init(style: .mini)
            ]
        ]
        
        widgetsDashboardRepository.widgets = widgets
        
        //WHEN
        viewModel.input.viewDidLoadTrigger.send()
        let viewStateRecords = viewStateRecorder.waitAndCollectRecords()
        let widgetRecords = widgetRecorder.waitAndCollectRecords()
        
        //THEN
        XCTAssertEqual(viewStateRecords, [
            .value(nil),
            .value(.loading(isUserInteractionEnabled: true)),
            .value(.idle)
        ])
        
        XCTAssertEqual(widgetRecords, [
            .value([]),
            .value(expectedWidgets)
        ])

        
    }
    
    func testFetchWidgetFail() {
        //GIVEN
        let viewStateRecorder = viewModel.output.$viewState.record(numberOfRecords: 4)
        let widgetRecorder = viewModel.output.$dataSource.record(numberOfRecords: 1)

        widgetsDashboardRepository.widgets = nil

        //WHEN
        viewModel.input.viewDidLoadTrigger.send()
        let viewStateRecords = viewStateRecorder.waitAndCollectRecords()
        let widgetRecords = widgetRecorder.waitAndCollectRecords()

        //THEN
        XCTAssertEqual(viewStateRecords, [
            .value(nil),
            .value(.loading(isUserInteractionEnabled: true)),
            .value(.idle),
            .value(.error(message: ServiceError.noData.localizedDescription))
        ])

        XCTAssertEqual(widgetRecords, [
            .value([]),
        ])

    }

}
