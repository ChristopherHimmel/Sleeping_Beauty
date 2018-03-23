//
//  SleepTableViewCell.swift
//  SleepingBeauty
//
//  Created by Jane Appleseed on 11/15/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

class SleepTableViewCell: UITableViewCell {
    
    //MARK: Properties
    @IBOutlet weak var hoursOverUnderLabel: UILabel!
    @IBOutlet weak var entryTimeStamp: UILabel!
    //    @IBOutlet weak var photoImageView: UIImageView!
//    @IBOutlet weak var ratingControl: RatingControl!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
