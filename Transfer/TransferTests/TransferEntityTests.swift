//
//  TransferEntityTests.swift
//  TransferTests
//
//  Created by Sasi Moorthy on 16/03/19.
//  Copyright © 2019 Sasi Moorthy. All rights reserved.
//

import XCTest
@testable import Transfer

class TransferEntityTests: XCTestCase {

    var dataset: Dictionary<String, Any>?
    
    override func setUp() {
        super.setUp()
        
        dataset = ["transfers": [["id": "100456",
                                     "date": "28 Jul 2018",
                                     "accountNumber": "2723610580",
                                     "accountHolderName": "Karthi Raj",
                                     "remarks": "Fund transfer for Nepal trip",
                                     "sentAmount": 42000,
                                     "sentCurrency": "INR",
                                     "receivedAmount": 840,
                                     "receivedCurrency": "AUD",
                                     "exchangeRate": 0.02,
                                     "type": 1],
                                    ["id": "100457",
                                     "date": "07 Aug 2018",
                                     "accountNumber": "7300662134",
                                     "accountHolderName": "Steve Austin",
                                     "remarks": "Base camp fees repay",
                                     "sentAmount": 12500,
                                     "sentCurrency": "INR",
                                     "receivedAmount": 737.5,
                                     "receivedCurrency": "MYR",
                                     "exchangeRate": 0.059,
                                     "type": 1],
                                    ["id": "100458",
                                     "date": "07 Aug 2018",
                                     "accountNumber": "4532600610580",
                                     "accountHolderName": "Robert Bodizs",
                                     "remarks": "WWDC expenses splitwise",
                                     "sentAmount": 700,
                                     "sentCurrency": "USD",
                                     "receivedAmount": 48265,
                                     "receivedCurrency": "INR",
                                     "exchangeRate": 68.95,
                                     "type": 2]]]
    }
    
    override func tearDown() {
        dataset = nil
        super.tearDown()
    }
    
    func testTransferEntityData() {
        let datasetJSONData = try! JSONSerialization.data(withJSONObject: dataset!, options: .prettyPrinted)
        let transfers = try! JSONDecoder().decode(Transfers.self, from: datasetJSONData)
        
        var transfer = transfers.transferList[0]
        var transferEntity = transfer.managedObject()
        XCTAssertEqual(transferEntity.id, transfer.id)
        XCTAssertEqual(transferEntity.date ,transfer.date)
        XCTAssertEqual(transferEntity.accountNumber ,transfer.accountNumber)
        XCTAssertEqual(transferEntity.accountHolderName ,transfer.accountHolderName)
        XCTAssertEqual(transferEntity.remarks ,transfer.remarks)
        XCTAssertEqual(transferEntity.sentAmount ,transfer.sentAmount)
        XCTAssertEqual(transferEntity.sentCurrency ,transfer.sentCurrency)
        XCTAssertEqual(transferEntity.receivedAmount ,transfer.receivedAmount)
        XCTAssertEqual(transferEntity.receivedCurrency ,transfer.receivedCurrency)
        XCTAssertEqual(transferEntity.exchangeRate ,transfer.exchangeRate)
        XCTAssertEqual(transferEntity.type ,transfer.type)
        XCTAssertNil(transferEntity.indicator)
        
        transfer = transfers.transferList[1]
        transferEntity = transfer.managedObject()
        XCTAssertEqual(transferEntity.id, transfer.id)
        XCTAssertEqual(transferEntity.date ,transfer.date)
        XCTAssertEqual(transferEntity.accountNumber ,transfer.accountNumber)
        XCTAssertEqual(transferEntity.accountHolderName ,transfer.accountHolderName)
        XCTAssertEqual(transferEntity.remarks ,transfer.remarks)
        XCTAssertEqual(transferEntity.sentAmount ,transfer.sentAmount)
        XCTAssertEqual(transferEntity.sentCurrency ,transfer.sentCurrency)
        XCTAssertEqual(transferEntity.receivedAmount ,transfer.receivedAmount)
        XCTAssertEqual(transferEntity.receivedCurrency ,transfer.receivedCurrency)
        XCTAssertEqual(transferEntity.exchangeRate ,transfer.exchangeRate)
        XCTAssertEqual(transferEntity.type ,transfer.type)
        XCTAssertNil(transferEntity.indicator)
        
        transfer = transfers.transferList[2]
        transferEntity = transfer.managedObject()
        XCTAssertEqual(transferEntity.id, transfer.id)
        XCTAssertEqual(transferEntity.date ,transfer.date)
        XCTAssertEqual(transferEntity.accountNumber ,transfer.accountNumber)
        XCTAssertEqual(transferEntity.accountHolderName ,transfer.accountHolderName)
        XCTAssertEqual(transferEntity.remarks ,transfer.remarks)
        XCTAssertEqual(transferEntity.sentAmount ,transfer.sentAmount)
        XCTAssertEqual(transferEntity.sentCurrency ,transfer.sentCurrency)
        XCTAssertEqual(transferEntity.receivedAmount ,transfer.receivedAmount)
        XCTAssertEqual(transferEntity.receivedCurrency ,transfer.receivedCurrency)
        XCTAssertEqual(transferEntity.exchangeRate ,transfer.exchangeRate)
        XCTAssertEqual(transferEntity.type ,transfer.type)
        XCTAssertNil(transferEntity.indicator)
    }

}
