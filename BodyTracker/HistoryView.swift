//
//  HistoryView.swift
//  BodyTracker
//
//  Created by Administrator on 20/01/20.
//  Copyright © 2020 RafaelCM. All rights reserved.
//

import SwiftUI

struct HistoryView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: Medida.getAllMedidasDescending()) var Medidas:FetchedResults<Medida>
    
    
    var body: some View {
            VStack{
                Text("Histórico").font(.largeTitle).shadow(color: getMyColor(), radius: 3)
                List {
                    ForEach (0..<self.Medidas.count) {index in
                        MedidaView(weight: "\(self.Medidas[index].weight!)", bmi: "\(self.Medidas[index].bmi!)", fat: "\(self.Medidas[index].fat!)", muscle: "\(self.Medidas[index].muscle!)", rmkcal: "\(self.Medidas[index].rmkcal!)", bodyAge: "\(self.Medidas[index].bodyAge!)", visceral: "\(self.Medidas[index].visceral!)", createdAt: dateToString(rawDate: self.Medidas[index].createdAt!), delta: self.getDelta(index: index) )
                    }.onDelete {indexSet in
                        let deleteItem = self.Medidas[indexSet.first!]
                        self.managedObjectContext.delete(deleteItem)
                        
                        do {
                            try self.managedObjectContext.save()
                        } catch {
                            print(error)
                        }
                    }
                }
        }
        .onAppear{
            HapticFeedback.playSelection()
        }
    }
    
    func getDelta(index:Int) -> NSNumber {
        if (index < Medidas.count - 1) {
            let last = Medidas[index+1].weight!.doubleValue
            let atual = Medidas[index].weight!.doubleValue
            return NSNumber(value: (atual - last))
        } else {
            return NSNumber(value: 0)
        }
    }
    
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
