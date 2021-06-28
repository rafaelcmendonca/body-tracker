//
//  Medida.swift
//  BodyTracker
//
//  Created by Administrator on 18/01/20.
//  Copyright © 2020 RafaelCM. All rights reserved.
//

import Foundation

import CoreData

public class Medida:NSManagedObject, Identifiable {
    @NSManaged public var createdAt:Date?
    @NSManaged public var bmi:NSNumber?
    @NSManaged public var bodyAge:NSNumber?
    @NSManaged public var fat:NSNumber?
    @NSManaged public var muscle:NSNumber?
    @NSManaged public var rmkcal:NSNumber?
    @NSManaged public var visceral:NSNumber?
    @NSManaged public var weight:NSNumber?
    @NSManaged public var delta:NSNumber?
}

extension Medida {
    static func getAllMedidasDescending() -> NSFetchRequest<Medida>{
        let request: NSFetchRequest<Medida> = Medida.fetchRequest() as! NSFetchRequest<Medida>
        let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        
        return request
    }
    static func getAllMedidasAscending() -> NSFetchRequest<Medida>{
        let request: NSFetchRequest<Medida> = Medida.fetchRequest() as! NSFetchRequest<Medida>
        let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        return request
    }
}
