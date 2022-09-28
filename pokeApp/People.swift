import Foundation

struct Result: Decodable {
    struct People: Decodable {
        //essas propriedades devem ser iguais às do JSON
        let name: String
        let number: String
    }
    
}

