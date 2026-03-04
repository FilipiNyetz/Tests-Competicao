//
//  enumsBanco.swift
//  ProjetoTestes
//
//  Created by Filipi Romão on 03/03/26.
//

import Foundation

enum TipoTransacao {
    case receita
    case despesa
}

enum CategoriaTransacao: Equatable {
    case alimentacao
    case transporte
    case salario
    case lazer
    case saude
    case outros
}

enum ErroBancario: Error, Equatable {
    case saldoInsuficiente
    case valorInvalido
    case taxaInvalida
    case periodoInvalido
}


struct Transacao: Identifiable {
    let id: UUID
    let valor: Double
    let tipo: TipoTransacao
    let categoria: CategoriaTransacao
    let data: Date
    let descricao: String
}

struct Conta {
    let id: UUID
    var saldo: Double
    var titular: String
    var transacoes: [Transacao]
}
