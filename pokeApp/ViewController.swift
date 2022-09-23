//
//  ViewController.swift
//  pokeApp
//
//  Created by Paulo Henrique on 22/09/22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var pokemonNameLabel: UILabel!
    @IBOutlet weak var pokemonImageView: UIImageView!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var pokemonIDLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pokemonNameLabel.text = "POKENAME"
        pokemonImageView.backgroundColor = .lightGray
        pokemonIDLabel.text = "Pokemon ID: 5"
    }

    @IBAction func stepperValueChange(_ sender: Any) {
        print("stepper button tapped")
    }
    
}

