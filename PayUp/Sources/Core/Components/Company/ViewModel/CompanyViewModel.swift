
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
