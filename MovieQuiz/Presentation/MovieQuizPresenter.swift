//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Daniil Sivachenko on 23.08.2026.
//

import Foundation

struct QuizStepViewModel {
    let image: Data
    let question: String
    let questionNumber: String
}

final class MovieQuizPresenter: QuestionFactoryDelegate {
    
    // MARK: - Properties
    
    let questionsAmount: Int = 10
    
    private var currentQuestionIndex: Int = 0
    private var currentQuestion: QuizQuestion?
    private weak var viewController: MovieQuizViewControllerProtocol?
    
    var correctAnswers: Int = 0
    private var questionFactory: QuestionFactoryProtocol?
    
    private let statisticService: StatisticServiceProtocol
    
    // MARK: - Public Methods
    
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
    
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        
        let givenAnswer = isYes
        
        proceedWithAnswer(
            isCorrect: givenAnswer == currentQuestion.correctAnswer
        )
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        self.currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        viewController?.showNetworkError(
            message: error.localizedDescription
        )
    }
    
    func proceedToNextQuestionOrResults() {
        if self.isLastQuestion() {
            let text = makeResultsMessage()
            
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз")
            viewController?.show(quiz: viewModel)
        } else {
            self.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    
    func proceedWithAnswer(isCorrect: Bool) {
        didAnswer(isCorrectAnswer: isCorrect)

        viewController?.highlightImageBorder(
            isCorrectAnswer: isCorrect
        )

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self else { return }

            self.viewController?.clearImageBorder()
            self.proceedToNextQuestionOrResults()
        }
    }
    
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }
    
    func didAnswer(isCorrectAnswer: Bool) {
        if isCorrectAnswer {
            correctAnswers += 1
        }
    }
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: model.image,
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
    }
    
    func makeResultsMessage() -> String {
        statisticService.store(
            correct: correctAnswers,
            total: questionsAmount
        )
        
        let bestGame = statisticService.bestGame
        
        let currentGameResultLine =
        "Ваш результат: \(correctAnswers)/\(questionsAmount)"
        
        let totalPlaysCountLine =
        "Количество сыгранных квизов: \(statisticService.gamesCount)"
        
        let bestGameInfoLine =
        "Рекорд: \(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString))"
        
        let averageAccuracyLine =
        "Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy * 100))%"
        
        return [
            currentGameResultLine,
            totalPlaysCountLine,
            bestGameInfoLine,
            averageAccuracyLine
        ].joined(separator: "\n")
    }
    
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
        self.statisticService = StatisticService()
        
        questionFactory = QuestionFactory(
            moviesLoader: MoviesLoader(),
            delegate: self
        )
        
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
    }
}
