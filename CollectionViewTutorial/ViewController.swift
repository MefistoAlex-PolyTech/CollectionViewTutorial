//
//  ViewController.swift
//  CollectionViewTutorial
//
//  Created by Alexandr Mefisto on 19.04.2023.
//

import UIKit
import SnapKit


class ViewController: UIViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, String>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, String>

    // MARK: - Properties
    
    private var sections = Section.allSections

    let reuseIdentifier = "CollectionViewCell"
    
    let searchBar = UISearchBar()
    
    let collectionView = {
        
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let isPhone = layoutEnvironment.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiom.phone
            let size = NSCollectionLayoutSize(
                widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
                heightDimension: NSCollectionLayoutDimension.absolute(110)
            )
            let itemCount = 3
            let item = NSCollectionLayoutItem(layoutSize: size)
            item.contentInsets =  NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 10, trailing: 5)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: itemCount)
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            section.interGroupSpacing = 10
            
            // Supplementary header view setup
            let headerFooterSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(20)
            )
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerFooterSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            section.boundarySupplementaryItems = [sectionHeader]
            return section
        })
        
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        
        return collection
    }()
    
    private lazy var dataSource = makeDataSource()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(
            SectionHeaderReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionHeaderReusableView.reuseIdentifier
        )
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        searchBar.delegate = self
        applySnapshot(search: "", animatingDifferences: false)
        layout()
    }

    // MARK: - Diffable Data Source
    
    private func makeDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, country) ->
                UICollectionViewCell? in
                
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: self.reuseIdentifier,
                    for: indexPath) as? CollectionViewCell
                cell?.configure(country: country)
                return cell
            })
    
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else {
                return nil
            }
            let view = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SectionHeaderReusableView.reuseIdentifier,
                for: indexPath) as? SectionHeaderReusableView
            let section = self.dataSource.snapshot()
                .sectionIdentifiers[indexPath.section]
            view?.titleLabel.text = section.title
            return view
        }
        return dataSource
    }
    
    private func applySnapshot(search: String ,animatingDifferences: Bool = true) {
        
         var snapshot = Snapshot()
        
        if search == "" {
            snapshot.appendSections(sections)
            sections.forEach { section in
                snapshot.appendItems(section.countries, toSection: section)
            }
        } else {
            let filteredSections = sections.filter {
                $0.countries.filter {
                    $0.lowercased().contains(search.lowercased())
                }.isEmpty == false
            }
            snapshot.appendSections(filteredSections)
            filteredSections.forEach { section in
                snapshot.appendItems(section.countries.filter {  $0.lowercased().contains(search.lowercased()) }, toSection: section)
            }
            
        }
        
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    // MARK: - Layout
    
    private func layout() {
        collectionView.backgroundColor = .white
        [collectionView, searchBar].forEach { view.addSubview($0) }
        
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
        }
    }
}

// MARK: - Delegates

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        applySnapshot(search: searchText, animatingDifferences: true)
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        true
    }
    
}
