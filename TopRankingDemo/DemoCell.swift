//
//  DemoCell.swift
//  TopRankingDemo
//
//  Created by Min on 2021/7/24.
//

import UIKit

class DemoCell: UICollectionViewCell {

  // MARK: - Initialization

  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.backgroundColor = .systemGreen
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension UICollectionReusableView {
  static var identifier: String {
    return String(describing: self)
  }
}
