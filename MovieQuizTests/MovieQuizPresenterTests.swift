//
//  MovieQuizPresenterTests.swift
//  MovieQuizTests
//
//  Created by Daniil Sivachenko on 23.08.2026.
//

import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    var lastStepModel: QuizStepViewModel?
    
    func show(quiz step: QuizStepViewModel) {
        lastStepModel = step
    }
    
    func show(quiz result: QuizResultsViewModel) {
        
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        
    }
    
    func clearImageBorder() {
        
    }
    
    func showLoadingIndicator() {
        
    }
    
    func hideLoadingIndicator() {
        
    }
    
    func showNetworkError(message: String) {
        
    }
}

final class MovieQuizPresenterTests: XCTestCase {
    func testPresenterConvertModel() throws {
        // Given
        let viewControllerMock = MovieQuizViewControllerMock()
        
        let statisticService = StatisticService()
        
        let questionFactoryCreator: (QuestionFactoryDelegate) -> QuestionFactoryProtocol = { delegate in
            QuestionFactory(
                moviesLoader: MoviesLoader(),
                delegate: delegate
            )
        }
        
        let sut = MovieQuizPresenter(
            viewController: viewControllerMock,
            statisticService: statisticService,
            questionFactoryCreator: questionFactoryCreator
        )
        
        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true)
        
        // When
        let viewModel = sut.convert(model: question)
        
        // Then
        XCTAssertEqual(viewModel.image, emptyData)
        XCTAssertEqual(viewModel.question, "Question Text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
}
