//
//  TransferDetailViewModelTests.swift
//  TransferTests
//
//  Created by Sasi Moorthy on 16/03/19.
//  Copyright © 2019 Sasi Moorthy. All rights reserved.
//

import XCTest
@testable import Transfer

class TransferDetailViewModelTests: XCTestCase {
    
    var transferEntities: [TransferEntity] = []
    var transferDetailViewModel: TransferDetailViewModel!
    
    override func setUp() {
        super.setUp()
        let transfersData = ["transfers": [["id": "100456",
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
        
        let transfersJSONData = try! JSONSerialization.data(withJSONObject: transfersData, options: .prettyPrinted)
        let transfers = try! JSONDecoder().decode(Transfers.self, from: transfersJSONData)
        for transfer in transfers.transferList {
            transferEntities.append(transfer.managedObject())
        }
        
        transferDetailViewModel = TransferDetailViewModel.init(transferEntities[0])
    }

    override func tearDown() {
        transferDetailViewModel = nil
        transferEntities.removeAll()
        super.tearDown()
    }
    
    func testInit() {
        XCTAssertNotNil(transferDetailViewModel.transferDetail)
    }
    
    func testTransferDetailModel() {
        
        transferDetailViewModel = TransferDetailViewModel.init(transferEntities[0])
        var transferDetail = transferDetailViewModel!.transferDetail
        XCTAssertEqual(transferDetail.transferDescription, "Your transfer #100456 to")
        XCTAssertEqual(transferDetail.accountHolderName ,"KARTHI RAJ")
        XCTAssertEqual(transferDetail.sentTitle ,"You sent")
        XCTAssertEqual(transferDetail.sentAmount ,"42000.0 INR")
        XCTAssertEqual(transferDetail.receivedTitle , "KARTHI RAJ received")
        XCTAssertEqual(transferDetail.receivedAmount ,"840.0 AUD")
        XCTAssertEqual(transferDetail.dateTitle , "Should have arrived on")
        XCTAssertEqual(transferDetail.date , "28 Jul 2018")
        XCTAssertEqual(transferDetail.exchangeRate , "1 INR → 0.02 AUD")
        XCTAssertEqual(transferDetail.referenceTitle , "Reference")
        XCTAssertEqual(transferDetail.reference , "Fund transfer for Nepal trip")
        
        transferDetailViewModel = TransferDetailViewModel.init(transferEntities[1])
        transferDetail = transferDetailViewModel!.transferDetail
        XCTAssertEqual(transferDetail.transferDescription, "Your transfer #100457 to")
        XCTAssertEqual(transferDetail.accountHolderName ,"STEVE AUSTIN")
        XCTAssertEqual(transferDetail.sentTitle ,"You sent")
        XCTAssertEqual(transferDetail.sentAmount ,"12500.0 INR")
        XCTAssertEqual(transferDetail.receivedTitle , "STEVE AUSTIN received")
        XCTAssertEqual(transferDetail.receivedAmount ,"737.5 MYR")
        XCTAssertEqual(transferDetail.dateTitle , "Should have arrived on")
        XCTAssertEqual(transferDetail.date , "07 Aug 2018")
        XCTAssertEqual(transferDetail.exchangeRate , "1 INR → 0.059 MYR")
        XCTAssertEqual(transferDetail.referenceTitle , "Reference")
        XCTAssertEqual(transferDetail.reference , "Base camp fees repay")
        
        transferDetailViewModel = TransferDetailViewModel.init(transferEntities[2])
        transferDetail = transferDetailViewModel!.transferDetail
        XCTAssertEqual(transferDetail.transferDescription, "Your transfer #100458 from")
        XCTAssertEqual(transferDetail.accountHolderName ,"ROBERT BODIZS")
        XCTAssertEqual(transferDetail.sentTitle ,"ROBERT BODIZS sent")
        XCTAssertEqual(transferDetail.sentAmount ,"700.0 USD")
        XCTAssertEqual(transferDetail.receivedTitle , "You received")
        XCTAssertEqual(transferDetail.receivedAmount ,"48265.0 INR")
        XCTAssertEqual(transferDetail.dateTitle , "Should have arrived on")
        XCTAssertEqual(transferDetail.date , "07 Aug 2018")
        XCTAssertEqual(transferDetail.exchangeRate , "1 USD → 68.95 INR")
        XCTAssertEqual(transferDetail.referenceTitle , "Reference")
        XCTAssertEqual(transferDetail.reference , "WWDC expenses splitwise")
    }
}
