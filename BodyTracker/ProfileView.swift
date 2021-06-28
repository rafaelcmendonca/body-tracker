//
//  ProfileView.swift
//  BodyTracker
//
//  Created by Administrator on 20/01/20.
//  Copyright © 2020 RafaelCM. All rights reserved.
//

import SwiftUI
import CoreData
import Haptica

struct ProfileView: View {
    //@Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: Profile.getProfile()) var profiles:FetchedResults<Profile>
    @State private var showingAlert = false
    
    //private var currentProfile:Profile = Profile.getCurrentProfile()
    @State private var newPesoInicial = "\(Profile.getCurrentPesoInicial())"
    @State private var newPesoMeta = "\(Profile.getCurrentPesoMeta())"
    
    
    var body: some View {
        VStack(spacing: 30){
            Spacer()
            Text("Editar Perfil").font(.largeTitle).shadow(color: getMyColor(), radius: 3)
            Spacer()
            
            HStack{
                Spacer()
                VStack(alignment: .trailing, spacing: 30){
                    Text("Peso Inicial")
                    Text("Meta")
                }
                Spacer()
                VStack(alignment: .leading, spacing: 30){
                    HStack{
                        TextField("100 Kg?", text: self.$newPesoInicial).keyboardType(.decimalPad).multilineTextAlignment(.center).background(getTextFieldColor()).font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        Text("Kg")
                    }
                    HStack{
                        TextField("80 Kg?", text: self.$newPesoMeta).keyboardType(.decimalPad).multilineTextAlignment(.center)
                            .background(getTextFieldColor()).font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        Text("Kg")
                    }
                }
                Spacer()
            }.padding(.horizontal, 30)
            Spacer()
            Button(action: {
                let profile = Profile(context: self.managedObjectContext)
                profile.pesoinicial = convertStrToNSNum(text: self.newPesoInicial)
                profile.pesometa = convertStrToNSNum(text: self.newPesoMeta)
                
                do {
                    try self.managedObjectContext.save()
                } catch {
                    print(error)
                }
                self.showingAlert = true
                Haptic.play("....ooooO-O-O-oooo....", delay: 0.1)
            }){
                HStack{
                    Image(systemName: "person.crop.circle.badge.checkmark")
                        .foregroundColor(getMyColor())
                        .padding(15.0)
                        .imageScale(.medium)
                        .font(.largeTitle)
                    Text("Salvar")
                        .font(.title)
                        .padding(15.0)
                }.overlay(RoundedRectangle(cornerRadius: 10)
                .stroke(getMyColor(), lineWidth: 1))
            }.alert(isPresented: $showingAlert) {
                Alert(title: Text("Informação"), message: Text("Perfil salvo com sucesso!"), dismissButton: .default(Text("Entendi!")))
            }.background(getTextFieldColor())
//   ********* Botão usado para limpar todos os Perfis Salvos *********
//            Button(action: {
//                for item in self.profiles {
//                    self.managedObjectContext.delete(item)
//                }
//                do {
//                    try self.managedObjectContext.save()
//                } catch {
//                    print(error)
//                }
//
//            }){
//                Text("Clear Memory")
//            }
//   ************ Fim do Botão maligno **********
            
            Spacer()
        }
        .onAppear{
            HapticFeedback.playSelection()
        }
    }
    
    
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
