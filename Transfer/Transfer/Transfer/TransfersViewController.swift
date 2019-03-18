//
//  TransfersViewController.swift
//  Transfer
//
//  Created by Sasi Moorthy on 15/03/19.
//  Copyright © 2019 Sasi Moorthy. All rights reserved.
//

import UIKit

/*
 * Custom view to display user friendly messaages
 * Validates State fro ViewModel and updates messages / warnings
 */
class StatusView: UIView {
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var messageLabel: UILabel!
    
    public var state: State = .Loading {
        didSet {
            switch state {
            case .Loading:
                /*
                 * Ongoing netowrk connection. Activity indicator will animate till state change.
                 */
                loadingIndicator.isHidden = false
                loadingIndicator.startAnimating()
                messageLabel.text = "Loading transfers"
                
            case .Error:
                loadingIndicator.isHidden = true
                messageLabel.text = "Unable to fetch data at this moment. Please try again later."
                
            case .Offline:
                loadingIndicator.isHidden = true
                messageLabel.text = "No network connection. Please connect to internet and try again."
                
            case .Success:
                loadingIndicator.stopAnimating()
                messageLabel.text = ""
            }
        }
    }
}


/*
 * Custom cell for Transfer list data display
 */
class TransferCell: UITableViewCell {
    /*
     * Center aligned label for Indicator Symbol display
     * Helps in identifying Transfer type
     */
    @IBOutlet weak var typeIndicatorLabel: UILabel!
    
    /*
     * Right aligned labels for Account Number and Date
     * Positioned vertically to each other with equal width
     */
    @IBOutlet weak var accountNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    /*
     * Left aligned labels for Sent and Received amount
     * Positioned vertically to each other with equal width
     */
    @IBOutlet weak var sentMoneyLabel: UILabel!
    @IBOutlet weak var receivedMoneyLabel: UILabel!
    
}


/*
 * UIVIewController subclass with UITableView
 * Responds to UITableView protocols and displays Transfer list data
 * Operates with TransferViewModel
 * Allows pull to refresh to refresh data
 */
class TransfersViewController: UIViewController {
    
    // public var property for TransferViewModel instance for dependency injection & Unit Testing
    var transferViewModel = TransfersViewModel()
    
    // let private property for UIRefreshControl
    private let refreshControl = UIRefreshControl()
    
    // PullToRefresh call monitor flag to avoid activity indicator display in middle
    private var isPullToRefresh: Bool = false
    // Reference to selectedTransfer to pass on to TransferDetailViewController
    private var selectedTransfer: TransferEntity?
    
    /*
     * IBOutlet properties for TableView and StatusView
     */
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var statusView: StatusView!
    
    //MARK: View Life-Cycle mthods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "TRANSFERS"
        
        /*
         * Validate iOS version since <10,0 doesn't have refreshControl component by default
         * Add subView for lesser versions
         */
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        
        
        /*
         * Set update handler block to TransferViewModel to listen to state changes and update the UI
         */
        transferViewModel.notification  = { [weak self] (state) in
            DispatchQueue.main.async {
                self?.refreshControl.endRefreshing()
                self?.updateDisplayState(state)
            }
        }
        transferViewModel.loadTransfersData()
    }
    
    
    /*
     * Update UI based on given state
     */
    func updateDisplayState(_ state: State) {
        
        statusView.state = state
        
        /*
         * If pulltoRefresh is called then don't display statusView with loading indicator
         * Refresh control will display its activity indicator at the top
         */
        if isPullToRefresh == true &&
            state == .Loading {
            tableView.reloadData()
            return
        }
        
        switch state {
        case.Success:
            /*
             * If Success - Then hide StatusView with simple alpha animation and reload TableView
             */
            UIView.animate(withDuration: 0.5, animations: { [weak self] in
                self?.statusView.alpha = 0
            }) { [weak self] (finished) in
                self?.statusView.isHidden = true
                self?.tableView.reloadData()
            }
            
        default:
            /*
             * If not success - Then display statusView with simple alpha animation and reload tableView. No data will be present in the table
             */
            self.statusView.isHidden = false
            self.tableView.reloadData()
            UIView.animate(withDuration: 0.5, animations: { [weak self] in
                self?.statusView.alpha = 1.0
            })
        }
    }
    
    // PullToRefresh selector method
    @objc private func refreshData(_ sender: Any) {
        /*
         * Set pullToRefresh flag to true and make data fetch call to TransferViewModel
         */
        isPullToRefresh = true
        transferViewModel.loadTransfersData()
    }
}


// MARK - UITableViewDataSource

extension TransfersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transferViewModel.numberOfTransfersInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TransferCell", for: indexPath) as? TransferCell else {
            fatalError("Invalid transfer cell creation")
        }
        
        /*
         * Gets Transfer model instance from TransferViewModel
         * Displays Transfer model data into TransferCell
         */
        let transfer = transferViewModel.transferAtIndex(indexPath.row, section: indexPath.section)
        cell.accountNameLabel.text = transfer.accountHolderName
        cell.dateLabel.text = transfer.date
        cell.sentMoneyLabel.text = "\(transfer.sentAmount) \(transfer.sentCurrency)"
        cell.receivedMoneyLabel.text = "\(transfer.receivedAmount) \(transfer.receivedCurrency)"
        
        /*
         * Gets Indicator model instance from TransferViewModel
         * Denotes Transfer type with Indicator Symbol and Color
         */
        let indicator = transferViewModel.getIndicator(forTransfer: transfer)
        cell.typeIndicatorLabel.text = indicator.symbol
        cell.typeIndicatorLabel.textColor = indicator.color
        
        return cell
    }
}


// MARK - UITableViewDelegate

extension TransfersViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // 1 to reduce default header height
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*
         * Deselect selected row
         * Keep reference to selected Transfer
         * Perform segue to push transferDetailViewController
         */
        tableView.deselectRow(at: indexPath, animated: true)
        selectedTransfer = transferViewModel.transferAtIndex(indexPath.row, section: indexPath.section)
        performSegue(withIdentifier: "TransferDetailSegue", sender: self)
    }
}


// MARK - Prepare Segue

extension TransfersViewController {
    
    /*
     * Prepare transferDetail segue with selectedTransfer
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let transfer = selectedTransfer {
            guard let transferDetailViewController = segue.destination as? TransferDetailViewController else {
                fatalError("Invalid segue transition for TransferDetail")
            }
            transferDetailViewController.transferDetailViewModel = TransferDetailViewModel.init(transfer)
        }
    }
}

