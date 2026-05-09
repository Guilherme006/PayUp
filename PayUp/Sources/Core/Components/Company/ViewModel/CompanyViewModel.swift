//
//  CompanyViewModel.swift
//  PayUp
//
//  Created by Arthur Rios on 12/05/25.
//

import Foundation

final class CompanyViewModel {
    var companies: [CompanyItemModel] = []
    
    init(companies: [CompanyItemModel]) {
        self.companies = companies
    }
    
    func updateCompanies(_ companies: [CompanyItemModel]) {
        self.companies = companies
    }
}
