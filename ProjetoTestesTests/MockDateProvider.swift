//
//  MockDateProvider.swift
//  ProjetoTestes
//
//  Created by Filipi Romão on 03/03/26.
//

import Foundation
@testable import ProjetoTestes

class MockDateProvider: DateProviding {
    var hoje: Date
    init(data: Date) { self.hoje = data }
}
