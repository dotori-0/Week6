//
//  CardCollectionViewCell.swift
//  Week6
//
//  Created by SC on 2022/08/09.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cardView: CardView!

    // 변경되지 않는 UI
    override func awakeFromNib() {  // 타입 메서드가 아니라 인스턴스 메서드로
        super.awakeFromNib()
        setupUI()
    }
    
    // 셀이 생성될 때만 실행되고, 재사용될 때는 실행 X
    // cellForRowAt보다 먼저 동작
    func setupUI() {
        cardView.backgroundColor = .clear
        cardView.imageView.backgroundColor = .lightGray
        cardView.imageView.layer.cornerRadius = 10
        cardView.likeButton.tintColor = .systemPink
    }

}
