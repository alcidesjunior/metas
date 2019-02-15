//
//  ViewController.swift
//  Metas
//
//  Created by Alcides Junior on 19/01/19.
//  Copyright © 2019 Alcides Junior. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var goals: Goal = Goal()
    var goalsArray = [Goals]()
    @IBOutlet weak var collectionView: UICollectionView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        print(goalsArray[0].goalTitle!)
        collectionView.delegate = self
        collectionView.dataSource = self
//        collectionView.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        goalsArray = goals.getAll()
//        let quantityActions = goalsArray[4].goalActions?.allObjects as! [GoalActions]
//        print(quantityActions.count)
        collectionView.reloadData()
    }

    @IBAction func editGoal(_ sender: Any) {
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    @objc func editGoal(sender: UIButton){
        print("\(self.goalsArray[sender.tag].goalTitle!)")
    }
    
}
extension ViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return goalsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "goalCell", for: indexPath) as! GoalCollectionViewCell
        
        print(goalsArray[indexPath.item].goalImage!)
        
        cell.goalTitle.text = self.goalsArray[indexPath.item].goalTitle
        cell.goalDate.text = Helper.dateToString(date: self.goalsArray[indexPath.item].goalDate!)
        cell.actionsQuantityLabel.text = "\(String(describing: self.goalsArray[indexPath.item].goalActions!.count))/1000"
        cell.goalImage.image = self.goals.getImage(imgName: goalsArray[indexPath.item].goalImage!)
//        cell
//        cell.goalImage.frame.height
//        cell.editGoalButton.tag = indexPath.item
//        cell.editGoalButton.addTarget(self, action: #selector(editGoal(sender:)), for: .touchUpInside)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.orientation.isLandscape{
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        }
        
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    
}
