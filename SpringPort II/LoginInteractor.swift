//
//  LoginInteractor.swift
//  TASClient
//
//  Created by Keenan Hauber on 17/7/18.
//  Copyright © 2018 Keenan Hauber. All rights reserved.
//

import Foundation

protocol LoginListening: class {
    func connectedSuccessfully()
    func loginAccepted()
    func loginDenied(_ error: String)
}

protocol LoginInteracting: class {
    func sendLoginRequest(for username: String, and password: String)
    func requestNewAccount()
}

final class LoginInteractor: LoginInteracting {
    let router: LoginRouting = LoginRouter()
    let presenter: LoginPresenting
    let server: TASServer
    
    var username: String?
    var password: String?
    
    init(presenter: LoginPresenting, server: TASServer) {
        self.presenter = presenter
        self.server = server
    }
    
    func sendLoginRequest(for username: String, and password: String) {
        presenter.freezeDisplay()
        server.connect() // Don't want to send this here, but oh well
    }
    
    func requestNewAccount() {
//        router.routeToRegister()
    }
}

extension LoginInteractor: LoginListening {
    func loginAccepted() {
        router.routeToNext()
    }
    func loginDenied(_ error: String) {
        presenter.resetForNewLoginAttempt(error)
    }
    func connectedSuccessfully() {
        guard let username = username, let password = password else {fatalError("No username or password on connection attempt")}
        server.send(LoginCommand(username: username, password: password))
    }
}
