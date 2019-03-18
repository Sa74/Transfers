//
//  TransferDetailViewModel.swift
//  Transfer
//
//  Created by Sasi Moorthy on 16/03/19.
//  Copyright © 2019 Sasi Moorthy. All rights reserved.
//

import Foundation

/*
 * TransferDetail model class for TransferDetail view
 * defines transfer data to be displayed on detailed screen
 */
class TransferDetail {
    
    let transferDescription: String
    let accountHolderName: String
    let sentTitle: String
    let sentAmount: String
    let receivedTitle: String
    let receivedAmount: String
    let dateTitle: String
    let date: String
    let exchangeRateTitle: String
    let exchangeRate: String
    let referenceTitle: String
    let reference: String
    
    init(_ transfer: TransferEntity) {
        
        /*
         * Credit / Debit will be evaluated by validating Transfer Type
         * Transfer description and money transfer flow statement will be phrased
         */
        
        guard let transferType = TransferType.init(rawValue: transfer.type) else {
            fatalError("Invalid transfer type")
        }
        
        switch transferType {
        case .Debit:
            /*
             * Debit will be phrased as 'to' in description
             */
            self.transferDescription = "Your transfer #\(transfer.id) to"
            self.sentTitle = "You sent"
            self.receivedTitle = "\(transfer.accountHolderName.uppercased()) received"
            
        case .Credit:
            /*
             * Credit will be phrased as 'from' in description
             */
            self.transferDescription = "Your transfer #\(transfer.id) from"
            self.sentTitle = "\(transfer.accountHolderName.uppercased()) sent"
            self.receivedTitle = "You received"
        }
        
        self.accountHolderName = transfer.accountHolderName.uppercased()
        self.sentAmount = "\(transfer.sentAmount) \(transfer.sentCurrency)"
        self.receivedAmount = "\(transfer.receivedAmount) \(transfer.receivedCurrency)"
        self.dateTitle = "Should have arrived on"
        self.date = transfer.date
        self.exchangeRateTitle = "Exchange rate"
        self.exchangeRate = "1 \(transfer.sentCurrency) → \(transfer.exchangeRate) \(transfer.receivedCurrency)"
        self.referenceTitle = "Reference"
        self.reference = transfer.remarks
    }
}


/*
 * TransferDetailViewModel for TransferDetailViewController & TransferDetail Model
 * Create TransferDetail model from Transfer model data to be displayed on detailed screen
 * Provides tableView dataSource from TransferDetail model
 */
class TransferDetailViewModel {
    
    private let transfer: TransferEntity
    let transferDetail: TransferDetail
    
    init(_ transfer: TransferEntity) {
        self.transfer = transfer
        self.transferDetail = TransferDetail.init(transfer)
    }
    
}
