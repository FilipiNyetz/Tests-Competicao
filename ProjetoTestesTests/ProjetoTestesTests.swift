//
//  ProjetoTestesTests.swift
//  ProjetoTestesTests
//
//  Created by Filipi Romão on 03/03/26.
//

import XCTest
@testable import ProjetoTestes

final class ProjetoTestesTests: XCTestCase {
    
    var calcImc: imcViewModel!
    
    override func setUpWithError() throws {
        calcImc = imcViewModel()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    //    func testExample() throws {
    //        // This is an example of a functional test case.
    //        // Use XCTAssert and related functions to verify your tests produce the correct results.
    //        // Any test you write for XCTest can be annotated as throws and async.
    //        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
    //        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    //        //        var result = calc.add(10, 10)
    //
    //        var imc = calcImc.calcularIMC()
    //
    //
    //        func testCalcularIMC_ComValoresValidos() {
    //            // Arrange
    //            calcImc.peso = "80"
    //            calcImc.altura = "99"
    //
    //            // Act
    //            let resultado = calcImc.calcularIMC()
    //
    //            // Assert
    //            XCTAssertEqual(resultado, 24.69, accuracy: 0.01, "Deu pau")
    //        }
    //        //        XCTAssertEqual(result, 20, "The sum of 10 and 10 should be 20" )
    //        XCTAssertEqual(imc, 0, "The IMC should be 0" )
    //    }
    
    // Teste 1 — valor válido retorna IMC positivo
    func testCalcularIMC_ComValoresValidos() throws {
        calcImc.peso = "80"
        calcImc.altura = "1.80"
        
        let resultado = calcImc.calcularIMC()
        
        XCTAssertNotNil(resultado)
        XCTAssertGreaterThan(resultado!, 0.0, "O IMC não pode ser negativo")
    }
    
    func testCalcularIMC_ComValoresEnormes_DeveRetornarNil() {
        calcImc.peso = "800000000000000"
        calcImc.altura = "1.80"
        
        XCTAssertNil(calcImc.calcularIMC(), "Peso biologicamente impossível deve retornar nil")
    }

    // Teste 2 — peso negativo é entrada inválida
    func testCalcularIMC_ComPesoNegativo_DeveRetornarNil() {
        calcImc.peso = "-80"
        calcImc.altura = "1.80"
        
        let resultado = calcImc.calcularIMC()
        
        XCTAssertNil(resultado, "Peso negativo deve retornar nil")
    }
    
    func testCalcularIMC_ComAlturaZero_DeveRetornarNil() {
        calcImc.peso = "80"
        calcImc.altura = "0"
        
        let resultado = calcImc.calcularIMC()
        
        XCTAssertNil(resultado)
    }
    
    func testCalcularIMC_ComValoresInvalidos() {
        calcImc.peso = "abc"
        calcImc.altura = "1.80"
        
        let resultado = calcImc.calcularIMC()
        
        XCTAssertNil(resultado)
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
