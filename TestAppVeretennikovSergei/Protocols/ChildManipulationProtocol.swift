//
//  ChildManipulationProtocol.swift
//  TestAppVeretennikovSergei
//
//  Created by Сергей Веретенников on 26/10/2022.
//

import Foundation
import RxSwift
import RxRelay

protocol ChildsManipulationProtocol {
    var isButtonHidden: BehaviorRelay<Bool> { get }
    var userChilds: [Child] { get }
    
    func addChild()
    func getChildModelAt(indexPath: IndexPath) -> ChildCellViewModelProtocol
    
    func setChildCellBindingsWith(cell: ChildTableViewCell, at indexPath: IndexPath)
    func removeChilds()
    
    func deleteChildAt(indexPath: IndexPath)
}
