//
//  Dashboard.swift
//  BodyTracker
//
//  Created by Administrator on 21/01/20.
//  Copyright © 2020 RafaelCM. All rights reserved.
//

import SwiftUI
import SwiftUICharts

struct Dashboard: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: Medida.getAllMedidasAscending()) var Medidas:FetchedResults<Medida>
    let chartStyle = ChartStyle(backgroundColor: Color.black, accentColor: getMyColor(), secondGradientColor: .yellow, textColor: .white, legendTextColor: getMyColor())
    @State private var showChart:Int = 0
    
    var body: some View {
        VStack{
            Text("Body Tracker").font(.largeTitle).shadow(color: getMyColor(), radius: 3)
            Spacer()
            //Progresso
            HStack{
                HStack{
                    Spacer()
                    VStack{
                        Text("Progresso")
                        ZStack{
                            ProgressCircle(value: getProgress(),
                                           maxValue: 100,
                                           style: .line,
                                           foregroundColor: getMyColor(),
                                           lineWidth: 5)
                                .frame(width:95, height: 95)
                            Text(String(format: "%.0f", round(getProgress())) + "%")
                        }
                    }.padding(.vertical,10)
                    Spacer()
                    VStack{
                        Spacer()
                        HStack{
                            Text(String(format: "%.2f", round(getPesoAtual()*100)/100) + " Kg")
                                .font(.largeTitle)
                                .fontWeight(.heavy)
                                .foregroundColor(Color(hue: 0.604, saturation: 1.0, brightness: 1.0))
                        }
                        Spacer()
                        HStack{
                            Text("Meta:")
                            Text(String(format: "%.0f", round(Profile.getCurrentPesoMeta()*100)/100) + "Kg")
                                .font(.headline)
                                .fontWeight(.heavy)
                        }
                        Spacer()
                        HStack{
                            Text("Você já emagreceu:")
                                .font(.footnote)
                            Text(String(format: "%.2f", round(getTotalEmagrecido()*100)/100) + "Kg")
                                .font(.callout)
                                .fontWeight(.heavy)
                            
                        }
                        Spacer()
                    }
                    Spacer()
                }.padding(.trailing,10)
            }.padding(.horizontal, 5.0).overlay(RoundedRectangle(cornerRadius: 10)
                .stroke(Colors.GradientUpperBlue, lineWidth: 1))
                .background(Color.black)
            Spacer()
            //Medidas Atuais
            VStack(spacing: 10){
                Text("Medidas Corporais")
                HStack{
                    VStack(alignment: .leading){
                        Text("Gordura: " + String(format: "%.1f", round(getFatAtual()*100)/100) + "%")
                        Text("Músculo: " + String(format: "%.1f", round(getMuscleAtual()*100)/100) + "%")
                    }
                    Spacer()
                    VStack(alignment: .leading){
                        Text("Gordura Visceral: " + String(format: "%.1f", round(getVisceralAtual()*100)/100) + "%")
                        Text("Calorias: " + String(format: "%.1f", round(getRMKcalAtual()*100)/100) + "kcal")
                    }
                }
            }.padding(15).overlay(RoundedRectangle(cornerRadius: 10)
                .stroke(Colors.GradientUpperBlue, lineWidth: 1))
            .background(Color.black)
            Spacer()
            //IMC Atual
            VStack(alignment: .leading){
                HStack{
                    Spacer()
                    Text("IMC Atual")
                        .font(.headline)
                    Spacer()
                    Text(String(format: "%.1f", round(getBmiAtual()*100)/100)).font(.title).fontWeight(.bold).foregroundColor(.white)
                    Spacer()
                }
                
                CustomSlider(value: getBmiAtual(),   range: (15, 65)) { modifiers in
                    ZStack {
                        Group {
                            Color.blue
                                .modifier(modifiers.bar1)
                            Color.green
                                .modifier(modifiers.bar2)
                            Color.yellow
                                .modifier(modifiers.bar3)
                            Color.red
                                .modifier(modifiers.bar4)
                        }.clipShape(MagnitudeChart())
                        Image(systemName: "arrowtriangle.down.fill")
                            .font(.system(size: 22))
                            .foregroundColor(Color.white)
                            .offset(y: -5)
                            .modifier(modifiers.knob)
                            //.padding([.top, .bottom], 1)
                            .modifier(modifiers.knob)
                    }
                }.frame(height: 20).padding(.horizontal,8)
                HStack{
                    Text("10").offset(x: UIScreen.screenWidth * 0.0133, y: -7)
                    Text("18").offset(x: UIScreen.screenWidth * 0.0346, y: -7)
                    Text("25").offset(x: UIScreen.screenWidth * 0.2133, y: -7)
                    Text("30").offset(x: UIScreen.screenWidth * 0.32, y: -7)
                    Text("40").offset(x: UIScreen.screenWidth * 0.5866, y: -7)
                }
                
            }.overlay(RoundedRectangle(cornerRadius: 10)
                .stroke(Colors.GradientUpperBlue, lineWidth: 1))
            .background(Color.black)
            Spacer()
            //Chart
            HStack{
                getChart()
            }.onTapGesture {
                self.showChart += 1
                if self.showChart == 4 {
                    self.showChart = 0
                }
            }
            Spacer()
        }
        .padding(.horizontal, 10)
        .foregroundColor(getMyColor())
        .onAppear{
            HapticFeedback.playSelection()
        }
        .background(Color.black)
    }
    
    func getChart() -> some View{
        switch self.showChart {
        case 0: return
            LineChartView(data: getWeights(), title: "Peso", style: chartStyle, form: ChartForm.large, rateValue: -getTotalEmagrecido(), unit: "Kg")
                .overlay(RoundedRectangle(cornerRadius: 20)
                    .stroke(Colors.GradientUpperBlue, lineWidth: CGFloat(1))
            )
        case 1: return
            LineChartView(data: getFats(), title: "Gordura", style: chartStyle, form: ChartForm.large, rateValue: -getTotalFatLost(), unit: "%")
                .overlay(RoundedRectangle(cornerRadius: 20)
                    .stroke(Colors.GradientUpperBlue, lineWidth: CGFloat(1))
            )
        case 2: return
            LineChartView(data: getMusculos(), title: "Músculo", style: chartStyle, form: ChartForm.large, rateValue: -getTotalMuscleGained(), unit: "%")
                .overlay(RoundedRectangle(cornerRadius: 20)
                    .stroke(Colors.GradientUpperBlue, lineWidth: CGFloat(1))
            )
        case 3: return
            LineChartView(data: getBMIs(), title: "IMC", style: chartStyle, form: ChartForm.large, rateValue: -getBMIVariation(), unit: "")
                .overlay(RoundedRectangle(cornerRadius: 20)
                    .stroke(Colors.GradientUpperBlue, lineWidth: CGFloat(1))
            )
        default : return
            LineChartView(data: getWeights(), title: "Peso", style: chartStyle, form: ChartForm.large, rateValue: -getTotalEmagrecido(), unit: "Kg")
                .overlay(RoundedRectangle(cornerRadius: 20)
                    .stroke(Colors.GradientUpperBlue, lineWidth: CGFloat(1))
            )
        }
    }
    
    func getDeltaAtual() -> Int{
        if let value = Medidas.last?.delta{
            return Int(truncating: value)
        } else {
            return 0
        }
    }
    
    func getPesoAtual() -> Double{
        if let value = Medidas.last?.weight{
            return Double(truncating: value)
        } else {
            return 0
        }
    }
    
    func getBmiAtual() -> Double{
        if let value = Medidas.last?.bmi{
            return Double(truncating: value)
        } else {
            return 0
        }
    }
    
    func getFatAtual() -> Double{
        if let value = Medidas.last?.fat{
            return Double(truncating: value)
        } else {
            return 0
        }
    }
    
    func getVisceralAtual() -> Double{
        if let value = Medidas.last?.visceral{
            return Double(truncating: value)
        } else {
            return 0
        }
    }
    
    func getMuscleAtual() -> Double{
        if let value = Medidas.last?.muscle{
            return Double(truncating: value)
        } else {
            return 0
        }
    }
    
    func getRMKcalAtual() -> Double{
        if let value = Medidas.last?.rmkcal{
            return Double(truncating: value)
        } else {
            return 0
        }
    }
    
    func getProgress() -> Double{
        HapticFeedback.playSelection()
        let deltaMeta = Profile.getCurrentPesoInicial() - Profile.getCurrentPesoMeta()
        let deltaAtual = Profile.getCurrentPesoInicial() - getPesoAtual()
        if (deltaAtual/deltaMeta)*100 > 0 {
            return (deltaAtual/deltaMeta)*100
        } else{
            return 0
        }
    }
    
    func getWeights() -> [Double]{
        var result:[Double] = []
        var index:Int = 0
        for medida in Medidas{
            index = index + 1
            result.append(Double(medida.weight!.floatValue))
        }
        return result
    }
    
    func getFats() -> [Double]{
        var result:[Double] = []
        var index:Int = 0
        for medida in Medidas{
            index = index + 1
            result.append(Double(medida.fat!.floatValue))
        }
        return result
    }
    
    func getMusculos() -> [Double]{
        var result:[Double] = []
        var index:Int = 0
        for medida in Medidas{
            index = index + 1
            result.append(Double(medida.muscle!.floatValue))
        }
        return result
    }
    
    func getBMIs() -> [Double]{
        var result:[Double] = []
        var index:Int = 0
        for medida in Medidas{
            index = index + 1
            result.append(Double(medida.bmi!.floatValue))
        }
        return result
    }


    func getTotalEmagrecido() -> Double{
        return (Profile.getCurrentPesoInicial() - getPesoAtual())
    }
    
    func getTotalFatLost() -> Double{
        if let result = Medidas.first?.fat?.doubleValue{
            return result - getFatAtual()
        } else {
            return 0
        }
    }
    
    func getTotalMuscleGained() -> Double{
        if let result = Medidas.first?.muscle?.doubleValue{
            return result - getMuscleAtual()
        } else {
            return 0
        }
    }
    
    func getBMIVariation() -> Double{
        if let result = Medidas.first?.bmi?.doubleValue{
            return result - getBmiAtual()
        } else {
            return 0
        }
    }
    
}

struct Dashboard_Previews: PreviewProvider {
    static var previews: some View {
        Dashboard()
    }
}
