//
//  AddTodoView.swift
//  Todo App
//
//  Created by Albab on 15/02/21.
//

import SwiftUI

struct AddTodoView: View {
    
    //Mark-Property
    
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name: String = ""
    @State private var priority: String = "Normal"
    
    let priorities = ["High","Normal","Low"]
    
    @State private var errorShowing: Bool = false
    @State private var errorTitle: String = ""
    @State private var errorMessage: String = ""
    
    @ObservedObject var theme = ThemeSettings.shared
    var themes: [Theme] = themeData
    
    
    
    //Mark-Body
    var body: some View {
        NavigationView{
            VStack{
                VStack(alignment: .leading, spacing: 20){
                    //Mark Todo name
                    TextField("Todo",text: $name)
                        .padding()
                        .background(Color(UIColor.tertiarySystemFill))
                        .cornerRadius(9)
                        .font(.system(size: 24, weight: .bold, design: .default))
                    
                    
                    //Mark Todo Priority
                    Picker(priority,selection:$priority){
                        ForEach(priorities,id:\.self){
                            Text($0)
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                    
                    Button(action:{
                        
                        if self.name != ""{
                            let todo = Todo(context: self.managedObjectContext)
                            todo.name = self.name
                            todo.priority = self.priority
                            
                            do {
                                try self.managedObjectContext.save()
                                print("New Todo: \(todo.name ?? ""), Priority: \(todo.priority ?? "")")
                            } catch {
                                print(error)
                            }
                        } else {
                            self.errorShowing = true
                            self.errorTitle = "Invalid Name"
                            self.errorMessage = "Make sure to enter something for\n the new todo item"
                            return
                        }
                        self.presentationMode.wrappedValue.dismiss()

                    }){
                        Text("Save")
                            .font(.system(size: 24, weight: .bold, design: .default))
                            .padding()
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .background(themes[self.theme.themeSetting].themeColor)
                            .cornerRadius(9)
                            .foregroundColor(Color.white)
                    }// Save Button
                }//Form
                .padding(.horizontal)
                .padding(.vertical, 30)
                
                 
                Spacer()
            }//Vstack
            .navigationBarTitle("New Todo",displayMode: .inline)
            .navigationBarItems(trailing:
                                    Button(action:{
                                        self.presentationMode.wrappedValue.dismiss()
                                    }){
                                        Image(systemName: "xmark")
                                    })
            .alert(isPresented: $errorShowing){
                Alert(title: Text(errorTitle), message: Text(errorMessage),
                      dismissButton: .default(Text("OKE")))
            }
            
        }//Navigation View
        .accentColor(themes[self.theme.themeSetting].themeColor)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

//Mark-Preview
struct AddTodoView_Previews: PreviewProvider {
    static var previews: some View {
        AddTodoView()
    }
}


