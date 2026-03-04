//
//  bancoViewModel.swift
//  ProjetoTestes
//
//  Created by Filipi Romão on 03/03/26.
//

//
//  bancoViewModel.swift
//  ProjetoTestes
//
//  Created by Filipi Romão on 03/03/26.
//

import Foundation

// MARK: - DateProviding
// Protocolo que abstrai a fonte de data do sistema.
// Ao invés de chamar Date() diretamente no ViewModel, delegamos
// essa responsabilidade para quem implementar esse protocolo.
// Isso permite que nos testes passemos uma data fixa (MockDateProvider)
// e em produção usemos a data real (RealDateProvider).
protocol DateProviding {
    var hoje: Date { get }
}

// Implementação real usada em produção.
// Retorna sempre a data e hora atual do dispositivo.
class RealDateProvider: DateProviding {
    var hoje: Date { Date() }
}

class BancoViewModel {
    
    private(set) var conta: Conta
    // dateProvider é injetado no init — padrão chamado "Injeção de Dependência".
      // Isso significa que o ViewModel não decide qual data usar,
      // quem cria o ViewModel é que decide.
      //
      // Exemplo em produção:
      //   BancoViewModel(conta: conta)
      //   → usa RealDateProvider por padrão → Date() real
      //
      // Exemplo nos testes:
      //   BancoViewModel(conta: conta, dateProvider: MockDateProvider(data: dataFixa))
      //   → usa data congelada → testes sempre produzem o mesmo resultado
    private let dateProvider: DateProviding
    
    init(conta: Conta, dateProvider: DateProviding = RealDateProvider()) {
        self.conta = conta
        self.dateProvider = dateProvider
    }
    
    func saldoAtual() -> Double { conta.saldo }
    
    func depositar(valor: Double) throws {
        guard valor > 0 else { throw ErroBancario.valorInvalido }
        conta.saldo += valor
        registrar(valor: valor, tipo: .receita, categoria: .outros, descricao: "Depósito")
    }
    
    func sacar(valor: Double) throws {
        guard valor > 0 else { throw ErroBancario.valorInvalido }
        guard conta.saldo >= valor else { throw ErroBancario.saldoInsuficiente }
        conta.saldo -= valor
        registrar(valor: valor, tipo: .despesa, categoria: .outros, descricao: "Saque")
    }
    
    func extrato(mes: Date) -> [Transacao] {
        return conta.transacoes.filter {
            Calendar.current.isDate($0.data, equalTo: mes, toGranularity: .month)
        }
    }
    
    func extratoOrdenado() -> [Transacao] {
        return conta.transacoes.sorted { $0.data > $1.data }
    }
    
    func total(categoria: CategoriaTransacao) -> Double {
        return conta.transacoes
            .filter { $0.categoria == categoria }
            .reduce(0) { $0 + $1.valor }
    }
    
    func totalPorCategoria() -> [CategoriaTransacao: Double] {
        var resultado: [CategoriaTransacao: Double] = [:]
        for transacao in conta.transacoes {
            resultado[transacao.categoria, default: 0] += transacao.valor
        }
        return resultado
    }
    
    func totalReceitas() -> Double {
        return conta.transacoes.filter { $0.tipo == .receita }.reduce(0) { $0 + $1.valor }
    }
    
    func totalDespesas() -> Double {
        return conta.transacoes.filter { $0.tipo == .despesa }.reduce(0) { $0 + $1.valor }
    }
    
    func calcularJurosSimples(capital: Double, taxaMensal: Double, meses: Int) throws -> Double {
        guard capital > 0 else { throw ErroBancario.valorInvalido }
        guard taxaMensal > 0 else { throw ErroBancario.taxaInvalida }
        guard meses > 0 else { throw ErroBancario.periodoInvalido }
        return capital * taxaMensal * Double(meses)
    }
    
    func calcularJurosCompostos(capital: Double, taxaMensal: Double, meses: Int) throws -> Double {
        guard capital > 0 else { throw ErroBancario.valorInvalido }
        guard taxaMensal > 0 else { throw ErroBancario.taxaInvalida }
        guard meses > 0 else { throw ErroBancario.periodoInvalido }
        return capital * pow(1 + taxaMensal, Double(meses))
    }
    
    private func registrar(valor: Double, tipo: TipoTransacao, categoria: CategoriaTransacao, descricao: String) {
        let transacao = Transacao(
            id: UUID(), valor: valor, tipo: tipo,
            categoria: categoria, data: dateProvider.hoje, descricao: descricao
        )
        conta.transacoes.append(transacao)
    }
}
