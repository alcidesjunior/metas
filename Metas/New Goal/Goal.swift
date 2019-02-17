//
//  Goal.swift
//  Metas
//
//  Created by Alcides Junior on 08/02/19.
//  Copyright © 2019 Alcides Junior. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Goal: NSObject{
    /*implementar o coredata pra isso daqui taokey?*/
    var context: NSManagedObjectContext?
    
    override init(){
        self.context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    func getDirectoryPath() -> NSURL {
        let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("goalsImage")
        let url = NSURL(string: path)
        return url!
    }
    //save image
    private func saveImage(img: UIImage, imgName: String){
        let fileManager = FileManager.default
        let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("goalsImage")
        if !fileManager.fileExists(atPath: path){
            try! fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        }
        let url = NSURL(string: path)
        let imagePath = url!.appendingPathComponent(imgName)
        let urlString: String = imagePath!.absoluteString
        let imageData = img.jpegData(compressionQuality: 0.5)
        fileManager.createFile(atPath: urlString as String, contents: imageData, attributes: nil)
    }
    //get image
    func getImage(imgName: String)->UIImage{
        let fileManager = FileManager.default
        let imagePath = (self.getDirectoryPath() as NSURL).appendingPathComponent(imgName)
        let urlString: String = imagePath!.absoluteString
        if fileManager.fileExists(atPath: urlString) {
            if let image = UIImage(contentsOfFile: urlString){
                return image
            }
            return UIImage(named: "default.jpg")!
        } else {
            // print("No Image")
            return UIImage(named: "default.jpg")!
        }
    }
    //add a new goal on core data
    func add(goal: GoalStruct)->Bool{
        if let goalEntity = NSEntityDescription.insertNewObject(forEntityName: "Goals", into: self.context!) as? Goals{
            //formatando String para Date
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            let date = formatter.date(from: goal.goalDate)
        
            goalEntity.setValue(goal.goalId, forKey: "goalId")
            goalEntity.setValue(goal.goalTitle, forKey: "goalTitle")
            let imageNamed = "\(UUID().uuidString).jpg"
            //salvando imagem
            saveImage(img: goal.goalImage, imgName: imageNamed)
            goalEntity.setValue(imageNamed, forKey: "goalImage")
            goalEntity.setValue(date, forKey: "goalDate")
            
            //inserindo actions
                for currentAction in goal.goalActions{
                    print(currentAction.title)
                    if let actionEntity = NSEntityDescription.insertNewObject(forEntityName: "GoalActions", into: self.context!) as? GoalActions{
                        actionEntity.setValue(String(NSDate().timeIntervalSince1970), forKey: "goalActionId")
                        actionEntity.setValue(currentAction.title, forKey: "actionTitle")
                        actionEntity.setValue(goalEntity, forKey: "goal")
                    }
                }
           
                try? context!.save()
                return true
            
        }
        return false
    }
    func getAll()->[Goals]{
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Goals")
        request.sortDescriptors = [NSSortDescriptor.init(key: "goalId", ascending: true)]
        do{
            let goals = try context!.fetch(request) as! [Goals]
            return goals
        }catch{
            fatalError("Error \(error)")
        }
    }
}
