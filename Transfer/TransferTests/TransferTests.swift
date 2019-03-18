//
//  TransferTests.swift
//  TransferTests
//
//  Created by Sasi Moorthy on 15/03/19.
//  Copyright © 2019 Sasi Moorthy. All rights reserved.
//

import XCTest
@testable import Transfer

class TransferTests: XCTestCase {
    
    var dataset: Dictionary<String, Any>?
    var transfers: Transfers?
    
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
    
    func testTransfersData() {
        let datasetJSONData = try! JSONSerialization.data(withJSONObject: dataset!, options: .prettyPrinted)
        let transfers = try! JSONDecoder().decode(Transfers.self, from: datasetJSONData)
        XCTAssertEqual(transfers.transferList.count, 3)
        
        var transfer = transfers.transferList[0]
        XCTAssertEqual(transfer.id, "100456")
        XCTAssertEqual(transfer.date, "28 Jul 2018")
        XCTAssertEqual(transfer.accountNumber, "2723610580")
        XCTAssertEqual(transfer.accountHolderName, "Karthi Raj")
        XCTAssertEqual(transfer.remarks, "Fund transfer for Nepal trip")
        XCTAssertEqual(transfer.sentAmount, 42000)
        XCTAssertEqual(transfer.sentCurrency, "INR")
        XCTAssertEqual(transfer.receivedAmount, 840)
        XCTAssertEqual(transfer.receivedCurrency, "AUD")
        XCTAssertEqual(transfer.exchangeRate, 0.02)
        XCTAssertEqual(transfer.type, 1)
        
        transfer = transfers.transferList[1]
        XCTAssertEqual(transfer.id, "100457")
        XCTAssertEqual(transfer.date, "07 Aug 2018")
        XCTAssertEqual(transfer.accountNumber, "7300662134")
        XCTAssertEqual(transfer.accountHolderName, "Steve Austin")
        XCTAssertEqual(transfer.remarks, "Base camp fees repay")
        XCTAssertEqual(transfer.sentAmount, 12500)
        XCTAssertEqual(transfer.sentCurrency, "INR")
        XCTAssertEqual(transfer.receivedAmount, 737.5)
        XCTAssertEqual(transfer.receivedCurrency, "MYR")
        XCTAssertEqual(transfer.exchangeRate, 0.059)
        XCTAssertEqual(transfer.type, 1)
        
        transfer = transfers.transferList[2]
        XCTAssertEqual(transfer.id, "100458")
        XCTAssertEqual(transfer.date, "07 Aug 2018")
        XCTAssertEqual(transfer.accountNumber, "4532600610580")
        XCTAssertEqual(transfer.accountHolderName, "Robert Bodizs")
        XCTAssertEqual(transfer.remarks, "WWDC expenses splitwise")
        XCTAssertEqual(transfer.sentAmount, 700)
        XCTAssertEqual(transfer.sentCurrency, "USD")
        XCTAssertEqual(transfer.receivedAmount, 48265)
        XCTAssertEqual(transfer.receivedCurrency, "INR")
        XCTAssertEqual(transfer.exchangeRate, 68.95)
        XCTAssertEqual(transfer.type, 2)
    }
    
}
