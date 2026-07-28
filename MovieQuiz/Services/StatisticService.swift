//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Daniil Sivachenko on 28.07.2026.
//

import Foundation

final class StatisticService: StatisticServiceProtocol {
    private let storage: UserDefaults = .standard
    
    private enum Keys: String {
        case gamesCount          // Для счётчика сыгранных игр
        case bestGameCorrect     // Для количества правильных ответов в лучшей игре
        case bestGameTotal       // Для общего количества вопросов в лучшей игре
        case bestGameDate        // Для даты лучшей игры
        case totalCorrectAnswers // Для общего количества правильных ответов за все игры
        case totalQuestionsAsked // Для общего количества вопросов, заданных за все игры
    }
    
    var gamesCount: Int {
        get {
            storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameResult {
        GameResult(
            correct: storage.integer(forKey: Keys.bestGameCorrect.rawValue),
            total: storage.integer(forKey: Keys.bestGameTotal.rawValue),
            date: storage.object(forKey: Keys.bestGameDate.rawValue) as? Date ?? Date()
        )
    }
    
    var totalAccuracy: Double {
        let correct = storage.integer(forKey: Keys.totalCorrectAnswers.rawValue)
        let total = storage.integer(forKey: Keys.totalQuestionsAsked.rawValue)
        return Double(correct) / Double(total)
    }
    
    func store(correct count: Int, total amount: Int) {
        let bestCorrect = storage.integer(forKey: Keys.bestGameCorrect.rawValue)
        // лучший счет,общий счет, игры
        gamesCount += 1
        storage.set(storage.integer(forKey: Keys.totalQuestionsAsked.rawValue) + amount, forKey: Keys.totalQuestionsAsked.rawValue)
        storage.set(storage.integer(forKey: Keys.totalCorrectAnswers.rawValue) + count, forKey: Keys.totalCorrectAnswers.rawValue)
        
        if count > bestCorrect {
            storage.set(amount, forKey: Keys.bestGameTotal.rawValue)
            storage.set(count, forKey: Keys.bestGameCorrect.rawValue)
            storage.set(Date(), forKey: Keys.bestGameDate.rawValue)
        }
    }
}
