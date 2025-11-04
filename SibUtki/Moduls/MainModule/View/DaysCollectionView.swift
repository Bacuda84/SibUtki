//
//  DaysCollectionViewController.swift
//  SibUtki
//
//  Created by Bakhtovar Akhmedov on 01.11.2025.
//

import UIKit

private let reuseIdentifier = "Cell"

//MARK: - DaysCollectionViewProtocol -
protocol DaysCollectionViewProtocol {
    func selected(_ date: Date)
}

class DaysCollectionView: UICollectionView {
    
    var ourDelegate: DaysCollectionViewProtocol!
    
    let days = ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"]
    var weekPlus = 0 //- это +(-)
    var selectedIndexPath: IndexPath?

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.register(DayCell.self, forCellWithReuseIdentifier: "DayCell")
        self.dataSource = self
        self.delegate = self
        self.isScrollEnabled = false
        setGestures()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - UISwipeGestureRecognizer -
    private func setGestures() {
        let leftGesture  = UISwipeGestureRecognizer(target: self, action: #selector(plusWeek))
        let rightGesture = UISwipeGestureRecognizer(target: self, action: #selector(minusWeek))
        
        leftGesture.direction = .left
        rightGesture.direction = .right

        addGestureRecognizer(leftGesture)
        addGestureRecognizer(rightGesture)
    }
    
    @objc func minusWeek() {
        weekPlus -= 1
        reloadData()
    }
    
    @objc func plusWeek() {
        weekPlus += 1
        reloadData()
    }
    
    func changeOurDay(To plus: Int) {
        guard let path = selectedIndexPath else { return }
        let newIndexPath = IndexPath(item: path.item+plus, section: 0)
        switch path.item+plus {
        case -1:  //простая логика смены дней/недель
            minusWeek()
            selectedIndexPath = IndexPath(item: 6, section: 0)
            collectionView(_: self, didSelectItemAt: selectedIndexPath!)
        case 7:
            plusWeek()
            selectedIndexPath = IndexPath(item: 0, section: 0)
            collectionView(_: self, didSelectItemAt: selectedIndexPath!)

        default:
            selectItem(at: newIndexPath, animated: false, scrollPosition: .left)
            collectionView(_: self, didSelectItemAt: newIndexPath)
        }
    }
    
    //MARK: - функция с высчитыванием всех дней -
    func daysForWeek() -> [Date] {
        var result = [Date]()
        let calendar = Calendar.current
        guard let ourMonday = calendar.dateInterval(of: .weekOfYear, for: Date())?.start else { return [] }
        guard let needingMonday = calendar.date(byAdding: .weekOfYear, value: weekPlus, to: ourMonday) else { return [] }
        for i in 0..<7 {
            result.append(calendar.date(byAdding: .day, value: i, to: needingMonday)!)
        }
        return result
    }
}

//MARK: - UICollectionViewDataSource -
extension DaysCollectionView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 7
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DayCell", for: indexPath) as? DayCell else { return UICollectionViewCell() }
        let neenigDays = daysForWeek()
        cell.configure(days[indexPath.item], date: neenigDays[indexPath.item])
        if indexPath.item == selectedIndexPath?.item {
            cell.selected()
        } else {
            cell.unSelect()
        }
        
        return cell
    }
}

//MARK: - UICollectionViewDelegate -
extension DaysCollectionView: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let previous = selectedIndexPath
        selectedIndexPath = indexPath

        var indexPathsToReload = [indexPath]
        if let previous = previous, previous != indexPath {
            indexPathsToReload.append(previous)
        }

        collectionView.reloadItems(at: indexPathsToReload)
        let date = daysForWeek()[indexPath.row]

        ourDelegate.selected(date)
    }

}

//MARK: - SwipeDayDelegate -
extension DaysCollectionView: SwipeDayDelegate {
    func getCurrentDay() -> Date? {
        if let path = selectedIndexPath {
            return daysForWeek()[path.item]
        }
        return nil
    }
    
    func plusDay() {
        changeOurDay(To: 1)
    }
    
    func minusDay() {
        changeOurDay(To: -1)

    }
}


