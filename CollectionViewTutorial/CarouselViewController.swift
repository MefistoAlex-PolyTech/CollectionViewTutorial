//
//  CarouselViewController.swift
//  CollectionViewTutorial
//
//  Created by Alexandr Mefisto on 20.04.2023.
//

import UIKit

struct CarouselItem: Hashable {
    let title: String
    let color: UIColor
}


class CarouselViewController: UIViewController {
    // MARK: - Propertise
    
    var centerCell: CarouselCollectionViewCell?
    
    let items = [
        CarouselItem(title: "1", color: .green),
        CarouselItem(title: "2", color: .red),
        CarouselItem(title: "3", color: .blue),
    ]
    
    let numberOfItems = 100
    
    let reuseIdentifier = "CarouselCell"
    
    lazy var collectionView = {
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize(width: self.view.bounds.width * 0.6, height: self.view.bounds.height * 0.6)
        layout.minimumLineSpacing = 30
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right:20)
        layout.scrollDirection = .horizontal
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        return collection
    }()
    
    let toAligmentLayoutButton = {
        let button = UIButton()
        button.setTitle("To Aligment", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        return button
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        super.viewDidLoad()
        layout()
        
        toAligmentLayoutButton.addTarget(self, action: #selector(toAligment), for: .touchUpInside)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(CarouselCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        collectionView.scrollToItem(at: IndexPath(item: self.numberOfItems/2, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    // MARK: - Layout
    
    private func layout() {
        [collectionView, toAligmentLayoutButton].forEach {
            view.addSubview($0)
        }
       
        collectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            $0.bottom.equalTo(toAligmentLayoutButton.snp.top)
        }
        
        toAligmentLayoutButton.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom).offset(20)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    @objc private func toAligment() {
        present(CellAligmentViewController(), animated: true)
    }
}

// MARK: - DataSource

extension CarouselViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: self.reuseIdentifier,
            for: indexPath) as! CarouselCollectionViewCell
        cell.numberLabel.text = items[indexPath.row % items.count].title
        cell.backgroundColor = items[indexPath.row % items.count].color
        
        return cell
    }
}

// MARK: - Delegate

extension CarouselViewController: UICollectionViewDelegateFlowLayout {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        
        let roundedIndex = round(index)
        
        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: scrollView.contentInset.top)
        
        targetContentOffset.pointee = offset
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView is UICollectionView else {return}
        
        let centerPoint = CGPoint(x: self.collectionView.frame.size.width / 2 + scrollView.contentOffset.x,
                                  y: self.collectionView.frame.size.height / 2 + scrollView.contentOffset.y)
        if let indexPath = self.collectionView.indexPathForItem(at: centerPoint) {
            self.centerCell = (self.collectionView.cellForItem(at: indexPath) as? CarouselCollectionViewCell)
            self.centerCell?.transformToLarge()
        }
        
        if let cell = self.centerCell {
            let offsetX = centerPoint.x - cell.center.x
            if offsetX < -40 || offsetX > 40 {
                cell.transformToStandard()
                self.centerCell = nil
            }
        }
    }
}


 class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)

        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }

            layoutAttribute.frame.origin.x = leftMargin

            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY , maxY)
        }

        return attributes
    }
}

