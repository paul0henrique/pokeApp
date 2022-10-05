//
//  ViewController.swift
//  pokeApp
//
//  Created by Paulo Henrique on 22/09/22.
//

import UIKit

class ViewController: UIViewController {
    
    private let pokemonNameLabel: UILabel = {
        let pokemonNameLabel = UILabel()
        pokemonNameLabel.translatesAutoresizingMaskIntoConstraints = false
        pokemonNameLabel.textAlignment = .center
        pokemonNameLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        pokemonNameLabel.numberOfLines = 0
        return pokemonNameLabel
    }()
    
    private let pokemonImageView: UIImageView = {
        let pokemonImageView = UIImageView()
        pokemonImageView.translatesAutoresizingMaskIntoConstraints = false
        pokemonImageView.contentMode = .scaleAspectFill
        
        return pokemonImageView
        
    }()
    
    private let pokemonIDLabel: UILabel = {
        let pokemonIDLabel = UILabel()
        pokemonIDLabel.translatesAutoresizingMaskIntoConstraints = false
        pokemonIDLabel.textAlignment = .center
        pokemonIDLabel.font = UIFont.systemFont(ofSize: 16)
        pokemonIDLabel.textAlignment = .right
        return pokemonIDLabel
    }()
    
    private lazy var stepper: UIStepper = {
        let stepper = UIStepper()
        stepper.translatesAutoresizingMaskIntoConstraints = false
        stepper.addTarget(self, action: #selector(stepperValueChange(_:)), for: .touchUpInside)
        
        return stepper
    }()
    
    private var pokemonID = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        stepper.value = 1
        stepper.minimumValue = 1
        stepper.maximumValue = 898
        pokemonIDLabel.text = "Pokemon ID: \(pokemonID)"
        
        pokemonID = Int(stepper.value)
        
        viewHierarchy()
        setupConstraints()
        makeRequest()
    }
    
    func viewHierarchy(){
        view.addSubview(pokemonNameLabel)
        view.addSubview(pokemonImageView)
        view.addSubview(stepper)
        view.addSubview(pokemonIDLabel)
    }
    
    @objc func stepperValueChange(_ sender: UIStepper) {
        pokemonID = Int(sender.value)
        pokemonIDLabel.text = "Pokemon ID: \(pokemonID)"
        makeRequest()
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            pokemonNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            pokemonNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            pokemonNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            
            pokemonImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pokemonImageView.topAnchor.constraint(equalTo: pokemonNameLabel.bottomAnchor, constant: 30),
            pokemonImageView.widthAnchor.constraint(equalToConstant: 250),
            pokemonImageView.heightAnchor.constraint(equalToConstant: 220),

            
            stepper.leadingAnchor.constraint(equalTo: pokemonImageView.leadingAnchor),
            
            stepper.topAnchor.constraint(equalTo: pokemonImageView.bottomAnchor, constant: 30),
            
            
            pokemonIDLabel.centerYAnchor.constraint(equalTo: stepper.centerYAnchor),
            
            pokemonIDLabel.leadingAnchor.constraint(equalTo: stepper.leadingAnchor, constant: 16),
            
            pokemonIDLabel.trailingAnchor.constraint(equalTo: pokemonImageView.trailingAnchor)
            
        ])
        
    }
    
    func makeRequest(){
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(pokemonID)") else {
            // deu errado = string invalida
            print("error - string informada inválida")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if error != nil {
                print("Requisição executada, mas tivemos como retorno um erro.")
                return
            }
            
            guard let data = data else {
                print("Erro - Data inválido")
                return
            }
            
            
            if let result = try? JSONDecoder().decode(Pokemon.self, from: data) {
                DispatchQueue.main.async {
                    self.pokemonNameLabel.text = result.name.uppercased()
                    self.requestImage(result: result)
                    
                }
                return
            } else {
                print("não foi possível converter o data em objeto Pokemon")
                return
            }
        }.resume()
        
    }
    
    func requestImage(result: Pokemon){
        guard let url = URL(string: result.sprites.other.official.urlImage) else { return }
        URLSession.shared.dataTask(with: URLRequest(url: url)) {data, _, _ in
            guard let data else { return }
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                self.pokemonImageView.image = image
            }
        }.resume()
        
    }
    
}
