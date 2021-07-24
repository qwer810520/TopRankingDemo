//
//  TopRankingView.swift
//  TopRankingDemo
//
//  Created by Min on 2021/7/24.
//

import UIKit
import SnapKit

enum TopRankingTelescopicType {
  case elongation ,shorten
}

extension TopRankingTelescopicType {
  var height: CGFloat {
    switch self {
      case .elongation: return 700
      case .shorten: return 150
    }
  }

  var buttonTitle: String {
    switch self {
      case .elongation: return "Up"
      case .shorten: return "Down"
    }
  }
}

class TopRankingView: UIView {

  private var isElongation = false {
    didSet {
      switch isElongation {
        case true:
          telescopicView(with: .elongation)
        case false:
          telescopicView(with: .shorten)
      }
    }
  }

  lazy private var topImageView: UIImageView = {
    let view = UIImageView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .systemPink
    return view
  }()

  lazy private var countdownTimerLabel: UILabel = {
    let view = UILabel()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.textAlignment = .center
    view.backgroundColor = .orange
    view.font = UIFont.systemFont(ofSize: 15)
    view.text = "⚡️ 02:10 ⚡️" // TODO
    return view
  }()

  lazy private var headerImageView: UIImageView = {
    let view = UIImageView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .cyan
    return view
  }()

  lazy private var ranfingResultCollectionView: UICollectionView = {
    let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    view.translatesAutoresizingMaskIntoConstraints = false
    view.dataSource = self
    view.delegate = self
    view.backgroundColor = .blue
    view.register(DemoCell.self, forCellWithReuseIdentifier: DemoCell.identifier)
    return view
  }()

  lazy private var telescopicSwitchButton: UIButton = {
    let button = UIButton(type: .system)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.backgroundColor = .systemYellow
    button.setTitleColor(.white, for: .normal)
    button.setTitle("Down", for: .normal)
    button.addTarget(self, action: #selector(telescopicSwitchButtonDidPressed), for: .touchUpInside)
    return button
  }()

  // MARK: - Initialization

  init() {
    super.init(frame: .zero)
    setupUserInterface()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Private Methods

  private func setupUserInterface() {
    translatesAutoresizingMaskIntoConstraints = false
    backgroundColor = .lightGray
    addSubviews([topImageView, countdownTimerLabel, headerImageView, ranfingResultCollectionView, telescopicSwitchButton])
    setupLayout()
  }

  private func setupLayout() {
    snp.makeConstraints {
      $0.width.equalTo(130)
      $0.height.equalTo(TopRankingTelescopicType.shorten.height)
    }

    topImageView.snp.makeConstraints {
      $0.left.topMargin.width.equalToSuperview()
      $0.height.equalTo(65)
    }

    countdownTimerLabel.snp.makeConstraints {
      $0.left.width.equalToSuperview()
      $0.top.equalTo(topImageView.snp.bottom)
      $0.height.equalTo(55)
    }

    headerImageView.snp.makeConstraints {
      $0.left.width.equalToSuperview()
      $0.top.equalTo(countdownTimerLabel.snp.bottom)
      $0.height.lessThanOrEqualTo(50)
    }

    ranfingResultCollectionView.snp.makeConstraints {
      $0.width.left.equalToSuperview()
      $0.top.equalTo(headerImageView.snp.bottom)
      $0.bottom.equalTo(telescopicSwitchButton.snp.top)
    }

    telescopicSwitchButton.snp.makeConstraints {
      $0.left.bottom.width.equalToSuperview()
      $0.height.equalTo(30)
    }
  }

  private func telescopicView(with type: TopRankingTelescopicType) {
    snp.updateConstraints {
      $0.height.equalTo(type.height)
    }

    UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.2, delay: 0) { [weak self] in
      self?.superview?.layoutIfNeeded()

      self?.telescopicSwitchButton.setTitle(type.buttonTitle, for: .normal)
    } completion: { _ in }
  }

  // MARK: - Action Methods

  @objc private func telescopicSwitchButtonDidPressed() {
    isElongation = !isElongation
  }
}

  // MARK: - UICollectionViewDelegate

extension TopRankingView: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let widthAndHeight = collectionView.frame.width - 10
    return .init(width: widthAndHeight, height: widthAndHeight)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return .init(top: 10, left: 0, bottom: 10, right: 0)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 10
  }
}

// MARK: - UICollectionViewDataSource

extension TopRankingView: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 10
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DemoCell.identifier, for: indexPath) as? DemoCell else {
      fatalError("Cell init fail")
    }
    return cell
  }
}
