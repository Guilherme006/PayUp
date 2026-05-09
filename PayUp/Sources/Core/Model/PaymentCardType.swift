//
//  PaymentCardType.swift
//  PayUp
//
//  Created by Arthur Rios on 16/06/25.
//

import Foundation

enum PaymentCardType {
    case incoming
    case transaction
    
    var iconName: String {
        switch self {
        case .incoming:
            return "calendarDollar"
        case .transaction:
            return "coins"
        }
    }
    
    var subtitle: String {
        switch self {
        case .incoming:
            return "A receber"
        case .transaction:
            return "Recebido"
        }
    }
}
