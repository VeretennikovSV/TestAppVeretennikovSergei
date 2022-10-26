//
//  BaseViewModel.swift
//  TestAppVeretennikovSergei
//
//  Created by Сергей Веретенников on 26/10/2022.
//

import Foundation
import RxSwift

protocol BaseViewModelProtocol {
    var disposeBag: DisposeBag { get }
}

class BaseViewModel: BaseViewModelProtocol {
    var disposeBag: DisposeBag = DisposeBag()
}
