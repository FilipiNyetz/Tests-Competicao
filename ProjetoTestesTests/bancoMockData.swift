//
//  bancoMockData.swift
//  ProjetoTestes
//
//  Created by Filipi Romão on 03/03/26.
//

import Foundation

struct BancoMockData {
    
    // MARK: - Datas fixas
    static var janeiro: Date {
        Calendar.current.date(from: DateComponents(year: 2026, month: 1, day: 10))!
    }
    static var fevereiro: Date {
        Calendar.current.date(from: DateComponents(year: 2026, month: 2, day: 10))!
    }
    static var marco: Date {
        Calendar.current.date(from: DateComponents(year: 2026, month: 3, day: 1))!
    }
    
    // MARK: - Transações
    static var transacoes: [Transacao] {[
        Transacao(id: UUID(), valor: 5000.0, tipo: .receita, categoria: .salario,      data: janeiro,   descricao: "Salário Janeiro"),
        Transacao(id: UUID(), valor: 150.0,  tipo: .despesa, categoria: .alimentacao,  data: janeiro,   descricao: "Supermercado"),
        Transacao(id: UUID(), valor: 80.0,   tipo: .despesa, categoria: .transporte,   data: janeiro,   descricao: "Uber"),
        Transacao(id: UUID(), valor: 5000.0, tipo: .receita, categoria: .salario,      data: fevereiro, descricao: "Salário Fevereiro"),
        Transacao(id: UUID(), valor: 200.0,  tipo: .despesa, categoria: .alimentacao,  data: fevereiro, descricao: "Restaurante"),
        Transacao(id: UUID(), valor: 120.0,  tipo: .despesa, categoria: .saude,        data: fevereiro, descricao: "Farmácia"),
        Transacao(id: UUID(), valor: 300.0,  tipo: .despesa, categoria: .lazer,        data: marco,     descricao: "Show"),
    ]}
    
    // MARK: - Contas prontas
    static var contaPadrao: Conta {
        Conta(id: UUID(), saldo: 3000.0, titular: "Filipi", transacoes: transacoes)
    }
    
    static var contaZerada: Conta {
        Conta(id: UUID(), saldo: 0.0, titular: "Filipi", transacoes: [])
    }
    
    static var contaSemTransacoes: Conta {
        Conta(id: UUID(), saldo: 1000.0, titular: "Filipi", transacoes: [])
    }
}
