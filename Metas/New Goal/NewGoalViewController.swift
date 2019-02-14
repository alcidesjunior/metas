//
//  NewGoalViewController.swift
//  Metas
//
//  Created by Alcides Junior on 01/02/19.
//  Copyright © 2019 Alcides Junior. All rights reserved.
//

import UIKit
//struct ActionStruct{
// var action: String
//}
class NewGoalViewController: UIViewController {

    @IBOutlet weak var imageCover: UIImageView!
    @IBOutlet weak var goalTxt: UITextField!
    @IBOutlet weak var finalDateTxt: UITextField!
    @IBOutlet weak var actionTxt: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var constraintContentHeight: NSLayoutConstraint!
    
    @IBOutlet weak var tableActions: UITableView!
    var activeField: UITextField?
    var lastOffSet: CGPoint!
    var keyboardHeight: CGFloat!
    var imagePicker = UIImagePickerController()
    var goal = GoalStruct(goalId: "", goalImage: UIImage(), goalTitle: "", goalDate: "", goalActions: [Action.init(title: "")])
    
    private var datePicker: UIDatePicker?
    
    var actions = [Action]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        goalTxt.delegate = self
        finalDateTxt.delegate = self
        actionTxt.delegate = self
        imageCover.clipsToBounds = true
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(dateChanged(datePicker:)), for: .valueChanged)
        finalDateTxt.inputView = datePicker
        
        tableActions.delegate = self
        tableActions.dataSource = self
        tableActions.tableFooterView = UIView()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        self.contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(returnTextView(gesture:))))
        let tagGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(gestureRecognizer:)))
        
        view.addGestureRecognizer(tagGesture)

    }
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer){
        view.endEditing(true)
    }
    @objc func dateChanged(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        finalDateTxt.text = dateFormatter.string(from: datePicker.date)
    }
    
    @objc func returnTextView(gesture: UIGestureRecognizer) {
        guard activeField != nil else {
            return
        }
        
        activeField?.resignFirstResponder()
        activeField = nil
    }
    
    @IBAction func newActionBtn(_ sender: Any) {
        if let actionText = self.actionTxt.text{
            //validar isso daqui!!!
            if actionText != ""{
            actions.append(Action.init(title: actionText))
            tableActions.reloadData()
                actionTxt.text = ""
            }
        }else{
            print("alert nao rola vazio")
        }
    }
    private func getInputs(){
        self.goal.goalTitle = self.goalTxt.text!
        self.goal.goalDate = self.finalDateTxt.text!
        self.goal.goalId = NSUUID().uuidString
        self.goal.goalActions = self.actions
        self.goal.goalImage = UIImage()
    }
    @IBAction func saveGoal(_ sender: Any) {
        let newGoal = Goal()
        self.getInputs()
        
        if newGoal.add(goal: self.goal){
            print("Meta salva com sucesso!")
        }else{
            print("A meta nao pode ser salva...")
        }
        
    }
}
extension NewGoalViewController: UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeField = textField
        lastOffSet = self.scrollView.contentOffset
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        activeField?.resignFirstResponder()
        activeField = nil
        return true
    }
    @objc func keyboardWillShow(notification: NSNotification){
        if keyboardHeight != nil{
            return
        }
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue{
            keyboardHeight = keyboardSize.height
            
            // so increase contentView's height by keyboard height
            UIView.animate(withDuration: 0.3, animations: {
                self.constraintContentHeight.constant += self.keyboardHeight
            })
        }
        
        // move if keyboard hide input field
        let distanceToBottom = self.scrollView.frame.size.height - (activeField?.frame.origin.y)! - (activeField?.frame.size.height)!
        let collapseSpace = keyboardHeight - distanceToBottom
        // no collapse
        if collapseSpace < 0 {
            return
        }
        // set new offset for scroll view
        UIView.animate(withDuration: 0.3, animations: {
            self.scrollView.contentOffset = CGPoint(x: self.lastOffSet.x, y: collapseSpace + 10)
        })
    }
    @objc func keyboardWillHide(notification: NSNotification){
        UIView.animate(withDuration: 0.3, animations: {
            if self.keyboardHeight != nil{//ver com o Yuri depois
            self.constraintContentHeight.constant -= self.keyboardHeight
                self.scrollView.contentOffset = self.lastOffSet
                
            }
        })
        keyboardHeight = nil
    }
}
extension NewGoalViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    @IBAction func selectImageBtn(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing =  false
            
            self.present(imagePicker, animated: true, completion: nil)
            
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            imageCover.image = img
        }
        self.dismiss(animated: true, completion: nil)
    }
}
extension NewGoalViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableActions.dequeueReusableCell(withIdentifier: "tableActionCell", for: indexPath)
        cell.textLabel?.text = "\(indexPath.item + 1): \(actions[indexPath.item].title)"
        cell.textLabel?.numberOfLines = 0
        return cell
    }    
}
