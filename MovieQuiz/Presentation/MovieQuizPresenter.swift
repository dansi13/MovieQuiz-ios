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

final class MovieQuizPresenter {
    let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func resetQuestionIndex() {
         currentQuestionIndex = 0
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
}
