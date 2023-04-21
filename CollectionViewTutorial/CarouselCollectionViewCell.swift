//
//  CarouselCollectionViewCell.swift
//  CollectionViewTutorial
//
//  Created by Alexandr Mefisto on 20.04.2023.
//

import UIKit
import SnapKit

class CarouselCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    
    let numberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        layer.cornerRadius = 16
        addSubview(numberLabel)
        numberLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func transformToLarge(){
        UIView.animate(withDuration: 0.2){
          self.transform = CGAffineTransform(scaleX: 1.07, y: 1.07)
        }
      }
      
      func transformToStandard(){
        UIView.animate(withDuration: 0.2){
          self.transform = CGAffineTransform.identity
        }
      }
}
