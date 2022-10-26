//
//  HeaderForNameSection.swift
//  TestAppVeretennikovSergei
//
//  Created by Сергей Веретенников on 25/10/2022.
//

import Foundation
import UIKit
import RxSwift
import RxRelay

final class CustomHeader: UIView {
    
    private let label = UILabel()
    private let button = UIButton()
    private var isSecondSection = false
    
    private(set) var disposeBag: DisposeBag
    private(set) var buttonTapped: PublishRelay<Void>
    private(set) var isButtonHidden: PublishRelay<Bool>
    
    override init(frame: CGRect) {
        self.disposeBag = DisposeBag()
        self.buttonTapped = PublishRelay<Void>()
        
        isButtonHidden = PublishRelay<Bool>()
        
        isButtonHidden.bind(to: button.rx.isHidden).disposed(by: disposeBag)
        
        super.init(frame: frame)
    }
    
    convenience init(
        frame: CGRect, 
        headerText: String, 
        isSecondSection: Bool = false
    ) {
        self.init(frame: frame)
        
        self.isSecondSection = isSecondSection
        
        label.text = headerText
        backgroundColor = .white
        
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraints() {
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(greaterThanOrEqualTo: centerXAnchor),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        if isSecondSection { addButton() }
    }
    
    private func addButton() {
        addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("\u{FF0B} Добавить ребенка", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.layer.borderWidth = 1.5
        button.layer.borderColor = UIColor.blue.cgColor
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(addChildDidTap), for: .touchUpInside)
        
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        button.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: centerXAnchor, constant: -20),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            button.topAnchor.constraint(equalTo: topAnchor),
            button.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    @objc private func addChildDidTap() {
        buttonTapped.accept(())
    }
}
