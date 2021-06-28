//
//  NewMedida.swift
//  BodyTracker
//
//  Created by Administrator on 20/01/20.
//  Copyright © 2020 RafaelCM. All rights reserved.
//

import SwiftUI
import Haptica
import HealthKit

struct NewMedida: View {
    //@Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: Medida.getAllMedidasAscending()) var Medidas:FetchedResults<Medida>
    @Binding var tabIndex:Int
    
    @State private var newBmi = ""
    @State private var newBodyAge = ""
    @State private var newFat = ""
    @State private var newMuscle = ""
    @State private var newRmkcal = ""
    @State private var newVisceral = ""
    @State private var newWeight = ""
    
    var body: some View {
        VStack{
            Spacer()
            Text("Nova Medida").font(.largeTitle).shadow(color: getMyColor(), radius: 3)
            //Spacer()
            
            ScrollView{
                VStack{
                    Group{
                        HStack{
                            Text("Weight")
                            TextField("100 Lbs?", text: self.$newWeight).keyboardType(.decimalPad).font(.title).multilineTextAlignment(.trailing)
                        }
                        Divider()
                        HStack{
                            Text("BMI")
                            TextField("30?", text: self.$newBmi).keyboardType(.decimalPad).font(.title).multilineTextAlignment(.trailing)
                        }
                        Divider()
                        HStack{
                            Text("Body Fat")
                            TextField("25% ?", text: $newFat).keyboardType(.decimalPad).font(.title).multilineTextAlignment(.trailing)
                        }
                        Divider()
                    }
                    Group{
                        HStack{
                            Text("Muscle")
                            TextField("25% ?", text: $newMuscle).keyboardType(.decimalPad).font(.title).multilineTextAlignment(.trailing)
                        }
                        Divider()
                        HStack{
                            Text("RMkCal")
                            TextField("1200 ?", text: $newRmkcal).keyboardType(.decimalPad).font(.title).multilineTextAlignment(.trailing)
                        }
                        Divider()
                        HStack{
                            Text("Body Age")
                            TextField("25 ?", text: $newBodyAge).keyboardType(.decimalPad).font(.title).multilineTextAlignment(.trailing)
                        }
                        Divider()
                        HStack{
                            Text("Visceral")
                            TextField("5% ?", text: $newVisceral).keyboardType(.decimalPad).font(.title).multilineTextAlignment(.trailing)
                        }
                        Divider()
                    }
                }
            }.padding(.horizontal, 20).padding(.top, 30)//.frame(height: 380)
            
            Spacer()
            HStack(alignment: .center){
                Button(action: {
                    let medida = Medida(context: self.managedObjectContext)
                    medida.weight = convertLbsToKg(text: self.newWeight)
                    medida.bmi = self.newBmi.nsNumberValue
                    medida.fat = self.newFat.nsNumberValue
                    medida.muscle = self.newMuscle.nsNumberValue
                    medida.rmkcal = self.newRmkcal.nsNumberValue
                    medida.visceral = self.newVisceral.nsNumberValue
                    medida.bodyAge = self.newBodyAge.nsNumberValue
                    medida.createdAt = Date()
                    
                    if let ultimo = self.Medidas.last?.weight?.floatValue {
                        
                        medida.delta = NSNumber(value:medida.weight!.floatValue - ultimo)
                    } else{
                        medida.delta = 0
                    }
                    
                    do {
                        try self.managedObjectContext.save()
                    } catch {
                        print(error)
                    }
                    self.updateHealthKit()
                    
                    self.newWeight = ""
                    self.newBmi = ""
                    self.newFat = ""
                    self.newMuscle = ""
                    self.newRmkcal = ""
                    self.newBodyAge = ""
                    self.newVisceral = ""
                    
                    Haptic.play("....ooooO-O-O-oooo....", delay: 0.1)
                    self.tabIndex = 0
                    //self.presentationMode.wrappedValue.dismiss()
                }){
                    HStack{
                        Image(systemName: "gauge.badge.plus")
                            .foregroundColor(getMyColor())
                            .padding(15.0)
                            .imageScale(.medium)
                            .font(.largeTitle)
                        Text("Adicionar")
                            .font(.title)
                            .padding(15.0)
                    }.overlay(RoundedRectangle(cornerRadius: 10)
                        .stroke(getMyColor(), lineWidth: 1))
                }.background(getTextFieldColor())
            }
            Spacer()
        }.onAppear{
            HapticFeedback.playSelection()
        }
    }
    
    func updateHealthKit(){
        var samplesToUpdate: [HKQuantitySample] = []
        let date = Date()
        
        if let type = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass) {
            if self.newWeight.doubleValue > 0 {
                let quantity = HKQuantity(unit: HKUnit.pound(), doubleValue: self.newWeight.doubleValue)
                samplesToUpdate.append(HKQuantitySample(type: type, quantity: quantity, start: date, end: date))
            }
            //            let sample = HKQuantitySample(type: type, quantity: quantity, start: date, end: date)
        }
        if let type = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyFatPercentage) {
            if self.newFat.doubleValue > 0 {
                let quantity = HKQuantity(unit: HKUnit.percent(), doubleValue: self.newFat.doubleValue / 100)
                samplesToUpdate.append(HKQuantitySample(type: type, quantity: quantity, start: date, end: date))
            }
        }
        if let type = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.leanBodyMass) {
            if self.newMuscle.doubleValue > 0 {
                let quantity = HKQuantity(unit: HKUnit.pound(), doubleValue: getLeanBodyMass())
                samplesToUpdate.append(HKQuantitySample(type: type, quantity: quantity, start: date, end: date))
            }
        }
        if let type = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMassIndex) {
            if self.newBmi.doubleValue > 0 {
                let quantity = HKQuantity(unit: HKUnit.count(), doubleValue: self.newBmi.doubleValue)
                samplesToUpdate.append(HKQuantitySample(type: type, quantity: quantity, start: date, end: date))
            }
        }
        healthStore.save(samplesToUpdate, withCompletion: { (success, error) in
            print("Saved \(success), error \(String(describing: error))")
        })
    }
    
    func getLeanBodyMass() -> Double {
        let peso = self.newWeight.doubleValue
        let MusclePercentage = self.newMuscle.doubleValue / 100
        return peso * MusclePercentage
    }
    
}


struct NewMedida_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
