//
//  ContentView.swift
//  ProjetoTestes
//
//  Created by Filipi Romão on 03/03/26.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var imcVM = imcViewModel()
    
    var body: some View {
        VStack {
            Text("Calculadora IMC")
            
            TextField("Insira seu peso", text: $imcVM.peso)
                .keyboardType(.decimalPad)
                .textFieldStyle(.roundedBorder)
            
            TextField("Insira sua altura", text: $imcVM.altura)
                .keyboardType(.decimalPad)
                .textFieldStyle(.roundedBorder)
            
            Button("Calcular IMC") {
                imcVM.calcularIMC()
            }
        }
        .padding()
    }
    
   
}

#Preview {
    ContentView()
}
