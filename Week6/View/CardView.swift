//
//  CardView.swift
//  Week6
//
//  Created by SC on 2022/08/09.
//

import UIKit

/*
 xml Interface Builder
 애플에서 엄청 권장하는 사항은 아니지만 재사용성 때문에 많이 쓰인다
 
 1. UIView Custom Class
 2. File's Owner -> 자유도와 확장성이 더 높다
 */


/*
 View: 인터페이스 빌더를 통해 UI 구현 <-> 코드로만 UI 구현
 - 인터페이스 빌더를 통해 UI 초기화 구문: required init?
    - 프로토콜 내에 초기화 구문을 쓸 수 있다: required > 초기화 구문이 프로토콜로 명세되어 있다는 것을 얘기해 준다 (SuperClass의 init과 구분)
 - 코드로만 UI 구현 초기화 구문: override init
 */


protocol A {
    func example()
    init()
}

class CardView: UIView {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var contentLabel: UILabel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        let view = UINib(nibName: "CardView", bundle: nil).instantiate(withOwner: self).first as! UIView  // first: xib 파일에 뷰가 여러개일 수 있으므로
        // 권장은 한 xib에 뷰 1 개
        view.frame = bounds  // CardView라고 하는 파일이 가지고 있는 크기를 모서리랑 똑같이 그대로 맞춰주는 작업
        view.backgroundColor = .lightGray  // 공통적 요소는 여기에서 해도 가능하다 (그림자 등)
        self.addSubview(view)  // 초기화할 때 파일 오너에 추가
    }
    
}


