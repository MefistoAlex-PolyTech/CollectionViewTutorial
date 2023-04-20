//
//  CollectionViewCell.swift
//  CollectionViewTutorial
//
//  Created by Alexandr Mefisto on 19.04.2023.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
   
    private let title = UILabel()
    
    override var isSelected: Bool {
        didSet {
            layer.borderColor = isSelected ? UIColor.systemBlue.cgColor : UIColor.clear.cgColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        backgroundColor = .yellow
        layer.borderWidth = 2
        layer.borderColor = UIColor.clear.cgColor
        layer.cornerRadius = 16
        addSubview(title)
        title.numberOfLines = 0
        title.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func configure (country: String) {
        title.text = country
    }
}
