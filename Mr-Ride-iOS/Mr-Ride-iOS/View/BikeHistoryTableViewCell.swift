//
//  BikeHistoryTableViewCell.swift
//  Mr-Ride-iOS
//
//  Created by Allegretto on 2016/7/9.
//  Copyright © 2016年 AppWorks School Jocy Hsiao. All rights reserved.
//

import UIKit

class BikeHistoryTableViewCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var cellView: UIView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupCell() {
        cellView.backgroundColor = UIColor.mrPineGreen85Color()
        self.backgroundColor = UIColor.clearColor()
        dateLabel.textColor = UIColor.mrWhiteColor()
        recordLabel.textColor = UIColor.mrWhiteColor()
        layoutMargins = UIEdgeInsetsZero
    }

    
}
