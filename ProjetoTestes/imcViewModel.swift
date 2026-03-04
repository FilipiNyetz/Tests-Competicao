//
//  imcViewModel.swift
//  ProjetoTestes
//
//  Created by Filipi Romão on 03/03/26.
//

import Foundation
internal import Combine


class imcViewModel: ObservableObject {
    @Published var imc: Double = 0.0
    @Published var resultado: String = ""
    @Published var peso: String = ""
    @Published var altura: String = ""
    
    func calcularIMC() -> Double? {
        guard let peso = Double(self.peso),
              let altura = Double(self.altura),
              peso > 0,      // ← adiciona isso
              altura > 0 else {
            return nil
        }
        return peso / (altura * altura)
    }
    
}
