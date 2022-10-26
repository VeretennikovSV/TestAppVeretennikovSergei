//
//  ViewController.swift
//  TestAppVeretennikovSergei
//
//  Created by Сергей Веретенников on 25/10/2022.
//

import UIKit
import RxSwift
import RxCocoa

final class RegistrationViewController: UIViewController {
    
    private var viewModel: RegistrationControllerViewModelProtocol!
    private let tableView = UITableView()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = RegistrationControllerViewModel()
        
        view.backgroundColor = .white
        
        setConstraints()
    }
    
    weak var tableViewBottomLayoutConstraint: NSLayoutConstraint!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification , object: nil)
    }

    private func setConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CellForNameSection.self, forCellReuseIdentifier: CellForNameSection.cellID)
        tableView.register(ChildTableViewCell.self, forCellReuseIdentifier: ChildTableViewCell.cellID)
        tableView.register(ClearButtonCell.self, forCellReuseIdentifier: ClearButtonCell.cellID)
        
        tableView.separatorStyle = .none
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
        tableViewBottomLayoutConstraint = tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        tableViewBottomLayoutConstraint.isActive = true
    }
    
    private func setUserCellBindigsWith(cell: CellForNameSection, indexPath: IndexPath) {
        
        viewModel.setUserCellBindigsWith(cell: cell, at: indexPath)
        
        cell.doneButtonTapped.bind { [weak self] _ in
            self?.endEditing()
        }.disposed(by: cell.disposeBag)
    }
    
    private func setChildCellsBindingWith(cell: ChildTableViewCell, indexPath: IndexPath) {
        
        viewModel.childManipulationClass.setChildCellBindingsWith(cell: cell, at: indexPath)
        
        cell.deleteChildButtonSender
            .withUnretained(self)
            .bind { vc, _ in
                vc.viewModel.childManipulationClass.deleteChildAt(indexPath: indexPath)
                vc.tableView.reloadData()
            }
            .disposed(by: cell.viewModel?.disposeBag ?? DisposeBag())
        
        cell.doneButtonTapped.bind { [weak self] _ in
            self?.endEditing()
        }
        .disposed(by: cell.disposeBag)
    }
    
    private func deleteData() {
        viewModel.clearUserData.accept(())
        viewModel.deleteUserChilds()
        tableView.reloadData()
    }
    
    private func endEditing() {
        view.endEditing(true)
    }
    
    @objc func keyboardWillAppear(notification: NSNotification?) {

        guard let keyboardFrame = notification?.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }

        let keyboardHeight: CGFloat
        if #available(iOS 11.0, *) {
            keyboardHeight = keyboardFrame.cgRectValue.height - self.view.safeAreaInsets.bottom
        } else {
            keyboardHeight = keyboardFrame.cgRectValue.height
        }

        tableViewBottomLayoutConstraint.constant = -keyboardHeight
        
    }

    @objc func keyboardWillDisappear(notification: NSNotification?) {
        tableViewBottomLayoutConstraint.constant = 0.0
    }
    
}

extension RegistrationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellForNameSection.cellID, for: indexPath) as? CellForNameSection else { return UITableViewCell() }  
            
            setUserCellBindigsWith(cell: cell, indexPath: indexPath)
            
            return cell
        case 1: 
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ChildTableViewCell.cellID, for: indexPath) as? ChildTableViewCell else { return UITableViewCell() }  
            
            setChildCellsBindingWith(cell: cell, indexPath: indexPath)
            
            return cell
        default: 
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ClearButtonCell.cellID, for: indexPath) as? ClearButtonCell else { return UITableViewCell() }  
            
            cell.crearTapped.bind { [weak self] _ in
                self?.showAlert()
            }.disposed(by: disposeBag)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 2 {
            return 0
        }
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return viewModel.childManipulationClass.userChilds.count
        default: return 1
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0: 
            return CustomHeader(frame: .zero, headerText: "Персональные данные")
        case 1: 
            let header = CustomHeader(frame: .zero, headerText: "Дети (макс. 5)", isSecondSection: true)
            
            viewModel.childManipulationClass.isButtonHidden.bind(to: header.isButtonHidden).disposed(by: header.disposeBag)
            
            header.buttonTapped.bind { [weak self] _ in
                self?.viewModel.childManipulationClass.addChild()
                tableView.reloadData()
            }.disposed(by: header.disposeBag)
            
            return header
        default: 
            return nil
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 2 {
            return 60
        }
        return 200
    }
}

//MARK: AlertSheet
extension RegistrationViewController {
    private func showAlert() {
        let alert = UIAlertController(title: "Очистить данные?", message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        let deleteAction = UIAlertAction(title: "Очистить", style: .destructive) { [weak self] _ in 
            self?.deleteData()
        }
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
}
