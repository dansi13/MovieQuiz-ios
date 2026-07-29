//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Daniil Sivachenko on 28.07.2026.
//

import UIKit

protocol StatisticServiceProtocol {
    var gamesCount: Int { get }
    var bestGame: GameResult { get }
    var totalAccuracy: Double { get }
    
    func store(correct count: Int, total amount: Int)
}
