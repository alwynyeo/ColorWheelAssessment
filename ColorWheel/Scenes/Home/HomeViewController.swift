//
//  HomeViewController.swift
//  ColorWheel
//
//  Created by Alwyn Yeo on 8/15/24.
//

import UIKit

final class HomeViewController: UIViewController {

    // MARK: - Declarations

    var viewModel: HomeBusinessLogic!

    // MARK: - Object Lifecycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }

    deinit {
        print("Deinit HomeViewController")
    }

    // MARK: - View Lifecycle

    override func loadView() {
        super.loadView()
        setupUI()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Override Parent Methods

    // MARK: - Setup

    private func setup() {
        let view = self
        let viewModel = HomeViewModel(view: view)
        view.viewModel = viewModel
    }

    // MARK: - Helpers
}

// MARK: - HomeDisplayLogic Extension
extension HomeViewController: HomeDisplayLogic {}

// MARK: - Programmatic UI Setup
private extension HomeViewController {
    func setupUI() {
        view.backgroundColor = Color.background
    }
}
