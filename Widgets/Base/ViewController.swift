//
//  ViewController.swift
//  Widgets
//
//  Created by Mohamed anwar on 24/08/2023.
//

import UIKit
import Combine

class ViewController: UIViewController {

    var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        bindViewModel()
    }
    
    func setupSubviews() {

    }

    func bindViewModel() {
        
    }
    
    func observeViewState(from publisher: Published<ViewState?>.Publisher) {
        publisher
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] viewState in
                guard let self else { return }
                switch viewState {
                case .loading(let isUserInteractionEnabled):
                    print("Loading and isUserInteractionEnabled = \(isUserInteractionEnabled)")
                    
                case .error(let message):
                    print("error:- \(message)")

                    
                case .idle:
                    print("Loaded")
                }
            }
            .store(in: &cancellables)
    }

}
