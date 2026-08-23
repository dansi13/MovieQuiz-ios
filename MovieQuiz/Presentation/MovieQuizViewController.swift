import UIKit

final class MovieQuizViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Constants
    
    private enum Constants {
        static let errorTitle = "Ошибка"
        static let retryButtonText = "Попробовать еще раз"
    }
    
    // MARK: - Properties
    
    private var presenter: MovieQuizPresenter!
    
    private var alertPresenter = AlertPresenter()
    
    private var statisticService: StatisticServiceProtocol = StatisticService()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        
        presenter = MovieQuizPresenter(viewController: self)
    }
    
    // MARK: - IBActions
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    
    // MARK: - Private Methods
    
    private func setButtonsEnabled(_ isEnabled: Bool) {
        yesButton.isEnabled = isEnabled
        noButton.isEnabled = isEnabled
    }
    
    func showAnswerResult(isCorrect: Bool) {
        presenter.didAnswer(isCorrectAnswer: isCorrect)
        
        setButtonsEnabled(false)
        
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor =
        isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self else { return }
            
            self.presenter.showNextQuestionOrResults()
            
            self.imageView.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    func show(quiz step: QuizStepViewModel) {
        setButtonsEnabled(true)
        imageView.image = UIImage(data: step.image) ?? UIImage()
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let model = AlertModel(
            title: Constants.errorTitle,
            message: message,
            buttonText: Constants.retryButtonText,
            completion: { [weak self] in
                guard let self else { return }
                
                self.presenter.restartGame()
            },
            accessibilityIdentifier: "Network Error"
        )
        
        alertPresenter.show(in: self, model: model)
    }
    
    func show(quiz result: QuizResultsViewModel) {
        statisticService.store(
            correct: presenter.correctAnswers,
            total: presenter.questionsAmount
        )
        
        let model = AlertModel(
            title: result.title,
            message: result.text,
            buttonText: result.buttonText,
            completion: { [weak self] in
                guard let self else { return }
                
                self.presenter.restartGame()
            },
            accessibilityIdentifier: "Game results"
        )
        
        alertPresenter.show(in: self, model: model)
    }
}
