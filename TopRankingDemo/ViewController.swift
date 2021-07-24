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

  lazy private var startIndexInput: UITextField = {
    let view = UITextField()
    view.borderStyle = .roundedRect
    view.textAlignment = .center
    view.keyboardType = .numberPad
    view.placeholder = "Start"
    return view
  }()

  lazy private var toLabel: UILabel = {
    let label = UILabel()
    label.text = "to"
    label.font = UIFont.boldSystemFont(ofSize: 20)
    label.textAlignment = .center
    return label
  }()

  lazy private var endIndexInput: UITextField = {
    let view = UITextField()
    view.borderStyle = .roundedRect
    view.textAlignment = .center
    view.keyboardType = .numberPad
    view.placeholder = "End"
    return view
  }()

  lazy private var switchButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Change", for: .normal)
    button.backgroundColor = .systemOrange
    button.setTitleColor(.white, for: .normal)
    button.layer.cornerRadius = 5
    button.addTarget(self, action: #selector(switchButtonDidPressed), for: .touchUpInside)
    return button
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupUserInterface()
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    view.endEditing(true)
  }

  // MARK: - Private Methods

  private func setupUserInterface() {
    view.addSubviews([rankingView, startIndexInput, toLabel, endIndexInput, switchButton])
    view.backgroundColor = .white

    setupLayout()
  }

  private func setupLayout() {
    rankingView.snp.makeConstraints {
      $0.topMargin.equalTo(self.view.snp.topMargin).offset(10)
      $0.right.equalTo(self.view.snp.right).offset(-10)
    }

    startIndexInput.snp.makeConstraints {
      $0.left.equalTo(self.view.snp.left).offset(20)
      $0.topMargin.equalTo(self.view.snp.topMargin).offset(30)
      $0.width.equalTo(80)
      $0.height.equalTo(40)
    }

    toLabel.snp.makeConstraints {
      $0.left.equalTo(startIndexInput.snp.left)
      $0.width.equalTo(startIndexInput.snp.width)
      $0.top.equalTo(startIndexInput.snp.bottom)
      $0.height.equalTo(30)
    }

    endIndexInput.snp.makeConstraints {
      $0.left.equalTo(startIndexInput.snp.left)
      $0.top.equalTo(toLabel.snp.bottom)
      $0.height.equalTo(startIndexInput.snp.height)
      $0.width.equalTo(startIndexInput.snp.width)
    }

    switchButton.snp.makeConstraints {
      $0.left.equalTo(startIndexInput.snp.left)
      $0.top.equalTo(endIndexInput.snp.bottom).offset(20)
      $0.width.equalTo(startIndexInput.snp.width)
      $0.height.equalTo(40)
    }
  }

  // MARK: - Action Methods

  @objc private func switchButtonDidPressed() {
    view.endEditing(true)
    guard let startValue = startIndexInput.text, let endValue = endIndexInput.text, let startIndex = Int(startValue), let endIndex = Int(endValue), startIndex > endIndex else {
      return
    }

    startIndexInput.text = ""
    endIndexInput.text = ""

    rankingView.moveCell(with: startIndex, to: endIndex)
  }
}

extension UIView {
  func addSubviews(_ views: [UIView]) {
    views.forEach { addSubview($0) }
  }
}

