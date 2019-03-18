//
//  TransferDetailViewController.swift
//  Transfer
//
//  Created by Sasi Moorthy on 16/03/19.
//  Copyright © 2019 Sasi Moorthy. All rights reserved.
//

import UIKit

/*
 * Transfer details tableView protocol
 * defines sections and gives title
 */
protocol TransferDetailTableSection {
    static var numberOfSections: Int { get }
    var title: String { get }
    var heightForHeader: CGFloat { get }
}

/*
 * Enum for table section
 * Responds to TableSection protocol to return section title
 */
enum TransferDetails: Int, TransferDetailTableSection {
    case Heading
    case Sent
    case Received
    case Date
    case ExchangeRate
    case Reference
    
    static var numberOfSections: Int {
        return 6
    }
    
    var title: String {
        switch self {
        case .Heading:
            return "Transfer Details"
            
        default:
            return ""
        }
    }
    
    var heightForHeader: CGFloat {
        switch self {
        case .Heading:
            return 40
            
        default:
            return 1
        }
    }
    
}

/*
 * Custom cell for Transfer detail data display
 * Right aligned Two vertical positioned labels
 */
class TransferDetailCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
}


class TransferDetailViewController: UITableViewController {
    /*
     * var property for TransferDetailViewModel instance
     * Should be set by TransferViewController on performSegue
     */
    var transferDetailViewModel: TransferDetailViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Throw fatalError if transferDetailViewModel is not set by TransfersViewController
        guard let _ = transferDetailViewModel else {
            fatalError("Trying to display TransferDetail view without TransferDetailViewModel")
        }
    }
}


// MARK - UITableViewDataSource

extension TransferDetailViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return TransferDetails.numberOfSections
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TransferDetailCell", for: indexPath) as? TransferDetailCell else {
            fatalError("Invalid transfer detail cell")
        }
        
        let transferDetail = transferDetailViewModel!.transferDetail
        guard let detailSection = TransferDetails.init(rawValue: indexPath.section) else {
            fatalError("Invalid details section")
        }
        
        switch detailSection {
        case .Heading:
            cell.titleLabel.text = transferDetail.transferDescription
            cell.detailLabel.text = transferDetail.accountHolderName
            
        case .Sent:
            cell.titleLabel.text = transferDetail.sentTitle
            cell.detailLabel.text = transferDetail.sentAmount
            
        case .Received:
            cell.titleLabel.text = transferDetail.receivedTitle
            cell.detailLabel.text = transferDetail.receivedAmount
            
        case .Date:
            cell.titleLabel.text = transferDetail.dateTitle
            cell.detailLabel.text = transferDetail.date
            
        case .ExchangeRate:
            cell.titleLabel.text = transferDetail.exchangeRateTitle
            cell.detailLabel.text = transferDetail.exchangeRate
            
        case .Reference:
            cell.titleLabel.text = transferDetail.referenceTitle
            cell.detailLabel.text = transferDetail.reference
        }
        
        return cell
    }
}


// MARK - UITableViewDelegate

extension TransferDetailViewController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let transferDetailSection = TransferDetails.init(rawValue: section) else {
            fatalError("Invalid section")
        }
        return transferDetailSection.title
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let transferDetailSection = TransferDetails.init(rawValue: section) else {
            fatalError("Invalid section")
        }
        return transferDetailSection.heightForHeader
    }
    
    /*
     * Override willDsiplayHeaderView to update Section Title font
     */
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let transferDetailSection = TransferDetails.init(rawValue: section) else {
            fatalError("Invalid section")
        }
        switch transferDetailSection {
        case .Heading:
            /*
             * If section is Heading then keep bigger font with blue color
             */
            guard let header = view as? UITableViewHeaderFooterView else {
                fatalError("Invalid Table HeaderFooterView")
            }
            header.textLabel?.font = UIFont.boldSystemFont(ofSize: 20)
            header.textLabel?.textColor = .blue
            
        default:
            break
        }
    }
}


