//
//  CellForNameSection.swift
//  TestAppVeretennikovSergei
//
//  Created by Сергей Веретенников on 25/10/2022.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

final class CellForNameSection: UITableViewCell, CellProtocol {
    
    private let ageTextField = CustomTextField(frame: .zero, placeholder: "Возраст", isAgeTextField: true)
    private lazy var nameTextField = CustomTextField(frame: .zero, placeholder: "Имя", nextResponder: ageTextField)
    
    private(set) var disposeBag: DisposeBag
    private(set) var doneButtonTapped: PublishRelay<Bool>
    private(set) var nameSender: PublishRelay<String>
    private(set) var ageSender: PublishRelay<Int>
    private(set) var clearDataSender: PublishRelay<Void>
    
    static var cellID: String {
        "CellForNameSection"
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        self.disposeBag = DisposeBag()
        self.doneButtonTapped = PublishRelay<Bool>()
        self.nameSender = PublishRelay<String>()
        self.ageSender = PublishRelay<Int>()
        self.clearDataSender = PublishRelay<Void>()
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        isUserInteractionEnabled = false
        setConstraints()
        setupBindings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if nameTextField.frame.contains(point) {
            let _ = nameTextField.becomeFirstResponder()
        } else if ageTextField.frame.contains(point) {
            let _ = ageTextField.becomeFirstResponder()
        } 
        return nil
    }
    
    private func setConstraints() {
        contentView.addSubview(nameTextField)
        contentView.addSubview(ageTextField)
        
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        ageTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            nameTextField.topAnchor.constraint(equalTo: contentView.topAnchor),
            nameTextField.bottomAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -4),
            
            
            ageTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            ageTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            ageTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            ageTextField.topAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 4),
        ])
    }
    
    private func setupBindings() {
        nameTextField.textSender.bind { [weak self] nameValue in
            self?.nameSender.accept(nameValue)
        }.disposed(by: disposeBag)
        
        ageTextField.textSender
            .map { Int($0) ?? 0 }
            .bind { [weak self] ageValue in
                self?.ageSender.accept(ageValue)
            }.disposed(by: disposeBag)
        
        ageTextField.doneButtonTapped
            .bind { [weak self] isValid in
                self?.doneButtonTapped.accept(isValid)
            }.disposed(by: disposeBag)
        
        clearDataSender
            .bind { [weak self] _ in
                self?.nameTextField.clearDataAccepter.accept(())
                self?.nameSender.accept("")
                self?.ageTextField.clearDataAccepter.accept(())
                self?.ageSender.accept(0)
            }.disposed(by: disposeBag)
    }
}
