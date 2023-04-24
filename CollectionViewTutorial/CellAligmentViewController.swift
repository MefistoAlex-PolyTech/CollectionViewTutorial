//
//  CellAligmentViewController.swift
//  CollectionViewTutorial
//
//  Created by Alexandr Mefisto on 24.04.2023.
//

import UIKit

final class CellAligmentViewController: UIViewController {

    let reuseIdentifier = "AligmentCell"
    
    private let items = ["First", "Second\n", "Third", "Fourth\n", "Fifth", "Sixth\n", "Seventh"]
    
    private lazy var collectionView = {
        
        let layout = AlignedCollectionViewFlowLayout(horizontalAlignment: .trailing, verticalAlignment: .center)
       layout.minimumLineSpacing = 30
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right:20)
        layout.scrollDirection = .vertical
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .blue
        collectionView.register(AligmentCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        layout()
    }
    
    private func layout() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

extension CellAligmentViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let item = items[indexPath.row]
        var sise = item.sizeOfString(usingFont: UIFont.preferredFont(forTextStyle: .title1))
        sise.width += 20
        sise.height += 20
        return sise
    }

   
}

extension CellAligmentViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AligmentCollectionViewCell
        cell.setTitle(items[indexPath.row])
        
        return cell
    }
}


extension String {
    func sizeOfString(usingFont font: UIFont) -> CGSize {
            let fontAttributes = [NSAttributedString.Key.font: font]
            return self.size(withAttributes: fontAttributes)
        }
}
