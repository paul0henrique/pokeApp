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
    
    private var pokemonID = 7
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stepper.value = 1
        stepper.minimumValue = 1
        stepper.maximumValue = 898
        
        pokemonID = Int(stepper.value)
        
        makeRequest()
    }
    
    @IBAction func stepperValueChange(_ sender: UIStepper) {
        pokemonID = Int(sender.value)
        pokemonIDLabel.text = "Pokemon ID: \(pokemonID)"
        makeRequest()
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
