//
//  AnswerViewModel.swift
//  StackExchangeApı
//
//  Created by rasim rifat erken on 15.09.2022.
//

import UIKit
import PhotosUI

class AnsweredByTableCell: UITableViewCell {
    
    var imageService = ImageService()
    var imageRequest: Cancellable?
    
    
    @IBOutlet weak var OwnerImage: UIImageView!
    
    
    @IBOutlet weak var answeredOn: UILabel!
    
    
    @IBOutlet weak var scoreGained: UILabel!
    
    @IBOutlet weak var reputation: UILabel!
    
    @IBOutlet weak var OwnerName: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setUpOwnerName(_ data: String) {
        OwnerName.numberOfLines = 0
        OwnerName.numberOfLines = 0
        OwnerName.lineBreakMode = .byWordWrapping
        
        self.OwnerName.text = data
      
    }
    func setAskedOnDate(_ data: String) {
        
        
        answeredOn.numberOfLines = 0
        answeredOn.numberOfLines = 0
        answeredOn.lineBreakMode = .byWordWrapping
        
        self.answeredOn.text = data
        

    }
    func setUpReputation(_ data: String) {
        
        reputation.numberOfLines = 0
        reputation.numberOfLines = 0
        reputation.lineBreakMode = .byWordWrapping
        
        
        self.reputation.text = data

    }
    func setUpScore(_ data: String) {
        
        self.scoreGained.text = data
        

    }
    
    func setupCellPhoto(withVehiclePhoto url : String ) {
        let option = PHImageRequestOptions()

        option.isSynchronous = false
        option.resizeMode = .fast
        option.deliveryMode = .fastFormat
        option.isNetworkAccessAllowed = true
        
        OwnerImage.layer.cornerRadius = OwnerImage.bounds.height / 2.0
        OwnerImage.layer.borderWidth = 0.5
        OwnerImage.layer.borderColor = UIColor.gray.cgColor
        OwnerImage.layer.masksToBounds = true
        OwnerImage.contentMode = .scaleAspectFill

        imageRequest = imageService.image(for: url) { [ weak self] image in
            self?.OwnerImage.image = image
        }
       
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()

        OwnerImage.image = nil
        imageRequest?.cancel()

    }
    
}
