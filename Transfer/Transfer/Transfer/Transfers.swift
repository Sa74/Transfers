//
//  Transfers.swift
//  Transfer
//
//  Created by Sasi Moorthy on 15/03/19.
//  Copyright © 2019 Sasi Moorthy. All rights reserved.
//

import UIKit

enum TransferType: Int {
    case Debit = 1,
    Credit
}

struct Transfers: Codable {
    var transferList: [Transfer]
    
    enum CodingKeys: String, CodingKey {
        case transferList = "transfers"
    }
}

struct Transfer: Codable {
    let id: String
    let date: String
    let type: Int
    let accountNumber: String
    let accountHolderName: String
    let sentAmount: Double
    let sentCurrency: String
    let receivedAmount: Double
    let receivedCurrency: String
    let exchangeRate: Float
    let remarks: String
}

/*
 * Struct model to realm model conversion
 */
extension Transfer: Persistable {
    public func managedObject() -> TransferEntity {
        let transferEntity = TransferEntity()
        transferEntity.update(withTransfer: self)
        return transferEntity
    }
}
