//
//  AligmentCollectionViewCell.swift
//  CollectionViewTutorial
//
//  Created by Alexandr Mefisto on 24.04.2023.
//

import UIKit
import SnapKit

class AligmentCollectionViewCell: UICollectionViewCell {
    
   private let title = {
        let label = UILabel()
        label.numberOfLines = 0
       label.textAlignment = .center
        return label
    }()
    
    internal override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .yellow
        layer.cornerRadius = 8
        addSubview(title)
        title.setContentCompressionResistancePriority(.required, for: .horizontal)
        title.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
            $0.bottom.equalToSuperview().offset(-10)
        }
    }
    
    func setTitle(_ text: String) {
        title.text = text
    }
}

