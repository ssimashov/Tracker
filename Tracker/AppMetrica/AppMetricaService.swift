//
//  AppMetricaService.swift
//  Tracker
//
//  Created by Sergey Simashov on 26.01.2025.
//

import Foundation
import AppMetricaCore

final class AppMetricaService {
    static func activate() {
        guard let configuration = AppMetricaConfiguration(apiKey: "1d9124f4-eead-4392-9e89-ebb763b5c295") else { return }
        AppMetrica.activate(with: configuration)
    }
    
    static func report(event: AppMetricaEvent, params : [AnyHashable : Any]) {
        AppMetrica.reportEvent(name: event.rawValue, parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
}
