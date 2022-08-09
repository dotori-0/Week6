//
//  MainViewController.swift
//  Week6
//
//  Created by SC on 2022/08/09.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var bannerCollectionView: UICollectionView!
    @IBOutlet weak var mainTableview: UITableView!
    
    let color: [UIColor] = [.systemMint, .systemIndigo, .yellow, .systemGreen, .black]
    let numberList: [[Int]] = [
        [Int](100...110),
        [Int](55...65),
        [Int](5000...5006),
        [Int](61...70),
        [Int](71...80),
        [Int](81...90)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bannerCollectionView.dataSource = self
        bannerCollectionView.delegate = self
        bannerCollectionView.register(UINib(nibName: "CardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CardCollectionViewCell")
        
        bannerCollectionView.collectionViewLayout = collectionviewLayout()
        bannerCollectionView.isPagingEnabled = true  // device width 기준으로 움직임
        
        mainTableview.dataSource = self
        mainTableview.delegate = self
    }
    
}


extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return numberList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as? MainTableViewCell else {
            print("Cannot find MainTableViewCell")
            return UITableViewCell()
        }
        cell.backgroundColor = .yellow
        cell.contentCollectionView.backgroundColor = .systemGray6
        cell.contentCollectionView.dataSource = self
        cell.contentCollectionView.delegate = self
        print(#function, "태그 지정")
        cell.contentCollectionView.tag = indexPath.section
        cell.contentCollectionView.register(UINib(nibName: "CardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CardCollectionViewCell")
        cell.contentCollectionView.reloadData()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return indexPath.section == 3 ? 350 : 190
//        return UITableView.automaticDimension
        return 190
    }
}


// 하나의 프로토콜과 메서드에서 여러 컬렉션뷰의 datasource, delegate 구현해야 함
extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == bannerCollectionView ? color.count : numberList[collectionView.tag].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
            print(#function, "태그 불러오기")
            cell.cardView.contentLabel.text = "\(numberList[collectionView.tag][indexPath.item])"
            
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



