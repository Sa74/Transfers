//
//  TransfersViewModelTests.swift
//  TransferTests
//
//  Created by Sasi Moorthy on 16/03/19.
//  Copyright © 2019 Sasi Moorthy. All rights reserved.
//

import XCTest
@testable import Transfer

class TransfersViewModelTests: XCTestCase {
    
    var transferEntities: [TransferEntity] = []
    
    var transfersViewModel: TransfersViewModel!
    var mockTransfersService: MockTransfersService!
    var mockTransfersCachehandler: MockTransfersCachehandler!
    var mockReachability: MockReachability!
    
    var state = 0
    
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
        
        mockTransfersService = MockTransfersService(transfers)
        mockTransfersCachehandler = MockTransfersCachehandler(transferEntities)
        mockReachability = MockReachability()
        
        transfersViewModel = TransfersViewModel(mockTransfersService, transferCacheHandler: mockTransfersCachehandler, reachability: mockReachability)
        transfersViewModel.notification = { [weak self] (state) in
            self?.state = state.rawValue
        }
    }
    
    override func tearDown() {
        mockTransfersService = nil
        mockTransfersCachehandler = nil
        mockReachability = nil
        transfersViewModel = nil
        transferEntities.removeAll()
        super.tearDown()
    }

    func testInit() {
        XCTAssertEqual(transfersViewModel.transferEntities.count, 0)
        XCTAssertEqual(transfersViewModel.numberOfTransfersInSection(0), 0)
    }
    
    func testTransfersDataLoad() {
        transfersViewModel.loadTransfersData()
        
        XCTAssertEqual(state, 1)
        
        mockTransfersService.fetchSuccess()
        
        XCTAssertEqual(state, 2)
        XCTAssertEqual(transfersViewModel.transferEntities.count, 3)
        XCTAssertEqual(transfersViewModel.numberOfTransfersInSection(0), 3)
        XCTAssertEqual(mockTransfersCachehandler.clearCacheCalled, true)
        XCTAssertEqual(mockTransfersCachehandler.cacheTransferCalled, true)
        
        mockTransfersCachehandler.reset()
    }
    
    func testTransfersDataLoadFailure() {
        transfersViewModel.loadTransfersData()
        
        XCTAssertEqual(state, 1)
        
        mockTransfersService.fetchFailure()
        
        XCTAssertEqual(state, 4)
        XCTAssertEqual(transfersViewModel.transferEntities.count, 0)
        XCTAssertEqual(transfersViewModel.numberOfTransfersInSection(0), 0)
        XCTAssertEqual(mockTransfersCachehandler.clearCacheCalled, true)
        XCTAssertEqual(mockTransfersCachehandler.cacheTransferCalled, false)
    }
    
    func testTransfersDataLoadFailureOffline() {
        mockReachability.isOnline = false
        transfersViewModel.loadTransfersData()
        
        XCTAssertEqual(state, 3)
        XCTAssertEqual(transfersViewModel.transferEntities.count, 0)
        XCTAssertEqual(transfersViewModel.numberOfTransfersInSection(0), 0)
        XCTAssertEqual(mockTransfersCachehandler.clearCacheCalled, false)
        XCTAssertEqual(mockTransfersCachehandler.cacheTransferCalled, false)
    }
    
    func testCachedTransfersDataLoadOffline() {
        mockReachability.isOnline = false
        mockTransfersCachehandler.isTestingCacheSuccess = true
        transfersViewModel.loadTransfersData()
        
        XCTAssertEqual(state, 2)
        XCTAssertEqual(transfersViewModel.transferEntities.count, 3)
        XCTAssertEqual(transfersViewModel.numberOfTransfersInSection(0), 3)
        XCTAssertEqual(mockTransfersCachehandler.clearCacheCalled, false)
        XCTAssertEqual(mockTransfersCachehandler.cacheTransferCalled, false)
    }
    
    func testTransfersFetchAfterLoadingCache() {
        testCachedTransfersDataLoadOffline()
        
        mockReachability.isOnline = true
        mockTransfersCachehandler.isTestingCacheSuccess = false
        testTransfersDataLoad()
    }
    
    func testTransactionEntityAfterLoadSuccess() {
        testTransfersDataLoad()
        
        var transferEntity = transfersViewModel.transferAtIndex(0, section: 0)
        var actualTransferEntity = transferEntities[0]
        XCTAssertEqual(transferEntity.id, actualTransferEntity.id)
        
        transferEntity = transfersViewModel.transferAtIndex(1, section: 0)
        actualTransferEntity = transferEntities[1]
        XCTAssertEqual(transferEntity.id, actualTransferEntity.id)
        
        transferEntity = transfersViewModel.transferAtIndex(2, section: 0)
        actualTransferEntity = transferEntities[2]
        XCTAssertEqual(transferEntity.id, actualTransferEntity.id)
    }
}

class MockTransfersService: TransfersService {
    
    var complete: ((Result) -> ())!
    var transfers: Transfers!
    var isTransfersFetchCalled: Bool = false
    
    init(_ transfers: Transfers) {
        self.transfers = transfers
    }
    
    override func fetchTranfers(_ completion: @escaping (Result) -> ()) {
        isTransfersFetchCalled = true
        self.complete = completion
    }
    
    func fetchSuccess() {
        complete(Result.success(transfers))
    }
    
    func fetchFailure() {
        complete(Result.failure("Invalid data"))
    }
}


class MockTransfersCachehandler: TransfersCachehandler {
    
    var transferEntities: [TransferEntity]!
    var isTestingCacheSuccess = false
    var cacheTransferCalled = false
    var clearCacheCalled = false
    
    init(_ transferEntities: [TransferEntity]) {
        self.transferEntities = transferEntities
    }
    
    override func getCachedTransfers() -> [TransferEntity] {
        return isTestingCacheSuccess ? transferEntities : []
    }
    
    override func cacheTransferEntity(_ transfers: [TransferEntity]) {
        cacheTransferCalled = true
    }
    
    override func clearCache() {
        clearCacheCalled = true
    }
    
    func reset() {
        isTestingCacheSuccess = false
        cacheTransferCalled = false
        clearCacheCalled = false
    }
}

class MockReachability: Reachability {
    
    var isOnline = true
    
    override func isConnectedToNetwork() -> Bool {
        return isOnline
    }
}
