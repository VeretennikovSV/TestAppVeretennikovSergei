//
//  RegistrationControllerViewModel.swift
//  TestAppVeretennikovSergei
//
//  Created by Сергей Веретенников on 25/10/2022.
//

import Foundation
import RxSwift
import RxRelay

protocol RegistrationControllerViewModelProtocol {
    var disposeBag: DisposeBag { get }
    
    var userName: BehaviorRelay<String> { get set }
    var userAge: BehaviorRelay<Int> { get set }
    var clearUserData: PublishRelay<Void> { get }
    
    var userChilds: [Child] { get set }
    var isButtonHidden: BehaviorRelay<Bool> { get set }
    
    func addChild()
    func getChildModelAt(indexPath: IndexPath) -> ChildCellViewModelProtocol
    
    func setUserCellBindigsWith(cell: CellForNameSection, at indexPath: IndexPath)
    func setChildCellBindingsWith(cell: ChildTableViewCell, at indexPath: IndexPath)
    
    func deleteChildAt(indexPath: IndexPath)
    func deleteUserChilds()
}

final class RegistrationControllerViewModel: RegistrationControllerViewModelProtocol {
    
    let disposeBag = DisposeBag()
    var userName = BehaviorRelay<String>(value: "")
    var userAge = BehaviorRelay<Int>(value: 0)
    var clearUserData = PublishRelay<Void>()
    var isButtonHidden = BehaviorRelay<Bool>(value: false)
    
    var userChilds: [Child] = []
    
    func addChild() {
        if userChilds.count < 5 {
            userChilds.append(Child(name: "", age: 0))
        }
        userChilds.count == 5 ? isButtonHidden.accept(true) : isButtonHidden.accept(false)
    }
    
    private func childNameChangedAt(indexPath: IndexPath, on newName: String) {
        guard !userChilds.isEmpty else { return }
        userChilds[indexPath.row].name = newName
    }
    
    private func childAgeChangedAt(indexPath: IndexPath, on newAge: Int) {
        guard !userChilds.isEmpty else { return }
        userChilds[indexPath.row].age = newAge
    }
    
    func getChildModelAt(indexPath: IndexPath) -> ChildCellViewModelProtocol {
        ChildCellViewModel(child: userChilds[indexPath.row])
    }
    
    func setUserCellBindigsWith(cell: CellForNameSection, at indexPath: IndexPath) {
        cell.nameSender.bind(to: userName).disposed(by: cell.disposeBag)
        cell.ageSender.bind(to: userAge).disposed(by: cell.disposeBag)
        
        clearUserData.bind { _ in
            cell.clearDataSender.accept(())
        }.disposed(by: cell.disposeBag)
    }
    
    func setChildCellBindingsWith(cell: ChildTableViewCell, at indexPath: IndexPath) {
            cell.configureViewModel(viewModel: getChildModelAt(indexPath: indexPath))
            cell.nameSender
                .withUnretained(self)
                .bind { $0.childNameChangedAt(indexPath: indexPath, on: $1) }
                .disposed(by: cell.viewModel?.disposeBag ?? DisposeBag())
            
            cell.ageSender
                .withUnretained(self)
                .bind { $0.childAgeChangedAt(indexPath: indexPath, on: $1)}
                .disposed(by: cell.viewModel?.disposeBag ?? DisposeBag())
            
    }
    
    func deleteChildAt(indexPath: IndexPath) {
        guard !userChilds.isEmpty else { return }
        userChilds.remove(at: indexPath.row)
        isButtonHidden.accept(false)
    }
    
    func deleteUserChilds() {
        userChilds.removeAll()
        isButtonHidden.accept(false)
    }
}
