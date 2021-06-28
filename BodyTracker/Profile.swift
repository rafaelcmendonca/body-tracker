//
//  Profile.swift
//  BodyTracker
//
//  Created by Administrator on 20/01/20.
//  Copyright © 2020 RafaelCM. All rights reserved.
//

import Foundation


import CoreData
import SwiftUI

public class Profile:NSManagedObject, Identifiable {
    @NSManaged public var pesoinicial:NSNumber?
    @NSManaged public var pesometa:NSNumber?
    
}

extension Profile {
    
    static func getProfile() -> NSFetchRequest<Profile>{
        let request: NSFetchRequest<Profile> = Profile.fetchRequest() as! NSFetchRequest<Profile>
        request.sortDescriptors = []
        return request
    }
    static func getCurrentPesoInicial() -> Double{
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request: NSFetchRequest<Profile> = Profile.fetchRequest() as! NSFetchRequest<Profile>
        do{
            let result = try context.fetch(request)
//  ******* Below is just for troubleshooting *******
//            var number = 0
//            for item in result{
//                print("Registro: \(number)")
//                print("PesoInicial: \(item.pesoinicial!)")
//                print("PesoMeta: \(item.pesometa!)")
//                print("***********")
//                number = number + 1
//            }
//  ****** End of Troubleshooting *********
            if result.count > 0 {
                return Double(truncating: result.last!.pesoinicial!)
            }
        } catch {
            print("Failed")
        }
        return 0
    }
    
    static func getCurrentPesoMeta() -> Double{
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request: NSFetchRequest<Profile> = Profile.fetchRequest() as! NSFetchRequest<Profile>
        do{
            let result = try context.fetch(request)
            if result.count > 0 {
                return Double(truncating: result.last!.pesometa!)
            }
        } catch {
            print("Failed")
        }
        return 0
    }
}


struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
