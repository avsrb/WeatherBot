//
//  AssemblyWeatherSiri.swift
//  WeatherSiri
//
//  Created by Artem Serebriakov on 21.08.2022.
//

import UIKit
import JSQMessagesViewController

protocol IWeatherSiri {
    func assemble() -> JSQMessagesViewController
}

final class AssemblyWeatherSiri: IWeatherSiri {
    func assemble() -> JSQMessagesViewController {
        let viewController = MessagesViewController()
        return viewController
    }
}
