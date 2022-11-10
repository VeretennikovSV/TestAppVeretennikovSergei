//
//  CuntomTextField.swift
//  TestAppVeretennikovSergei
//
//  Created by Сергей Веретенников on 25/10/2022.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

final class CustomTextField: UIView {
    
    private let textField = UITextField()
    private let placeholderLabel = UILabel()
    private var disposeBag: DisposeBag
    private var isAgeTextField: Bool = false
    private var nextField: CustomTextField?
    private(set) var doneButtonTapped = PublishRelay<Bool>()
    
    private(set) var textSender: PublishSubject<String>
    private(set) var clearDataAccepter: PublishRelay<Void>
    
    override init(frame: CGRect) {
        
        self.disposeBag = DisposeBag()
        self.textSender = PublishSubject<String>()
        self.clearDataAccepter = PublishRelay<Void>()
        
        super.init(frame: frame)
        setConstraints()
        setBindings()
    }
    
    convenience init(
        frame: CGRect, 
        placeholder: String, 
        isAgeTextField: Bool = false,
        nextResponder: CustomTextField? = nil
    ) {
        self.init(frame: frame)
        self.nextField = nextResponder
        self.isAgeTextField = isAgeTextField
        
        if isAgeTextField { setDecimalKeyboard() }
        
        placeholderLabel.text = placeholder
        layer.cornerRadius = 6
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 1.5
    }
    
    override func becomeFirstResponder() -> Bool {
        textField.becomeFirstResponder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setDecimalKeyboard() {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Готово", image: nil, target: self, action: #selector(doneTapped))
        
        toolBar.items = [space, doneButton] 
        toolBar.sizeToFit()
        
        textField.inputAccessoryView = toolBar
        textField.keyboardType = .decimalPad 
    }
    
    private func setBindings() {
        textField.rx.value.bind { [weak self] text in
            self?.textSender.onNext(text ?? "")
        }.disposed(by: disposeBag)
        
        clearDataAccepter
            .bind { [weak textField] _ in
                textField?.text = ""
            }.disposed(by: disposeBag)
    }
    
    private func setConstraints() {
        addSubview(textField)
        addSubview(placeholderLabel)
        textField.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        textField.delegate = self
        textField.borderStyle = .none
        textField.returnKeyType = .next
        
        placeholderLabel.textColor = .lightGray
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            placeholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            placeholderLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            placeholderLabel.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            placeholderLabel.bottomAnchor.constraint(equalTo: centerYAnchor),
            
            textField.topAnchor.constraint(equalTo: placeholderLabel.bottomAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4)
        ])
    }
    
    @objc private func doneTapped() {
        
        if isAgeTextField {
            if (Int(textField.text ?? "") ?? 0) > 70 {
                textField.becomeFirstResponder()
                doneButtonTapped.accept(false)
                return
            }
        }
        
        doneButtonTapped.accept(true)
    }
    
    
    func setText(_ string: String) {
        textField.text = string
    }
}

extension CustomTextField: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField {
            let _ = nextField.becomeFirstResponder()
            return false
        }
        return true
    }
}
