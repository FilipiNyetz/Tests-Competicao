//
//  BancoViewModelTests.swift
//  ProjetoTestesTests
//

import XCTest
@testable import ProjetoTestes

final class BancoViewModelTests: XCTestCase {
    
    var viewModel: BancoViewModel!
    var mockDate: MockDateProvider!

    override func setUpWithError() throws {
        mockDate = MockDateProvider(data: BancoMockData.marco)  // ← inicializa aqui
        viewModel = BancoViewModel(
            conta: BancoMockData.contaPadrao,
            dateProvider: mockDate
        )
    }
    
    override func tearDown() {
        viewModel = nil
        mockDate = nil
        super.tearDown()
    }
    
    // MARK: - Saldo
    func testSaldoAtual_DeveRetornarSaldoCorreto() {
        XCTAssertEqual(viewModel.saldoAtual(), 3000.0, accuracy: 0.01)
    }
    
    // MARK: - Depósito
    func testDepositar_ComValorValido_DeveAumentarSaldo() throws {
        try viewModel.depositar(valor: 500.0)
        XCTAssertEqual(viewModel.saldoAtual(), 3500.0, accuracy: 0.01)
    }
    
    func testDepositar_ComValorZero_DeveLancarErro() {
        XCTAssertThrowsError(try viewModel.depositar(valor: 0)) { error in
            XCTAssertEqual(error as? ErroBancario, .valorInvalido)
        }
    }
    
    func testDepositar_ComValorNegativo_DeveLancarErro() {
        XCTAssertThrowsError(try viewModel.depositar(valor: -500)) { error in
            XCTAssertEqual(error as? ErroBancario, .valorInvalido)
        }
    }
    
    func testDepositar_DeveRegistrarTransacao() throws {
        let totalAntes = viewModel.conta.transacoes.count
        try viewModel.depositar(valor: 500.0)
        XCTAssertEqual(viewModel.conta.transacoes.count, totalAntes + 1)
    }
    
    // MARK: - Saque
    func testSacar_ComSaldoSuficiente_DeveReduzirSaldo() throws {
        try viewModel.sacar(valor: 500.0)
        XCTAssertEqual(viewModel.saldoAtual(), 2500.0, accuracy: 0.01)
    }
    
    func testSacar_ComSaldoInsuficiente_DeveLancarErro() {
        XCTAssertThrowsError(try viewModel.sacar(valor: 99999.0)) { error in
            XCTAssertEqual(error as? ErroBancario, .saldoInsuficiente)
        }
    }
    
    func testSacar_ComValorNegativo_DeveLancarErro() {
        XCTAssertThrowsError(try viewModel.sacar(valor: -100)) { error in
            XCTAssertEqual(error as? ErroBancario, .valorInvalido)
        }
    }
    
    func testSacar_ComValorZero_DeveLancarErro() {
        XCTAssertThrowsError(try viewModel.sacar(valor: 0)) { error in
            XCTAssertEqual(error as? ErroBancario, .valorInvalido)
        }
    }
    
    func testSacar_DeveRegistrarTransacao() throws {
        let totalAntes = viewModel.conta.transacoes.count
        try viewModel.sacar(valor: 100.0)
        XCTAssertEqual(viewModel.conta.transacoes.count, totalAntes + 1)
    }
    
    // MARK: - Extrato
    func testExtrato_DeJaneiro_DeveRetornarTresTransacoes() {
        let resultado = viewModel.extrato(mes: BancoMockData.janeiro)
        XCTAssertEqual(resultado.count, 3)
    }
    
    func testExtrato_DeFevereiro_DeveRetornarTresTransacoes() {
        let resultado = viewModel.extrato(mes: BancoMockData.fevereiro)
        XCTAssertEqual(resultado.count, 3)
    }
    
    func testExtrato_DeMarco_DeveRetornarUmaTransacao() {
        let resultado = viewModel.extrato(mes: BancoMockData.marco)
        XCTAssertEqual(resultado.count, 1)
    }
    
    func testExtrato_MesSemTransacoes_DeveRetornarVazio() {
        let dezembro = Calendar.current.date(from: DateComponents(year: 2025, month: 12, day: 1))!
        let resultado = viewModel.extrato(mes: dezembro)
        XCTAssertTrue(resultado.isEmpty)
    }
    
    func testExtratoOrdenado_PrimeiroDeveSerMaisRecente() {
        let resultado = viewModel.extratoOrdenado()
        XCTAssertNotNil(resultado.first)
        XCTAssertNotNil(resultado.last)
        XCTAssertGreaterThan(resultado.first!.data, resultado.last!.data)
    }
    
    func testExtratoOrdenado_NaoDeveEstarVazio() {
        let resultado = viewModel.extratoOrdenado()
        XCTAssertFalse(resultado.isEmpty)
    }
    
