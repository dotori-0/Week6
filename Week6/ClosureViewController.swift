//
//  ClosureViewController.swift
//  Week6
//
//  Created by SC on 2022/08/08.
//

import UIKit

class ClosureViewController: UIViewController {
    
    
    @IBOutlet weak var cardView: CardView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

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
