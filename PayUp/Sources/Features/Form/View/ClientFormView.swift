//
//  ClientFormView.swift
//  PayUp
//
//  Created by Arthur Rios on 30/06/25.
//

import UIKit

final class ClientFormView: UIView {
    private let mode: ClientFormMode
    weak var delegate: ClientFormViewDelegate?
    
    let containerView: UIView = {
       let view = UIView()
        view.backgroundColor = Colors.backgroundPrimary
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        switch mode {
            case .add:
            label.text = "Adicionar cliente"
        case .edit:
            label.text = "Editar cliente"
        }
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let recurringLabel: UILabel = {
        let label = UILabel()
        label.text = "Cobrança recorrente?"
        label.font = Fonts.titleSmall()
        label.textColor = Colors.textHeading
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let recurringSwitch: UISwitch = {
        let switchView = UISwitch()
        switchView.onTintColor = Colors.accentBrand
        switchView.translatesAutoresizingMaskIntoConstraints = false
        return switchView
    }()
    
    private let frequencyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Mensalmente", for: .normal)
        button.setTitleColor(Colors.textLabel, for: .normal)
        button.titleLabel?.font = Fonts.paragraphMedium()
        button.backgroundColor = .clear
        button.contentHorizontalAlignment = .leading
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let frequencyOptions = [
        "Mensalmente",
        "Semanalmente",
        "Anualmente"
    ]
    
    private var selectedFrequency = "Mensalmente"
    
    private let daySelectorView = DaySelectorView()
    private lazy var clientNameField = InputTextFieldView(title: "Nome do cliente", placeholder: "Ex: Joao Silva", type: .normal)
    private lazy var contactField = InputTextFieldView(title: "Contato", placeholder: "Ex: joao.silva@exemplo.com", type: .normal)
    private lazy var phoneField = InputTextFieldView(title: "Telefone", placeholder: "Ex: (31) 91234-5678", type: .cellphone)
    private lazy var cnpjField = InputTextFieldView(title: "CNPJ", placeholder: "Ex: 12.345.678/0001-90", type: .cnpj)
    private lazy var addressField = InputTextFieldView(title: "Endereço", placeholder: "Ex: Rua das Flores, 123, Centro", type: .normal)
    
    private lazy var valueField = CurrencyTextField(title: "Valor", placeholder: "R$ 0,00")
    private lazy var dateField = DatePickerTextField(title: "Data de cobrança", placeholder: "DD/MM/AAAA")
    
    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancelar", for: .normal)
        button.setTitleColor(Colors.textLabel, for: .normal)
        button.titleLabel?.font = Fonts.titleSmall()
        button.backgroundColor = Colors.backgroundTertiary
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        switch mode {
            case .add:
            button.setTitle("Salvar", for: .normal)
        case .edit:
            button.setTitle("Salvar alterações", for: .normal)
        }
        button.setTitleColor(Colors.backgroundPrimary, for: .normal)
        button.titleLabel?.font = Fonts.titleSmall()
        button.backgroundColor = Colors.accentBrand
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "trash"), for: .normal)
        button.tintColor = Colors.accentRed
        button.backgroundColor = Colors.backgroundTertiary
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(mode: ClientFormMode) {
        self.mode = mode
        super.init(frame: .zero)
        backgroundColor = Colors.backgroundPrimary
        setupView()
        setupInitialState()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.9)
        ])
        
        setupStack()
    }
    
    private func setupStack() {
        setupActions()
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        
        let recurringContainer = UIView()
        let recurringStack = UIStackView(arrangedSubviews: [
            recurringLabel,
            recurringSwitch,
            frequencyButton
        ])
        recurringStack.axis = .horizontal
        recurringStack.spacing = 8
        recurringStack.alignment = .center
        recurringStack.translatesAutoresizingMaskIntoConstraints = false
        recurringContainer.addSubview(recurringStack)
        
        let buttonStack = UIStackView()
        switch mode {
        case .add:
            break
        case .edit:
            buttonStack.addArrangedSubview(deleteButton)
        }
        buttonStack.addArrangedSubview(cancelButton)
        buttonStack.addArrangedSubview(saveButton)
        buttonStack.axis = .horizontal
        buttonStack.spacing = 12
        buttonStack.distribution = .fillEqually

        let formStack = UIStackView(arrangedSubviews: [
            titleLabel,
            valueField,
            dateField,
            recurringContainer,
            daySelectorView,
            clientNameField,
            contactField,
            phoneField,
            cnpjField,
            addressField,
            buttonStack
        ])
        
        formStack.axis = .vertical
        formStack.spacing = 16
        formStack.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(formStack)
        containerView.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            scrollView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            scrollView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            scrollView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -24),
            
            formStack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            formStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            formStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            formStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            formStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            cancelButton.heightAnchor.constraint(equalToConstant: 44),
            saveButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        switch mode {
        case .add:
            break
        case .edit:
            NSLayoutConstraint.activate([
                deleteButton.heightAnchor.constraint(equalToConstant: 44),
                deleteButton.widthAnchor.constraint(equalToConstant: 44)
            ])
        }
        
        NSLayoutConstraint.activate([
            recurringStack.topAnchor.constraint(equalTo: recurringContainer.topAnchor),
            recurringStack.leadingAnchor.constraint(equalTo: recurringContainer.leadingAnchor),
            recurringStack.trailingAnchor.constraint(equalTo: recurringContainer.trailingAnchor),
            recurringStack.bottomAnchor.constraint(equalTo: recurringContainer.bottomAnchor)
        ])
    }
    
    func getClientData() -> Client? {
        guard let name = clientNameField.getText(), !name.isEmpty,
              let contact = contactField.getText(), !contact.isEmpty,
              let phone = phoneField.getText(), !phone.isEmpty,
              let cnpj = cnpjField.getText(), !cnpj.isEmpty,
              let address = addressField.getText(), !address.isEmpty,
              let dueDate = dateField.getText(), !dueDate.isEmpty
        else {
            return nil
        }
        
        let value = valueField.getValue()
        let selectedDay = daySelectorView.getSelectedDay()
        
        let clientId: Int?
        switch mode {
        case .add:
            clientId = nil
        case .edit(let client):
            clientId = client.id
        }
        
        return Client(
            id: clientId,
            name: name,
            contact: contact,
            phone: phone,
            cnpj: cnpj,
            address: address,
            value: value,
            dueDate: dueDate,
            isRecurring: recurringSwitch.isOn,
            frequency: selectedFrequency,
            selectedDay: selectedDay
        )
    }
    
    private func setupActions() {
        recurringSwitch.addTarget(self, action: #selector(recurringToggled), for: .valueChanged)
        frequencyButton.addTarget(self, action: #selector(frequencyTapped), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        
        switch mode {
        case .add:
            break
        case .edit:
            deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        }
    }
    
    @objc
    private func recurringToggled() {
        daySelectorView.isHidden = !recurringSwitch.isOn
        frequencyButton.isHidden = !recurringSwitch.isOn
    }
    
    @objc
    private func frequencyTapped() {
        let alert = UIAlertController(title: "Frequência", message: "Selecione a frequência de cobrança", preferredStyle: .actionSheet)
        
        for option in frequencyOptions {
            let action = UIAlertAction(title: option, style: .default) { [weak self] _ in
                self?.selectedFrequency = option
                self?.frequencyButton.setTitle(option, for: .normal)
            }
            alert.addAction(action)
        }
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        
        if let viewController = self.parentViewController() {
            viewController.present(alert, animated: true)
        }
    }
    
    @objc
    private func cancelTapped() {
        delegate?.didTapCancel()
    }
    
    @objc
    private func saveTapped() {
        delegate?.didTapSave()
    }
    
    @objc
    private func deleteTapped() {
        delegate?.didTapDelete()
    }
    
    private func setupInitialState() {
        daySelectorView.isHidden = !recurringSwitch.isOn
        frequencyButton.isHidden = !recurringSwitch.isOn
        
        switch mode {
        case .add:
            break
        case .edit(let client):
            populateFieldsForEditMode(with: client)
        }
    }
    
    private func populateFieldsForEditMode(with client: Client) {
        clientNameField.setText(client.name)
        contactField.setText(client.contact)
        phoneField.setText(client.phone)
        cnpjField.setText(client.cnpj)
        addressField.setText(client.address)
        valueField.setValue(client.value)
        dateField.setText(client.dueDate)
        recurringSwitch.isOn = client.isRecurring
        selectedFrequency = client.frequency
        frequencyButton.setTitle(client.frequency, for: .normal)
        
        if let selectedDay = client.selectedDay {
            daySelectorView.selectDay(selectedDay)
        }
        
        recurringToggled()
    }
}
