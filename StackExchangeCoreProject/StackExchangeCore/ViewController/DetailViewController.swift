//
//  DetailViewController.swift
//  StackExchangeApı
//
//  Created by rasim rifat erken on 14.09.2022.
//

import Foundation
import UIKit
import CoreData

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var detailAnswerData : [GetAnsweredItemsData]?
    var detailOfflineData : [Answers]?
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let status = Reach().connectionStatus()
        switch status {
        case .unknown, .offline:
            return detailOfflineData?.count ?? 0
        case .online(.wwan), .online(.wiFi):
            return detailAnswerData?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AnsweredDetailCell", for: indexPath) as? AnsweredByTableCell else {return UITableViewCell()}
        let url : String
        let reputation : String
        let name : String
        let date : String
        let score : String
        
        let status = Reach().connectionStatus()
        switch status {
        case .unknown, .offline:
            let offlineData = detailOfflineData?[indexPath.row]
            
            url = offlineData?.profileImage ?? "https://www.gravatar.com/avatar/17f3cadac7a9f7ab510deb4bacfcaef8?s=256&d=identicon&r=PG,"
            reputation = offlineData?.reputation ?? ""
            name = offlineData?.name ?? ""
            date = offlineData?.date ?? ""
            score = offlineData?.score ?? ""
            
         
        case .online(.wwan), .online(.wiFi):
            let onlineData = detailAnswerData?[indexPath.row]
            url = onlineData?.owner?.profileImage ?? ""
            guard let fakeReputation = onlineData?.owner?.reputation else {return cell}
            reputation = String(fakeReputation)
            name = onlineData?.owner?.displayName ?? ""
            guard let fakeDate = onlineData?.creationDate else { return cell}
            date = String(fakeDate)
            guard let fakeScore = onlineData?.score else { return cell}
            score = String(fakeScore)
        }
        
        cell.setupCellPhoto(withVehiclePhoto: url )
        
        cell.setUpReputation(reputation )
        cell.setUpOwnerName(name )
        cell.setAskedOnDate(date )
        cell.setUpScore(title ?? "")
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 139
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Answered by:"
    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        
        
    }

    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true)
    }
}

