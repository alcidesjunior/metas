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
    //add new Goal
    func add(goal: GoalStruct)->Bool{
        if let goalEntity = NSEntityDescription.insertNewObject(forEntityName: "Goals", into: self.context!) as? Goals{
            //formatando String para Date
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            let date = formatter.date(from: goal.goalDate)
            
//            goalEntity.goalId = String(NSDate().timeIntervalSince1970)
            goalEntity.setValue(goal.goalId, forKey: "goalId")
            goalEntity.setValue(goal.goalTitle, forKey: "goalTitle")
            /*
             lembrando que a imagem tem que salvar no FILEMANEGER e pegar a referencia
             e salvar aqui.
             No goal.goalImage vai vir uma UIImage e tem que salvar.
             */
            goalEntity.setValue("default.jpg", forKey: "goalImage")
            goalEntity.setValue(date, forKey: "goalDate")
            
            //inserindo actions
            
                for currentAction in goal.goalActions{
                    print(currentAction.title)
                    if let actionEntity = NSEntityDescription.insertNewObject(forEntityName: "GoalActions", into: self.context!) as? GoalActions{
                        actionEntity.setValue(String(NSDate().timeIntervalSince1970), forKey: "goalActionId")
                        actionEntity.setValue(currentAction.title, forKey: "actionTitle")
                        actionEntity.setValue(goalEntity, forKey: "goal")
                    }
//                    try? context!.save()
                }
//            }
           
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