    // MARK: - Categorização
    func testTotalAlimentacao_DeveRetornarSomaCorreta() {
        // 150 (janeiro) + 200 (fevereiro) = 350
        XCTAssertEqual(viewModel.total(categoria: .alimentacao), 350.0, accuracy: 0.01)
    }
    
    func testTotalSalario_DeveRetornarSomaCorreta() {
        // 5000 (janeiro) + 5000 (fevereiro) = 10000
        XCTAssertEqual(viewModel.total(categoria: .salario), 10000.0, accuracy: 0.01)
    }
    
    func testTotalReceitas_DeveRetornarSomaCorreta() {
        // 5000 + 5000 = 10000
        XCTAssertEqual(viewModel.totalReceitas(), 10000.0, accuracy: 0.01)
    }
    
    func testTotalDespesas_DeveRetornarSomaCorreta() {
        // 150 + 80 + 200 + 120 + 300 = 850
        XCTAssertEqual(viewModel.totalDespesas(), 850.0, accuracy: 0.01)
    }
    
    func testTotalDespesas_DeveSerMenorQueReceitas() {
        XCTAssertLessThan(viewModel.totalDespesas(), viewModel.totalReceitas())
    }
    
    func testTotalPorCategoria_NaoDeveEstarVazio() {
        let resultado = viewModel.totalPorCategoria()
        XCTAssertFalse(resultado.isEmpty)
    }
    
    func testTotalPorCategoria_DeveConterAlimentacao() {
        let resultado = viewModel.totalPorCategoria()
        XCTAssertNotNil(resultado[.alimentacao])
    }
    
    // MARK: - Juros Simples
    func testJurosSimples_DeveCalcularCorretamente() throws {
        // 1000 * 2% * 12 = 240
        let resultado = try viewModel.calcularJurosSimples(capital: 1000, taxaMensal: 0.02, meses: 12)
        XCTAssertEqual(resultado, 240.0, accuracy: 0.01)
    }
    
    func testJurosSimples_ComCapitalZero_DeveLancarErro() {
        XCTAssertThrowsError(try viewModel.calcularJurosSimples(capital: 0, taxaMensal: 0.02, meses: 12)) { error in
            XCTAssertEqual(error as? ErroBancario, .valorInvalido)
        }
    }
    
    func testJurosSimples_ComCapitalNegativo_DeveLancarErro() {
        XCTAssertThrowsError(try viewModel.calcularJurosSimples(capital: -1000, taxaMensal: 0.02, meses: 12)) { error in
            XCTAssertEqual(error as? ErroBancario, .valorInvalido)
        }
    }
    
    func testJurosSimples_ComTaxaZero_DeveLancarErro() {
        XCTAssertThrowsError(try viewModel.calcularJurosSimples(capital: 1000, taxaMensal: 0, meses: 12)) { error in
            XCTAssertEqual(error as? ErroBancario, .taxaInvalida)
        }
    }
    
    func testJurosSimples_ComPeriodoZero_DeveLancarErro() {
        XCTAssertThrowsError(try viewModel.calcularJurosSimples(capital: 1000, taxaMensal: 0.02, meses: 0)) { error in
            XCTAssertEqual(error as? ErroBancario, .periodoInvalido)
        }
    }
    
    // MARK: - Juros Compostos
    func testJurosCompostos_DeveCalcularCorretamente() throws {
        // 1000 * (1.02)^12 = 1268.24
        let resultado = try viewModel.calcularJurosCompostos(capital: 1000, taxaMensal: 0.02, meses: 12)
        XCTAssertEqual(resultado, 1268.24, accuracy: 0.01)
    }
    
    func testJurosCompostos_ComCapitalZero_DeveLancarErro() {
        XCTAssertThrowsError(try viewModel.calcularJurosCompostos(capital: 0, taxaMensal: 0.02, meses: 12)) { error in
            XCTAssertEqual(error as? ErroBancario, .valorInvalido)
        }
    }
    
    func testJurosCompostos_ComTaxaZero_DeveLancarErro() {
        XCTAssertThrowsError(try viewModel.calcularJurosCompostos(capital: 1000, taxaMensal: 0, meses: 12)) { error in
            XCTAssertEqual(error as? ErroBancario, .taxaInvalida)
        }
    }
    
    func testJurosCompostos_ComPeriodoZero_DeveLancarErro() {
        XCTAssertThrowsError(try viewModel.calcularJurosCompostos(capital: 1000, taxaMensal: 0.02, meses: 0)) { error in
            XCTAssertEqual(error as? ErroBancario, .periodoInvalido)
        }
    }
    
    func testJurosCompostos_DeveSerMaiorQueJurosSimples() throws {
        let simples   = try viewModel.calcularJurosSimples(capital: 1000, taxaMensal: 0.02, meses: 12)
        let compostos = try viewModel.calcularJurosCompostos(capital: 1000, taxaMensal: 0.02, meses: 12)
        XCTAssertGreaterThan(compostos, simples)
    }
}

