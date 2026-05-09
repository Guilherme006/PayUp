//
//  HomeViewModel.swift
//  PayUp
//
//  Created by Arthur Rios on 03/09/25.
//

import Foundation

final class HomeViewModel {
    private let databaseManager = DatabaseManager.shared
    private var currentNameFilter: String?
    
    func getAllClients() -> [Client] {
        return databaseManager.getClients()
    }
    
    func getTodayClients() -> [Client] {
        let allClients = getAllClients()
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let todayString = dateFormatter.string(from: today)
        
        return allClients.filter { client in
            return client.dueDate == todayString
        }
    }
    
    func getCompanyModelsFromClients() -> [CompanyItemModel] {
        let clients = getAllClients()
        
        return clients.map { client in
            CompanyItemModel(name: client.name)
        }
    }
    
    func getTotalValueForToday() -> Double {
        let todayClients = getTodayClients()
        
        return todayClients.reduce(0) { total, client in
            total + client.value
        }
    }
    
    func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "BRL"
        formatter.locale = Locale(identifier: "pt_BR")
        
        return formatter.string(from: NSNumber(value: value)) ?? "R$ 0,00"
    }
    
    func getClientByName(_ name: String) -> Client? {
        let allClients = getAllClients()
        return allClients.first { $0.name == name }
    }
    
    func getTodayTransactions() -> [PaymentCardModel] {
        let todayClients = getTodayClients()
        let filteredClients = applyFilters(to: todayClients)
        
        return filteredClients.map { client in
            PaymentCardModel(type: .transaction,
                             name: client.name,
                             value: formatCurrency(client.value))
        }
    }
    
    func getTransactionsForDate(_ date: Date) -> [PaymentCardModel] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateString = dateFormatter.string(from: date)
        
        let allClients = getAllClients()
        let clientsForDate = allClients.filter { client in
            return client.dueDate == dateString
        }
        
        let filteredClients = applyFilters(to: clientsForDate)
        
        return filteredClients.map { client in
            PaymentCardModel(type: .transaction,
                             name: client.name,
                             value: formatCurrency(client.value))
        }
    }
    
    func getDateString(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd 'de' MMMM"
        dateFormatter.locale = .current
        return dateFormatter.string(from: date)
    }
    
    func getTodayDateString() -> String {
        return getDateString(for: Date())
    }
    
    func setNameFilter(_ nameFilter: String?) {
        currentNameFilter = nameFilter
    }
    
    func clearFilters() {
        currentNameFilter = nil
    }
    
    private func applyFilters(to clients: [Client]) -> [Client] {
        var filteredClients = clients
        
        if let nameFilter = currentNameFilter, !nameFilter.isEmpty {
            filteredClients = filteredClients.filter { client in
                client.name.lowercased().contains(nameFilter.lowercased())
            }
        }
        
        return filteredClients
    }
}
