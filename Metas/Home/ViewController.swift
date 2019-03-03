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
    var goalsData = [Goals]()
    var filterdGoals = [Goals]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        let tagGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(gestureRecognizer:)))
        
        view.addGestureRecognizer(tagGesture)
        //setando label para o button cancel da search bar
        searchBar.setValue("Cancelar", forKey:"_cancelButtonText")
        
        searchBar.delegate = self
//        searchBar.butt

    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer){
        view.endEditing(true)
    }
    override func viewDidAppear(_ animated: Bool) {
        goalsData = goals.getAll()
        filterdGoals = goalsData
        collectionView.reloadData()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    @objc func editGoal(sender: UIButton){
        print("\(self.goalsData[sender.tag].goalTitle!)")
    }
    
}
extension ViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, CellDelegate{
    func doneTaped(_ cell: GoalCollectionViewCell) {
        let indexPath = self.collectionView.indexPath(for: cell)
//        print("Concluir ",indexPath?.item)
    }
    
    func editTaped(_ cell: GoalCollectionViewCell) {
        let indexPath = self.collectionView.indexPath(for: cell)
        
        if let newGoalViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "newGoalViewController") as? NewGoalViewController{
            if let navigator = navigationController{
                if let index = indexPath?.item {
                    guard let goalID = self.filterdGoals[index].goalId else{
                       return
                    }
                    newGoalViewController.indexGoals = goalID
                    navigator.pushViewController(newGoalViewController, animated: true)
                }
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return filterdGoals.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "goalCell", for: indexPath) as! GoalCollectionViewCell
        cell.delegate = self
        
        cell.goalTitle.text = self.filterdGoals[indexPath.item].goalTitle
        cell.goalDate.text = Helper.dateToString(date: self.filterdGoals[indexPath.item].goalDate!)
        cell.actionsQuantityLabel.text = "0/\(String(describing: self.filterdGoals[indexPath.item].goalActions!.count))"
        cell.goalImage.image = self.goals.getImage(imgName: filterdGoals[indexPath.item].goalImage!)
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.orientation.isLandscape{
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        }
        
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    
}
extension ViewController: UISearchBarDelegate{
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        searchBar.text = ""
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterdGoals = searchText.isEmpty ? goalsData : goalsData.filter({ (dataString: Goals) -> Bool in
            return dataString.goalTitle!.range(of: searchText, options: .caseInsensitive) != nil
        })
        collectionView.reloadData()
    }
}
