//
//  ClosureViewController.swift
//  Week6
//
//  Created by SC on 2022/08/08.
//

import UIKit

class ClosureViewController: UIViewController {

    @IBOutlet weak var cardView: CardView!
    @IBOutlet weak var violetView: UIButton!
    
    // Frame Based
    var sampleButton = UIButton()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 위치, 크기, 추가 코드 (화면에 보이게 하기 위함)
        /*
         오토리사이징을 오토레이아웃 제약조건처럼 설정해 주는 기능이 내부적으로 구현되어 있음
         이 기능은 디폴트가 true, 하지만 오토레이아웃을 지정하면 오토리사이징을 안 쓰겠다는 의미인 false로 상태가 내부적으로 변경됨!
         오토리사이징으로 설정한 값과 오토레이아웃으로 설정한 값이 충돌나기 때문
         코드 기반 레이아웃 UI > true
         인더페이스 빌더 기반 레이아웃 UI > false 
         autoresizing -> autolayout constraints
         */
//        print(sampleButton.autoresizingMask)  // ➕
        print(violetView.translatesAutoresizingMaskIntoConstraints)
        print(sampleButton.translatesAutoresizingMaskIntoConstraints)
        print(cardView.translatesAutoresizingMaskIntoConstraints)
        sampleButton.frame = CGRect(x: 100, y: 400, width: 100, height: 100)
        sampleButton.backgroundColor = .systemGreen
        view.addSubview(sampleButton)

        cardView.imageView.backgroundColor = .red
        cardView.likeButton.backgroundColor = .yellow
        cardView.likeButton.addTarget(self, action: #selector(likeButtonClicked), for: .touchUpInside)  // 액션 연결이 안되니끼
    }
    
    @objc func likeButtonClicked() {
        print("버튼 클릭")
    }
    

    @IBAction func colorPickerButtonClicked(_ sender: UIButton) {
        showAlert(title: "컬러피커를 띄우겠습니까?", message: nil, okTitle: "띄우기") {
            // 컬러피커는 iOS 14부터
            let picker = UIColorPickerViewController()  // UIFontPickerViewController도 가능
            self.present(picker, animated: true)  // 클로저 안에는 self.를 꼭 붙여야 한다
        }
    }
    

    @IBAction func backgroundColorChanged(_ sender: UIButton) {
        showAlert(title: "배경색 변경", message: "배경색을 바꾸시겠습니까?", okTitle: "바꾸기", okAction: {
            self.view.backgroundColor = .gray
        })
    }
}


extension UIViewController {
    // @escaping: 밖에서 실행할 거라고 알려 주는 형태
    func showAlert(title: String, message: String?, okTitle: String, okAction: @escaping () -> ()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let ok = UIAlertAction(title: okTitle, style: .default) { action in
            okAction()
        }
        
        alert.addAction(cancel)
        alert.addAction(ok)
        
        present(alert, animated: true)
    }
}
