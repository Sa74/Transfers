//
//  TransferEntity.swift
//  Transfer
//
//  Created by Sasi Moorthy on 16/03/19.
//  Copyright © 2019 Sasi Moorthy. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

public protocol Persistable {
    associatedtype ManagedObject: RealmSwift.Object
    func managedObject() -> ManagedObject
}

final class Indicator {
    var symbol: String
    var color: UIColor
    
    init(_ symbol: String, color: UIColor) {
        self.symbol = symbol
        self.color = color
    }
}

final class TransferEntity: Object {
    
    @objc dynamic var id = ""
    @objc dynamic var date = ""
    @objc dynamic var type = 0
    @objc dynamic var accountNumber = ""
    @objc dynamic var accountHolderName = ""
    @objc dynamic var sentAmount: Double = 0
    @objc dynamic var sentCurrency = ""
    @objc dynamic var receivedAmount: Double = 0
    @objc dynamic var receivedCurrency = ""
    @objc dynamic var exchangeRate: Float = 0
    @objc dynamic var remarks = ""
    var indicator: Indicator?
    
    func update(withTransfer transfer: Transfer) {
        self.id = transfer.id
        self.date = transfer.date
        self.type = transfer.type
        self.accountNumber = transfer.accountNumber
        self.accountHolderName = transfer.accountHolderName
        self.sentAmount = transfer.sentAmount
        self.sentCurrency = transfer.sentCurrency
        self.receivedAmount = transfer.receivedAmount
        self.receivedCurrency = transfer.receivedCurrency
        self.exchangeRate = transfer.exchangeRate
        self.remarks = transfer.remarks
    }
}

