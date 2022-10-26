//
//  CellProtocol.swift
//  TestAppVeretennikovSergei
//
//  Created by Сергей Веретенников on 26/10/2022.
//

import Foundation
import RxSwift
import RxRelay

protocol CellProtocol {
    
    var nameSender: PublishRelay<String> { get }
    var ageSender: PublishRelay<Int> { get }
    var doneButtonTapped: PublishRelay<Void> { get }
    var disposeBag: DisposeBag { get }  
    
}
