//
//  ContentView.swift
//  ToDoApp act 2
//
//  Created by Albab on 28/04/21.
//


import SwiftUI

struct ContentView: View {
    //tanda - property
    
    @FetchRequest( entity: Todo.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Todo.name, ascending: true)] ) var todos: FetchedResults<Todo>
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @EnvironmentObject var iconSettings: IconNames
    
    @State private var showingSettingsView: Bool = false
    @State private var showingAddTodoView: Bool = false
    @State private var animatingButton: Bool = false
    
    @ObservedObject var theme = ThemeSettings.shared
    var themes: [Theme] = themeData
    
    //tanda - body
    var body: some View {
        
        NavigationView{
            ZStack {
                List{
                    ForEach(self.todos, id: \.self) { todo in
                        HStack{
                            Circle()
                                .frame(width: 12, height: 12, alignment: .center)
                                .foregroundColor(.pink)
                            Text(todo.name ?? "Unknown")
                                .fontWeight(.semibold)
                        
                            Spacer()
                        
                            Text(todo.priority ?? "Unknown")
                                .font(.footnote)
                                .foregroundColor(Color(UIColor.systemGray2))
                                .padding(3)
                                .frame(minWidth: 62)
                                .overlay(
                                    Capsule().stroke(Color(UIColor.systemGray2), lineWidth: 0.75)
                            )
                    }
                }
                .onDelete(perform: deleteTodo)
            }//list
            .navigationBarTitle("Todo", displayMode: .inline)
            .navigationBarItems(
                leading: EditButton().accentColor(themes[self.theme.themeSetting].themeColor),
                                    trailing:
                                        Button(action: {
                                            self.showingSettingsView.toggle()
                                        }) {
                                            Image(systemName: "paintbrush")
                                                .imageScale(.large)
                                            
                                        }//: Setting Button
                                        .accentColor(themes[self.theme.themeSetting].themeColor)
                                        .sheet(isPresented: $showingSettingsView) {
                                            SettingsView().environmentObject(self.iconSettings)
                                        }
            
            )
                
            }// : ZStack
        .sheet(isPresented: $showingAddTodoView){
            AddTodoView().environment(\.managedObjectContext, self.managedObjectContext)
            
                
            }
            .overlay(
                ZStack {
                    Group{
                        Circle()
                            .fill(themes[self.theme.themeSetting].themeColor)
                            .opacity(self.animatingButton ? 0.2 : 0)
                            .frame(width: 68, height: 68, alignment: .center)
                        Circle()
                            .fill(themes[self.theme.themeSetting].themeColor)
                            .opacity(self.animatingButton ? 0.15 : 0)
                            .frame(width: 88, height: 88, alignment: .center)
                    }//: Group
                    Button(action: {
                        self.showingAddTodoView.toggle()
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .background(Circle().fill(Color("ColorBase")))
                            .frame(width: 48, height: 48, alignment: .center)
                    }//: Button Plus
                    .accentColor(themes[self.theme.themeSetting].themeColor)
                    .onAppear(perform: {self.animatingButton.toggle()})
                    
                }//: ZStack
                .padding(.bottom, 15)
                .padding(.trailing, 15)
                , alignment: .bottomTrailing
            )
            
        }//navigationView
        .navigationViewStyle(StackNavigationViewStyle())
    }
    //mark
    
    private func deleteTodo(at offsets: IndexSet){
        for index in offsets {
            let todo = todos[index]
            managedObjectContext.delete(todo)
            
            do {
                try managedObjectContext.save()
            } catch {
                print(error)
            }
        }
    }
    private func colorize(priority: String) -> Color {
           switch priority {
           case "High":
               return .blue
           case "Normal":
               return .green
           case "Low":
               return .pink
           default:
               return .gray
           }
       }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return ContentView()
            .environment(\.managedObjectContext, context)
            .previewDevice("iphone 11 pro")
    }
}
