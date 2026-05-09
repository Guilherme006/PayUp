//
//  PaymentCardView.swift
//  PayUp
//
//  Created by Arthur Rios on 02/05/25.
//

import Foundation
import UIKit

final class PaymentCardView: UIView {
    
    private let iconImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = Colors.accentOrange
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let subtitleLable: UILabel = {
        let label = UILabel()
        label.font = Fonts.paragraphSmall()
        label.textColor = Colors.textSpan
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameLable: UILabel = {
        let label = UILabel()
        label.font = Fonts.titleSmall()
        label.textColor = Colors.textHeading
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let valueLable: UILabel = {
        let label = UILabel()
        label.font = Fonts.paragraphMedium()
        label.textColor = Colors.textParagraph
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Colors.backgroundSecondary
        view.layer.cornerRadius = 8
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(container)
        container.addSubview(iconImageView)
        container.addSubview(subtitleLable)
        container.addSubview(nameLable)
        container.addSubview(valueLable)
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: topAnchor),
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            iconImageView.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
            iconImageView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            
            subtitleLable.topAnchor.constraint(equalTo: iconImageView.topAnchor),
            subtitleLable.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
            
            nameLable.topAnchor.constraint(equalTo: subtitleLable.bottomAnchor, constant: 4),
            nameLable.leadingAnchor.constraint(equalTo: subtitleLable.leadingAnchor),
            nameLable.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8),
            
            valueLable.topAnchor.constraint(equalTo: nameLable.bottomAnchor, constant: 4),
            valueLable.leadingAnchor.constraint(equalTo: subtitleLable.leadingAnchor),
            valueLable.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -12)
        ])
    }
    
    func configure(with model: PaymentCardModel) {
        let image = UIImage(named: model.type.iconName)
        
        iconImageView.image = image
        subtitleLable.text = model.type.subtitle
        nameLable.text = model.name
        valueLable.text = model.value
    }
}
