//
//  GameResult.swift
//  MovieQuiz
//
//  Created by Daniil Sivachenko on 28.07.2026.
//

import UIKit

struct GameResult {
    let correct: Int
    let total: Int
    let date: Date
    
    func isBetterThan(_ another: GameResult) -> Bool {
        correct > another.correct
    }
}
