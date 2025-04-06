//
//  BookDetailsTableViewCell.swift
//  MedBook
//
//  Created by Soubhagya on 06/04/25.
//

import UIKit

class BookDetailsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var bookCoverImageView: UIImageView!
    
    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var bookDescriptionLabel: UILabel!
    
    //Rate
    @IBOutlet weak var bookRatingLabel: UILabel!
    
    //Read
    @IBOutlet weak var bookReadingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.backgroundColor = .clear
        self.innerView.backgroundColor = UIColor(hex: "#ECECEC")
        self.innerView.layer.cornerRadius = 5
        self.innerView.clipsToBounds = true
        self.bookTitleLabel.font = .poppinsSemiBold(ofSize: 14)
        self.bookTitleLabel.textAlignment = .left
        self.bookTitleLabel.textColor = .black
        self.bookTitleLabel.numberOfLines = 1
        
        self.bookDescriptionLabel.font = .poppinsRegular(ofSize: 12)
        self.bookDescriptionLabel.textColor = .gray
        self.bookDescriptionLabel.textAlignment = .left
        
        self.bookRatingLabel.font = .poppinsRegular(ofSize: 12)
        self.bookRatingLabel.textColor = .white
        self.bookRatingLabel.backgroundColor = UIColor.systemYellow.withAlphaComponent(0.85)
        self.bookRatingLabel.layer.cornerRadius = 8
        self.bookRatingLabel.clipsToBounds = true
        self.bookRatingLabel.textAlignment = .center
        self.bookRatingLabel.layer.masksToBounds = true
        
        self.bookTitleLabel.textColor = .black
        self.bookReadingLabel.font = .poppinsRegular(ofSize: 12)
        self.bookReadingLabel.textColor = .black
        
        self.bookCoverImageView.layer.cornerRadius = 5
        self.bookCoverImageView.clipsToBounds = true
        self.bookCoverImageView.backgroundColor = .gray
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
