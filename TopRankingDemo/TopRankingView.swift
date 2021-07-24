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

  lazy var ranfingResultCollectionView: UICollectionView = {
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

  private var numberList = Array(1...10)

  init() {
    super.init(frame: .zero)
    setupUserInterface()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - test Move cell

  private func findCell(with index: Int) -> UICollectionViewCell {
    guard let cell = ranfingResultCollectionView.cellForItem(at: IndexPath(item: index, section: 0)) else {
      fatalError("Not get cell")
    }
    return cell
  }

  private func findCells(with startIndex: Int, and endIndex: Int) -> [UICollectionViewCell] {
    let range = startIndex - endIndex
    let endRange = endIndex + range
    return Array(endIndex...endRange).map {
      let cell = findCell(with: $0)
      print("index: \($0), with cell frame: \(cell.frame)")
      return cell
    }
  }

  func moveCell(with startIndex: Int, to endIndex: Int) {
    let startValue = numberList[startIndex]
    let startCell = findCell(with: startIndex)
    let endCells = findCells(with: startIndex, and: endIndex)

    let animation = UIViewPropertyAnimator(duration: 1, curve: .easeOut) {
      startCell.layer.zPosition = 100
    }

    animation.addAnimations {
      let space: CGFloat = startCell.frame.height + 10
      endCells.forEach { $0.frame.origin.y += space }
      startCell.frame.origin.y -= (space * CGFloat(endCells.count))
    }

    animation.addCompletion { [weak self] _ in
      self?.numberList.remove(at: startIndex)
      self?.numberList.insert(startValue, at: endIndex)
      self?.ranfingResultCollectionView.reloadData()
    }

    animation.startAnimation()
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
      $0.height.equalTo(TopRankingTelescopicType.elongation.height)
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
    return .init(width: widthAndHeight, height: 40)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return .init(top: 10, left: 0, bottom: 10, right: 0)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 10
  }

  func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
    return true
  }
}

// MARK: - UICollectionViewDataSource

extension TopRankingView: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return numberList.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DemoCell.identifier, for: indexPath) as? DemoCell else {
      fatalError("Cell init fail")
    }

    cell.title = "\(numberList[indexPath.item])"
    return cell
  }
}
