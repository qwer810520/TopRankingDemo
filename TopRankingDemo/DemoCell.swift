//
//  DemoCell.swift
//  TopRankingDemo
//
//  Created by Min on 2021/7/24.
//

import UIKit
import SnapKit

class DemoCell: UICollectionViewCell {

  lazy private var testLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.boldSystemFont(ofSize: 30)
    label.textAlignment = .center
    return label
  }()

  var title: String {
    get { testLabel.text ?? "" }
    set(newValue) { testLabel.text = newValue }
  }

  // MARK: - Initialization

  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.backgroundColor = .systemGreen
    setupUserInterface()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Private Methods

  private func setupUserInterface() {
    contentView.addSubview(testLabel)

    contentView.layer.borderWidth = 0.5
    contentView.layer.borderColor = UIColor.systemRed.cgColor

    setupLauout()
  }

  private func setupLauout() {
    testLabel.snp.makeConstraints {
      $0.left.top.right.bottom.equalToSuperview()
    }
  }
}

extension UICollectionReusableView {
  static var identifier: String {
    return String(describing: self)
  }
}
