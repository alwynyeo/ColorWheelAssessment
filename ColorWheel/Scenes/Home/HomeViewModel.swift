//
//  HomeViewModel.swift
//  ColorWheel
//
//  Created by Alwyn Yeo on 8/15/24.
//

final class HomeViewModel {

    // MARK: - Declarations

    weak var view: HomeDisplayLogic?

    // MARK: - Object Lifecycle

    init(view: HomeDisplayLogic) {
        self.view = view
    }

    // MARK: - Helpers
}

// MARK: - HomeBusinessLogic Extension
extension HomeViewModel: HomeBusinessLogic {}
