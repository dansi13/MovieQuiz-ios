//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Daniil Sivachenko on 28.07.2026.
//

import Foundation

struct AlertModel {
    var title: String
    var message: String
    var buttonText: String
    var completion: () -> Void
    var accessibilityIdentifier: String
}
