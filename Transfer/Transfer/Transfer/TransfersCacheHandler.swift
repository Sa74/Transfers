//
//  TransfersCacheModel.swift
//  Transfer
//
//  Created by Sasi Moorthy on 16/03/19.
//  Copyright © 2019 Sasi Moorthy. All rights reserved.
//

import Foundation
import RealmSwift


class TransfersCachehandler {
    
    private var realm = try! Realm()
    
    /*
     * Saves data in realm database
     */
    func cacheTransferEntity(_ transfers: [TransferEntity]) {
        for data in transfers {
            try! realm.write {
                realm.add(data)
            }
        }
    }
    
    /*
     * Retrive data from realm database
     */
    func getCachedTransfers() -> [TransferEntity] {
        return Array(realm.objects(TransferEntity.self))
    }
    
    /*
     * Delete all the data from realm database
     */
    func clearCache() {
        try! realm.write {
            realm.deleteAll()
        }
    }
}


