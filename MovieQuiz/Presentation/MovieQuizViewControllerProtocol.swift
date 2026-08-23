//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Daniil Sivachenko on 23.08.2026.
//

import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    func show(quiz result: QuizResultsViewModel)

    func highlightImageBorder(isCorrectAnswer: Bool)
    func clearImageBorder()

    func showLoadingIndicator()
    func hideLoadingIndicator()

    func showNetworkError(message: String)
}
