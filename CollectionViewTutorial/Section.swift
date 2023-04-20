//
//  Section.swift
//  CollectionViewTutorial
//
//  Created by Alexandr Mefisto on 20.04.2023.
//

import UIKit

class Section: Hashable {
  var id = UUID()

  var title: String
  var countries: [String]
  
  init(title: String, countries: [String]) {
    self.title = title
    self.countries = countries
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
  
  static func == (lhs: Section, rhs: Section) -> Bool {
    lhs.id == rhs.id
  }
}

extension Section {
  static var allSections: [Section] = [
    Section(title: "Europe", countries: ["Great Britan", "France", "Italy", "Germany"]),
    Section(title: "America", countries: ["USA", "Canada", "Mexica"]),
    Section(title: "Africa", countries: ["SAR", "Congo", "Egypt"])]
}
