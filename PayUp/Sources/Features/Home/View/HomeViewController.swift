//
//  HomeViewController.swift
//  PayUp
//
//  Created by Arthur Rios on 01/05/25.
//

import Foundation
import UIKit

final class HomeViewController: UIViewController {
    private let homeView = HomeView()
    private let viewModel = HomeViewModel()
    private var currentlySelectedDate: Date = Date()
    
    override func loadView() {
        self.view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        setupBindings()
        setupDelegates()
        setupNotificationObserver()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    private func setupBindings() {
        homeView.onTapAddClient = { [weak self] in
            guard let self = self else { return }
            let formViewController = ClientFormViewController(mode: .add)
            formViewController.modalTransitionStyle = .coverVertical
            formViewController.modalPresentationStyle = .overFullScreen
            self.present(formViewController, animated: true)
        }
        
        homeView.onTapFilter = { [weak self] in
            self?.showFilterOptions()
        }
    }
    
    private func showFilterOptions() {
        let alert = UIAlertController(title: "Filtrar",
                                      message: "Escolha como filtrar seus lançamentos",
                                      preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Filtrar por nome",
                                      style: .default) { _ in
            self.showNameFilterAlert()
        })
        
        present(alert, animated: true)
    }
    
    private func showNameFilterAlert() {
        let alert = UIAlertController(title: "Filtrar por nome",
                                      message: "Digite o nome do cliente",
                                      preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Digite o nome do cliente"
        }
        
        alert.addAction(UIAlertAction(title: "Filtrar", style: .default) { _ in
            let name = alert.textFields?.first?.text
            self.viewModel.setNameFilter(name)
            self.refreshCurrentDate()
        })
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func refreshCurrentDate() {
        let transactions = viewModel.getTransactionsForDate(currentlySelectedDate)
        let dateString = viewModel.getDateString(for: currentlySelectedDate)
        
        homeView.updateTransactions(transactions)
        homeView.updateTransactionDate(dateString)
    }
    
    private func loadData() {
        let clients = viewModel.getCompanyModelsFromClients()
        let todayValue = viewModel.getTotalValueForToday()
        let formattedValue = viewModel.formatCurrency(todayValue)
        let todayTransactions = viewModel.getTodayTransactions()
        let todayDateString = viewModel.getTodayDateString()
        
        homeView.updateCompanyList(companies: clients)
        homeView.updateTodayValue(value: formattedValue)
        homeView.updateTransactions(todayTransactions)
        homeView.updateTransactionDate(todayDateString)
    }
    
    private func setupDelegates() {
        homeView.setCompanyListDelegate(self)
        homeView.setDaySelectorDelegate(self)
    }
    
    private func setupNotificationObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleClientDataChanged),
                                               name: .clientDataChanged,
                                               object: nil)
    }
    
    @objc
    private func handleClientDataChanged() {
        loadData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension HomeViewController: CompanyListViewDelegate {
    func didSelectCompany(_ company: CompanyItemModel) {
        guard let client = viewModel.getClientByName(company.name) else {
            print("cliente não encontrado para edição")
            return
        }
        
        let formViewController = ClientFormViewController(mode: .edit(client))
        formViewController.modalTransitionStyle = .coverVertical
        formViewController.modalPresentationStyle = .overFullScreen
        self.present(formViewController, animated: true)
    }
}

extension HomeViewController: DaySelectorViewDelegate {
    func didSelectDay(_ date: Date) {
        currentlySelectedDate = date
        let transactions = viewModel.getTransactionsForDate(date)
        let dateString = viewModel.getDateString(for: date)
        
        homeView.updateTransactions(transactions)
        homeView.updateTransactionDate(dateString)
    }
}
