//
//  AssemblyWeatherSiri.swift
//  WeatherSiri
//
//  Created by Artem Serebriakov on 21.08.2022.
//

import UIKit

protocol IWeatherSiri {
    func assemble() -> UIViewController
}

final class AssemblyWeatherSiri: IWeatherSiri {
    func assemble() -> UIViewController {
        let viewController = ViewController()
        return viewController
    }
}
