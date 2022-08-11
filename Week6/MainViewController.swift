//
//  MainViewController.swift
//  Week6
//
//  Created by SC on 2022/08/09.
//

import UIKit

import Kingfisher

/*
 tableView - collectionView > 프로토콜
 */

/*
 awakeFromNib    - 셀 UI 초기화, 재사용 매커니즘에 의해 일정 횟수 이상 호출되지 않음
 cellForItemAt   - 재사용될 때마다, 사용자에게 보일 때마다 호출됨
                 - 화면과 데이터는 별개이기 때문에, 모든 indexPath.item에 대한 조건이 없다면 재사용 시 오류가 발생할 수 있음
 prepareForReuse - 셀이 재사용될 때 초기화 하고자 하는 값을 넣으면 오류를 해결할 수 있음.
                   즉, cellForRowAt에서 모든 indexPath.item에 대한 조건을 처리하지 않아도 됨!
 
 CollectionView in TableView
    - 하나의 컬렉션뷰나 테이블 뷰라면 문제 X
    - 컬렉션뷰 안에 테이블뷰, 테이블뷰 안에 컬렉션 뷰 등 복합적인 구조라면, 테이블셀도 재사용되어야 하고 컬렉션셀도 재사용되어야 함
    - Index > reloadData
 
 - print, Debug
 */

class MainViewController: UIViewController {

    @IBOutlet weak var bannerCollectionView: UICollectionView!
    @IBOutlet weak var mainTableview: UITableView!
    
    let color: [UIColor] = [.systemMint, .systemIndigo, .yellow, .systemGreen, .black]
    let numberList: [[Int]] = [
        [Int](100...110),
        [Int](55...75),
        [Int](5000...5006),
        [Int](51...60),
        [Int](61...70),
        [Int](71...75),
        [Int](81...90)
    ]
    
    var episodeList: [[String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bannerCollectionView.dataSource = self
        bannerCollectionView.delegate = self
        bannerCollectionView.register(UINib(nibName: "CardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CardCollectionViewCell")
        
        bannerCollectionView.collectionViewLayout = collectionviewLayout()
        bannerCollectionView.isPagingEnabled = true  // device width 기준으로 움직임
        
        mainTableview.dataSource = self
        mainTableview.delegate = self
        
        TMDBAPIManager.shared.requestImage() { stillPaths in
            dump(stillPaths)
            // 1. 네트워크 통신   2. 배열 생성(episodeList)   3. 배열에 담기
            // 4. 뷰에 표현 (ex. 테이블뷰 섹션, 컬렉션 뷰 셀)
            // 5. 뷰 갱신!
            self.episodeList = stillPaths
            self.mainTableview.reloadData()
        }
    }
    
}


extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return episodeList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // 내부 매개변수 tableView를 통해 테이블뷰를 특정
    // 테이블뷰 객체가 하나일 경우에는 내부 매개변수를 활용하지 않아도 문제가 생기지 않는다
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 참고: 내부 매개변수 tableView, indexPath 등은 바꿔서 사용할 수 있다 (왠만하면 바꾸지 않음)
        print("🍑 MainViewController", #function, indexPath)
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as? MainTableViewCell else {
            print("Cannot find MainTableViewCell")
            return UITableViewCell()
        }
        cell.backgroundColor = .systemIndigo
        cell.titleLabel.text = TMDBAPIManager.shared.tvList[indexPath.section].0
        cell.contentCollectionView.backgroundColor = .yellow
        cell.contentCollectionView.dataSource = self
        cell.contentCollectionView.delegate = self
//        print(#function, "태그 지정")
        cell.contentCollectionView.tag = indexPath.section  // Tag: UIView의 프로퍼티
        cell.contentCollectionView.register(UINib(nibName: "CardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CardCollectionViewCell")
        cell.contentCollectionView.reloadData()  // Index out of range 해결
        // 컬렉션뷰셀의 갯수가 적어서 디바이스에서 한 번에 볼 수 있는 경우라면 재사용에 해당하지 않기 때문에 index out of range 문제가 발생하지 않을 수 있다
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return indexPath.section == 3 ? 350 : 190
//        return UITableView.automaticDimension
        return 290
    }
}


// 하나의 프로토콜과 메서드에서 여러 컬렉션뷰의 datasource, delegate 구현해야 함
extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == bannerCollectionView ? color.count : episodeList[collectionView.tag].count
    }
    
    // collectionView에 bannerCollectionView가 들어올 수도 있고, 테이블뷰 안에 들어있는 컬렉션뷰가 들어올 수도 있다
    // 내부 매개변수가 아닌 명확한 아웃렛을 사용할 경우, 셀 재사용 시 특정 collectionView의 셀을 재사용하게 될 수 있음 주의!
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("🍑 MainViewController", #function, indexPath)
        
        // 여기에서 bannerCollectionView.dequeueReusableCell...을 하면,
        // 재사용하는 셀을 무조건 bannerCollectionView에서 가져오게 된다
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCollectionViewCell", for: indexPath) as? CardCollectionViewCell else {
            print("Cannot find CardCollectionViewCell")
            return UICollectionViewCell()
        }
        
        if collectionView == bannerCollectionView {
            cell.cardView.imageView.backgroundColor = color[indexPath.item]
        } else {
//            cell.cardView.imageView.backgroundColor =  collectionView.tag.isMultiple(of: 2) ? .systemGreen : .brown  // 왔다갔다 할 때마다 셀 컬러가 이상하기 때문에, 셀의 재사용을 잘 고려해야 한다
            cell.cardView.imageView.backgroundColor = .systemGreen
            cell.cardView.contentLabel.textColor = .white
            
            let url = URL(string: "\(TMDBAPIManager.shared.imageURL)\(episodeList[collectionView.tag][indexPath.item])")
            cell.cardView.imageView.kf.setImage(with: url)
//            if indexPath.item < 2 {
////              print(#function, "태그 불러오기")
//                cell.cardView.contentLabel.text = "\(numberList[collectionView.tag][indexPath.item])"
//            }
//            else {
//                cell.cardView.contentLabel.text = "🍋"
//            }
            
//            print(#function, "태그 불러오기")
//            cell.cardView.contentLabel.text = "\(numberList[collectionView.tag][indexPath.item])"
            
            cell.cardView.backgroundColor = .black
        }
        
        
        return cell
    }
    
    func collectionviewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: bannerCollectionView.frame.height)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        return layout
    }
}



