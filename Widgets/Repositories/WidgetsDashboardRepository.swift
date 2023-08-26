//
//  WidgetsDashboardRepository.swift
//  Widgets
//
//  Created by Mohamed anwar on 24/08/2023.
//

import Foundation

enum ServiceError: Error, LocalizedError {
    case noData
    
    var errorDescription: String {
        switch self {
        case .noData:
            return "No Data"
        }
    }
}

protocol WidgetsDashboardRepositoryProtocol {
    @MainActor func getWidgets() async throws -> [Widget]
}

final class WidgetsDashboardRepository: WidgetsDashboardRepositoryProtocol {
    
    @MainActor func getWidgets() async throws -> [Widget] {
        guard
            let url = Bundle.main.url(forResource: "dashboard", withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let countries = try? JSONDecoder().decode([Widget].self, from: data)
        else {
            throw ServiceError.noData
        }
        
        return countries
    }
    
}
