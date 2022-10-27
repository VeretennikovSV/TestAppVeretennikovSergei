//
//  SceneDelegate.swift
//  TestAppVeretennikovSergei
//
//  Created by Сергей Веретенников on 25/10/2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        let configurator: ViewConfiguratorProtocol = ViewConfigurator()
        
        
        window.rootViewController = configurator.configureControllerWith(viewModel: RegistrationControllerViewModel())
        self.window = window
        window.makeKeyAndVisible()
    }

}

protocol ViewConfiguratorProtocol {
    func configureControllerWith(viewModel: RegistrationControllerViewModelProtocol) -> RegistrationViewController
}

final class ViewConfigurator: ViewConfiguratorProtocol {
    func configureControllerWith(viewModel: RegistrationControllerViewModelProtocol) -> RegistrationViewController {
        RegistrationViewController(viewModel: viewModel)
    }
}
