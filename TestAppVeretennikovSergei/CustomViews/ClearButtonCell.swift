//
//  ClearButtonCell.swift
//  TestAppVeretennikovSergei
//
//  Created by Сергей Веретенников on 25/10/2022.
//

import Foundation
import UIKit
import RxSwift
import RxRelay

final class ClearButtonCell: UITableViewCell {
    
    private let button = UIButton()
    private(set) var disposeBag = DisposeBag()
    
    let crearTapped = PublishRelay<Void>()
    
    static var cellID: String {
        "ClearButtonCell"
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        button.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
        setConstraints()
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if button.frame.contains(point) {
            return button
        }
        return nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraints() {
        contentView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.red, for: .normal)
        button.setTitle("Удалить данные", for: .normal)
        button.layer.cornerRadius = 30
        button.layer.borderColor = UIColor.red.cgColor
        button.layer.borderWidth = 2
        
        NSLayoutConstraint.activate([
            button.centerYAnchor.constraint(equalTo: centerYAnchor),
            button.centerXAnchor.constraint(equalTo: centerXAnchor),
            button.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6),
            button.heightAnchor.constraint(equalTo: heightAnchor)
        ])
    }
    
    @objc private func clearButtonTapped() {
        print("LALA")
        self.crearTapped.accept(())
    }
}
