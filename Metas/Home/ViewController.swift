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
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowx(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHidex(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        searchBar.delegate = self
//        searchBar.butt

    }
    
//    @objc func keyboardWillShowx(notification: NSNotification){
//        searchBar.showsCancelButton = true
//        self.navigationController?.setNavigationBarHidden(true, animated: true)
//    }
//    @objc func keyboardWillHidex(notification: NSNotification){
//        searchBar.showsCancelButton = false
//        self.navigationController?.setNavigationBarHidden(false, animated: true)
//        view.endEditing(true)
//    }
    
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
extension ViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return filterdGoals.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "goalCell", for: indexPath) as! GoalCollectionViewCell
        
        cell.goalTitle.text = self.filterdGoals[indexPath.item].goalTitle
        cell.goalDate.text = Helper.dateToString(date: self.filterdGoals[indexPath.item].goalDate!)
        cell.actionsQuantityLabel.text = "\(String(describing: self.filterdGoals[indexPath.item].goalActions!.count))/1000"
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
