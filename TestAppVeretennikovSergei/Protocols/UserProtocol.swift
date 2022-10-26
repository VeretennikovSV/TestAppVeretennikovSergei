//
//  UserProtocol.swift
//  TestAppVeretennikovSergei
//
//  Created by Сергей Веретенников on 26/10/2022.
//

import Foundation
import RxSwift
import RxRelay

protocol RegistrationControllerViewModelProtocol {
    var disposeBag: DisposeBag { get }
    var childManipulationClass: ChildsManipulationProtocol { get }
    
    var userName: BehaviorRelay<String> { get set }
    var userAge: BehaviorRelay<Int> { get set }
    var clearUserData: PublishRelay<Void> { get }
    
    func setUserCellBindigsWith(cell: CellForNameSection, at indexPath: IndexPath)
    func deleteUserChilds()
}
