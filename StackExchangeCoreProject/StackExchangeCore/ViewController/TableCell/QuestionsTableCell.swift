//
//  AnswerViewModel.swift
//  StackExchangeApı
//
//  Created by rasim rifat erken on 15.09.2022.
//

import UIKit
import PhotosUI


class QuestionsTableCell: UITableViewCell {
    
    var imageService = ImageService()
    var imageRequest: Cancellable?
    
    @IBOutlet weak var ownerName: UILabel!
    
    
    @IBOutlet weak var OwnerImage: UIImageView!
    

    @IBOutlet weak var reputation: UILabel!
    
    @IBOutlet weak var askedOnDate: UILabel!
    
    @IBOutlet weak var questionTitle: UILabel!
    

   
 

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setUpOwnerName(_ data: String) {
        ownerName.numberOfLines = 0
        ownerName.numberOfLines = 0
        ownerName.lineBreakMode = .byWordWrapping
        
        self.ownerName.text = data
      
    }
    func setAskedOnDate(_ data: String) {
        
        
        askedOnDate.numberOfLines = 0
        askedOnDate.numberOfLines = 0
        askedOnDate.lineBreakMode = .byWordWrapping
        
        self.askedOnDate.text = data
        

    }
    func setUpReputation(_ data: String) {
        
        reputation.numberOfLines = 0
        reputation.numberOfLines = 0
        reputation.lineBreakMode = .byWordWrapping
        
        
        self.reputation.text = data

    }
    func setUpQuestionTitle(_ data: String) {
        
        questionTitle.numberOfLines = 0
        questionTitle.numberOfLines = 0
        questionTitle.lineBreakMode = .byWordWrapping
        
        self.questionTitle.text = data
        

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
