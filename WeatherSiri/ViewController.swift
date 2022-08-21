//
//  ViewController.swift
//  WeatherSiri
//
//  Created by Artem Serebriakov on 20.08.2022.
//

import UIKit
import ForecastIO
import RecastAI
import CoreLocation

class ViewController: UIViewController
{
    var recastAIBot: RecastAIClient?
    var darkSkyBot: DarkSkyClient?
    
    private lazy var inputTextField : UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "City"
        textField.textAlignment = .center
        textField.autocorrectionType = .no
        textField.keyboardType = .default
        textField.returnKeyType = .done
        textField.font = .systemFont(ofSize: UIScreen.main.bounds.height / 20)
        return textField
    }()
    
    private lazy var requestButton : UIButton = {
        let button = UIButton()
        button.setTitle("Request", for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(makeRequest), for: .touchUpInside)
        return button
    }()
    
    private lazy var responseLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemBlue
        label.textAlignment = .center
        label.font = .systemFont(ofSize: UIScreen.main.bounds.height / 15)
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()

    override func viewDidLoad()
{
        super.viewDidLoad()
        
        setupUI()
        setConstrains()
        
        self.recastAIBot = RecastAIClient(token: RECASTAI_TOKEN, language: "en")
        self.darkSkyBot = DarkSkyClient(apiKey: DARK_SKY_TOKEN)
        self.darkSkyBot?.language = .english
    }
    
    func setSuccessResponse(_ response: Response) {
        guard let location = response.get(entity: "location") else { self.responseLabel.text = "Error"; return }
        
        guard let lat = location["lat"] as? CLLocationDegrees, let lng = location["lng"] as? CLLocationDegrees else { return }
        
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        
        self.darkSkyBot?.getForecast(location: coordinate, completion: { result in
            switch result {
            case .success((let forecast, _)):
                DispatchQueue.main.async {
                    guard var temperature = forecast.currently?.temperature else { return }
                    temperature = (temperature - 32) * 5/9
                    if let temperature = Int(temperature) as? Int {
                        self.responseLabel.text = String(temperature) + "°C"
                    }
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.responseLabel.text = "Error"
                }
            }
        })
    }

    func setFailureResponse(_ error: Error) {
        self.responseLabel.text = "Error"
        //print for test
        print("error = \(error.localizedDescription)")
    }
    
    @objc func makeRequest(_ sender: UIButton) {
        if let text = self.inputTextField.text, !text.isEmpty {
            self.responseLabel.text = "waiting..."
            self.recastAIBot?.textRequest(text, successHandler: setSuccessResponse, failureHandle: setFailureResponse)
        }
    }
    
    func setupUI() {
        view.backgroundColor = .systemBackground
        
        stackView.addArrangedSubview(inputTextField)
        stackView.addArrangedSubview(requestButton)
        stackView.addArrangedSubview(responseLabel)
        view.addSubview(stackView)
    }
    
    func setConstrains() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            stackView.bottomAnchor.constraint(lessThanOrEqualToSystemSpacingBelow: view.safeAreaLayoutGuide.bottomAnchor, multiplier: 2),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
        ])
    }
}
