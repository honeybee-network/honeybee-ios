//
//  URChallengeDetailTableViewCell.swift
//  honeybee
//
//  Created by Daniel Amaral on 23/05/16.
//  Copyright © 2016 ilhasoft. All rights reserved.
//

import UIKit

class URChallengeDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var lbContent:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        super.selectionStyle = UITableViewCellSelectionStyle.None
    }
    
}
