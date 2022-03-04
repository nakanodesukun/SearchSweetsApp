//
//  CoustomeCell.swift
//  SearchSweetsApp
//
//  Created by 中野翔太 on 2022/03/04.
//

import UIKit
class CustomCell: UITableViewCell {
    @IBOutlet private weak var titleImage: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    // IBOutletをカプセル化したいのでメソッドを作る
    func coufiureImage(imageData: UIImage) {
        titleImage.image = imageData
    }
    func configureTitle(titleName: String) {
        titleLabel.text = titleName
    }
}
