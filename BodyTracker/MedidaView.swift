//
//  MedidaView.swift
//  BodyTracker
//
//  Created by Administrator on 18/01/20.
//  Copyright © 2020 RafaelCM. All rights reserved.
//

import SwiftUI

struct MedidaView: View {
    var weight:String = ""
    var bmi:String = ""
    var fat:String = ""
    var muscle:String = ""
    var rmkcal:String = ""
    var bodyAge:String = ""
    var visceral:String = ""
    var createdAt:String = ""
    var delta:NSNumber = 0

    
    var body: some View {
        VStack(alignment: .leading){
            Text(createdAt)
            HStack{
                VStack(alignment: .leading){
                    Text("Peso: " + weight + "Kg").font(.caption).foregroundColor(.blue)
                    Text("IMC: " + bmi).font(.caption)
                }
                Spacer()
                VStack(alignment: .leading){
                    Text("Gordura: " + fat + "%").font(.caption)
                    Text("Músculo: " + muscle + "%").font(.caption)
                }
                Spacer()
                VStack(alignment: .leading){
                    Text("RMkCal: " + rmkcal).font(.caption)
                    Text("Idade: " + bodyAge).font(.caption)
                }
                Spacer()
                VStack(alignment: .trailing){
                    HStack{
                        if (delta.floatValue > 0){
                            Image(systemName: "arrow.up").foregroundColor(.red)
                            Text(getDelta() + "Kg")
                                .font(.caption)
                                .foregroundColor(Color.red)
                        } else {
                            Image(systemName: "arrow.down").foregroundColor(.green)
                            Text(getDelta() + "Kg")
                                .font(.caption)
                                .foregroundColor(Color.green)
                        }
                    }
                }
            }
            Text("Gordura Visceral: " + visceral + "%").font(.caption).foregroundColor(.red)
        }
    }
    func getDelta() -> String{
        return String(format: "%.2f", round(delta.floatValue*100)/100)
    }
}

struct MedidaView_Previews: PreviewProvider {
    static var previews: some View {
        MedidaView()
    }
}
