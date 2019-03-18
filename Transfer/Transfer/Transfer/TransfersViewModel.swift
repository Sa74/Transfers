//
//  TransfersViewModel.swift
//  Transfer
//
//  Created by Sasi Moorthy on 15/03/19.
//  Copyright © 2019 Sasi Moorthy. All rights reserved.
//

import UIKit

/*
 * Enum values to define data retrieval and network connection states
 * Passed as parameter in updateHandler block
 */
enum State: Int {
    case Loading = 1,   // Data loading in progress
    Success,            // Data load is Success
    Offline,            // Network is offline
    Error               // Data load is failure
}


class TransfersViewModel {
    
    /*
     * Private variable for TransferService, TransfersCachehandler & Reachability
     * Initialized by default if not passed as parameters to init methods
     */
    private let transferService: TransfersService
    private let transfersCacheHandler: TransfersCachehandler
    private let reachability: Reachability
    
    /*
     * Private variable for Transfers model
     */
    private(set) public var transferEntities: [TransferEntity] = []
    
    /*
     * The closure that will get called every time
     * when the view model is updated
     */
    var notification: (_ state: State) -> Void = {_ in }
    
    /*
     * Gets service class instance, cache handler instance and Reachability instace as parameters
     * If no arguments passed then default instance will be initialized
     */
    init(_ transferService: TransfersService = TransfersService(),
         transferCacheHandler: TransfersCachehandler = TransfersCachehandler(),
         reachability: Reachability = Reachability()) {
        self.transferService = transferService
        self.transfersCacheHandler = transferCacheHandler
        self.reachability = reachability
    }
    
    /*
     * Data operation methods to be triggered from View controllers
     * Clears existing transfer data before making new fetch request
     */
    func loadTransfersData() {
        if reachability.isConnectedToNetwork() == true {
            fetchTransfersList()
        } else {
            loadCachedData(.Offline)
        }
    }
}


// MARK: - Transfers Data fetch

extension TransfersViewModel {
    
    /*
     * Api request initialization method
     */
    private func fetchTransfersList() {
        
        notification(.Loading)
        
        transferService.fetchTranfers { [weak self] (result) in
            switch result {
            case .success(let transfers):
                self?.prepareTransferEntities(transfers)
                self?.notification(.Success)
                
            case .failure( _):
                /*
                 * If invalid response check if internet connection is stable
                 * then clear local cache and throw error message
                 */
                if self?.reachability.isConnectedToNetwork() == false {
                    self?.loadCachedData(.Offline)
                    return
                }
                self?.clearTransfersCache()
                self?.notification(.Error)
                break
            }
        }
    }
    
    private func prepareTransferEntities(_ transfers: Transfers) {
        /*
         * Clears Transfers data and reset local storage
         * This is must to avoid duplicate entries
         */
        clearTransfersCache()
        for transfer in  transfers.transferList {
            let transferEntity = transfer.managedObject()
            transferEntities.append(transferEntity)
        }
        transfersCacheHandler.cacheTransferEntity(transferEntities)
    }
    
    private func loadCachedData(_ failureState: State) {
        transferEntities = transfersCacheHandler.getCachedTransfers()
        if (transferEntities.count == 0) {
            notification(failureState)
        } else {
            notification(.Success)
        }
    }
    
    private func clearTransfersCache() {
        /*
         * Make sure to remove entities from transferEntities while clearingCache
         */
        transferEntities.removeAll()
        transfersCacheHandler.clearCache()
    }
}


// MARK: - TableView dataSource provider

extension TransfersViewModel {
    
    /*
     * Returns the transferEntities count
     */
    func numberOfTransfersInSection(_ section: Int) -> Int {
        return transferEntities.count
    }
    
    /*
     * Returns the transferEntity model based on the given index
     */
    func transferAtIndex(_ index: Int, section: Int) -> TransferEntity {
        return transferEntities[index]
    }
    
    /*
     * Allocates and Returns Indicator instance with Symbol and Color for given TransferEntity
     */
    func getIndicator(forTransfer transfer: TransferEntity) -> Indicator {
        guard let type = TransferType.init(rawValue: transfer.type) else {
            fatalError("Invalid transfer type")
        }
        
        var indicator = transfer.indicator
        if indicator != nil {
            return indicator!
        }
        
        switch type {
        case .Debit:
            indicator = Indicator.init("↗", color: .red)
            
        case .Credit:
            indicator = Indicator.init("↙", color: UIColor(red:0.00, green:0.39, blue:0.00, alpha:0.5))
        }
        
        transfer.indicator = indicator
        return indicator!
    }
}

