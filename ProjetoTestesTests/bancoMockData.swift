//
//  bancoMockData.swift
//  ProjetoTestes
//
//  Created by Filipi Romão on 03/03/26.
//

import Foundation

// BancoMockData é uma struct de dados fictícios usada exclusivamente nos testes.
// Ela centraliza todos os dados de teste em um único lugar, evitando repetição
// e garantindo que todos os testes usem os mesmos valores de referência.
//
// Por ser uma struct com propriedades estáticas, não precisa ser instanciada —
// basta acessar diretamente: BancoMockData.contaPadrao, BancoMockData.janeiro, etc.

struct BancoMockData {
    
    // MARK: - Datas fixas
       // Datas congeladas no tempo para uso nos testes de extrato e filtro por mês.
       // Usar datas fixas é essencial — se usássemos Date() aqui, o resultado
       // do filtro mudaria dependendo de quando o teste fosse executado.
       //
       // Exemplo: testExtrato_DeJaneiro espera 3 transações.
       // Se a data fosse dinâmica, em fevereiro o teste poderia retornar 0.
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
       // Lista de transações fictícias distribuídas em 3 meses diferentes.
       // Essa distribuição é intencional para permitir testar:
       //   - Filtro por mês (janeiro: 3, fevereiro: 3, março: 1)
       //   - Total por categoria (alimentacao: 350, salario: 10000, etc.)
       //   - Total de receitas vs despesas
       //
       // Sempre que adicionar ou remover uma transação aqui,
       // revise os testes que dependem de contagens e somas específicas.
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
