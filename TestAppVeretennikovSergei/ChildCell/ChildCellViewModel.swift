//
//  ChildCellViewModel.swift
//  TestAppVeretennikovSergei
//
//  Created by Сергей Веретенников on 25/10/2022.
//
import RxSwift
import Foundation

protocol ChildCellViewModelProtocol {
    var childModel: Child { get }
    var disposeBag: DisposeBag { get }
}

final class ChildCellViewModel: ChildCellViewModelProtocol {
    let childModel: Child
    let disposeBag: DisposeBag
    
    init(child: Child) {
        self.disposeBag = DisposeBag()
        self.childModel = child
    }
}
