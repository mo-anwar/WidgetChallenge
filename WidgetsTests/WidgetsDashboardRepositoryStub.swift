//
//  WidgetsDashboardRepositoryStub.swift
//  WidgetsTests
//
//  Created by Mohamed anwar on 26/08/2023.
//

import Foundation
@testable import Widgets

final class WidgetsDashboardRepositoryStub: WidgetsDashboardRepositoryProtocol {
    
    var widgets: [Widget]?

    func getWidgets() throws -> [Widget] {
        if let widgets {
            return widgets
        }
        
        throw ServiceError.noData
    }
    
}
