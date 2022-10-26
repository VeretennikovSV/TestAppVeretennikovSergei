//
//  RegistrationControllerViewModel.swift
//  TestAppVeretennikovSergei
//
//  Created by Сергей Веретенников on 25/10/2022.
//

import Foundation
import RxSwift
import RxRelay

final class ChildsManipulationClass: ChildsManipulationProtocol {
    
    let isButtonHidden: BehaviorRelay<Bool>
    var userChilds: [Child]
    
    init(userChilds: [Child], isButtonHidden: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)) {
        self.isButtonHidden = isButtonHidden
        self.userChilds = userChilds
    }
    
    private func childNameChangedAt(indexPath: IndexPath, on newName: String) {
        guard !userChilds.isEmpty else { return }
        userChilds[indexPath.row].name = newName
    }
    
    private func childAgeChangedAt(indexPath: IndexPath, on newAge: Int) {
        guard !userChilds.isEmpty else { return }
        userChilds[indexPath.row].age = newAge
    }
    
    func addChild() {
        if userChilds.count < 5 {
            userChilds.append(Child(name: "", age: 0))
        }
        userChilds.count == 5 ? isButtonHidden.accept(true) : isButtonHidden.accept(false)
    }
    
    func getChildModelAt(indexPath: IndexPath) -> ChildCellViewModelProtocol {
        ChildCellViewModel(child: userChilds[indexPath.row])
    }
    
    func removeChilds() {
        userChilds.removeAll()
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
}

final class RegistrationControllerViewModel: RegistrationControllerViewModelProtocol {
    
    let childManipulationClass: ChildsManipulationProtocol
    let disposeBag = DisposeBag()
    var userName = BehaviorRelay<String>(value: "")
    var userAge = BehaviorRelay<Int>(value: 0)
    var clearUserData = PublishRelay<Void>()
    var isButtonHidden = BehaviorRelay<Bool>(value: false)
    
    func deleteUserChilds() {
        childManipulationClass.removeChilds()
        isButtonHidden.accept(false)
    }
    
    func setUserCellBindigsWith(cell: CellForNameSection, at indexPath: IndexPath) {
        cell.nameSender.bind(to: userName).disposed(by: cell.disposeBag)
        cell.ageSender.bind(to: userAge).disposed(by: cell.disposeBag)
        
        clearUserData.bind { _ in
            cell.clearDataSender.accept(())
        }.disposed(by: cell.disposeBag)
    }
    
    init(childManipulationClass: ChildsManipulationProtocol = ChildsManipulationClass(userChilds: [])) {
        self.childManipulationClass = childManipulationClass
    }
}
