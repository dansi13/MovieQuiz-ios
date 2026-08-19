//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Daniil Sivachenko on 28.07.2026.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
}
