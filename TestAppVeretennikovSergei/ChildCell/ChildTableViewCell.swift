//
//  ChildTableViewCell.swift
//  TestAppVeretennikovSergei
//
//  Created by Сергей Веретенников on 25/10/2022.
//

import Foundation
import UIKit
import RxSwift
import RxRelay 

final class ChildTableViewCell: UITableViewCell, CellProtocol {
    
    private let deleteButton = UIButton()
    private let ageTextField = CustomTextField(frame: .zero, placeholder: "Возраст", isAgeTextField: true)
    private lazy var nameTextField = CustomTextField(frame: .zero, placeholder: "Имя", nextResponder: ageTextField)
    
    private(set) var viewModel: ChildCellViewModelProtocol?
    private(set) var nameSender: PublishRelay<String>
    private(set) var ageSender: PublishRelay<Int>
    private(set) var doneButtonTapped: PublishRelay<Void>
    private(set) var disposeBag: DisposeBag
    private(set) var deleteChildButtonSender = PublishRelay<Void>()
    
    static var cellID: String {
        "ChildTableViewCell"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel = nil
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.disposeBag = DisposeBag()
        self.nameSender = PublishRelay<String>()
        self.ageSender = PublishRelay<Int>()
        self.doneButtonTapped = PublishRelay<Void>()
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        isUserInteractionEnabled = false
        setConstraints()
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if nameTextField.frame.contains(point) {
            let _ = nameTextField.becomeFirstResponder()
        } else if ageTextField.frame.contains(point) {
            let _ = ageTextField.becomeFirstResponder()
        } else if deleteButton.frame.contains(point) {
            return deleteButton
        } 
        return nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraints() {
        contentView.addSubview(nameTextField)
        contentView.addSubview(ageTextField)
        contentView.addSubview(deleteButton)
        deleteButton.setTitle("Удалить", for: .normal)
        deleteButton.setTitleColor(.blue, for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        ageTextField.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: contentView.centerXAnchor),
            nameTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            nameTextField.bottomAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -16),
            
            ageTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            ageTextField.trailingAnchor.constraint(equalTo: contentView.centerXAnchor),
            ageTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            ageTextField.topAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 16),
            
            deleteButton.leadingAnchor.constraint(equalTo: nameTextField.trailingAnchor, constant: 24),
            deleteButton.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 1),
            deleteButton.heightAnchor.constraint(equalTo: nameTextField.heightAnchor),
            deleteButton.centerYAnchor.constraint(equalTo: nameTextField.centerYAnchor)
        ])
        
        setSeparator()
    }
    
    private func setSeparator() {
        let separator = UIView()
        
        addSubview(separator)
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = .gray
        
        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            separator.heightAnchor.constraint(equalToConstant: 0.5),
            separator.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    @objc private func deleteTapped() {
        deleteChildButtonSender.accept(())
    }
    
    func configureViewModel(viewModel: ChildCellViewModelProtocol) {
        guard self.viewModel == nil else { return }
        self.viewModel = viewModel
        
        nameTextField.setText(viewModel.childModel.name)
        ageTextField.setText(String(viewModel.childModel.age))
        
        nameTextField.textSender
            .skip(1)
            .withUnretained(self)
            .bind { 
                print("Sended")
                $0.nameSender.accept($1)
            }
            .disposed(by: viewModel.disposeBag)
        
        ageTextField.textSender
            .skip(1)
            .map { Int($0) ?? 0 }
            .withUnretained(self)
            .bind { $0.ageSender.accept($1) }
            .disposed(by: viewModel.disposeBag)
        
        ageTextField.doneButtonTapped
            .bind { [weak self] _ in
                self?.doneButtonTapped.accept(())
            }.disposed(by: viewModel.disposeBag)
    }
}
