//
//  ViewController.swift
//  TopRankingDemo
//
//  Created by Min on 2021/7/24.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

  lazy private var rankingView: TopRankingView = {
    return TopRankingView()
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupUserInterface()
  }

  // MARK: - Private Methods

  private func setupUserInterface() {
    view.addSubview(rankingView)
    view.backgroundColor = .white

    rankingView.snp.makeConstraints {
      $0.topMargin.equalTo(self.view.snp.topMargin).offset(10)
      $0.right.equalTo(self.view.snp.right).offset(-10)
    }
  }
}

extension UIView {
  func addSubviews(_ views: [UIView]) {
    views.forEach { addSubview($0) }
  }
}

