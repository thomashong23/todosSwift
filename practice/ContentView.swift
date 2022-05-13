//
//  ContentView.swift
//  practice
//
//  Created by Tommy Hong on 4/29/22.
//

import SwiftUI
struct TodoItem: Codable, Identifiable {
  let id = UUID()
  let todo: String
}
struct ContentView: View {
  
  @State private var newTodo = ""
@State private var newColor = ""
  @State private var allTodos: [TodoItem] = []
    @State private var color = ""
    
    
  
  var body: some View {
    NavigationView {
      VStack {
        HStack {
          TextField("Add todo...", text: $newTodo)
            .textFieldStyle(RoundedBorderTextFieldStyle())

          Button(action: {
            guard !self.newTodo.isEmpty else { return }
            self.allTodos.append(TodoItem(todo: self.newTodo))
            self.newTodo = ""
            self.saveTodos()
          }) {
            Image(systemName: "plus")
          }
          .padding(.leading, 5)
        }.padding()

        List {
          ForEach(allTodos) { todoItem in
            Text(todoItem.todo)
          }.onDelete(perform: deleteTodo)
            .background(Color(parseColor()))
            .foregroundColor(.white)

        }
        HStack{
          TextField("Add your color here, RGB format seperated by commas and no spaces", text: $newColor)
             //   .onAppear(perform: loadColor)
              .textFieldStyle(RoundedBorderTextFieldStyle())
          Button(action: {
              if (boolUpdateColor(colorUp: newColor)){
                    self.color = self.newColor
                    self.newColor = ""
                  self.saveColor()
              }
              
            
              
              
          }){
              Image(systemName: "plus")
          }
          }
            
    
          
          
          
          
      }
      .navigationBarTitle("Todos")
    }.onAppear(perform: loadData)
   
  }
  
  private func saveTodos() {
    UserDefaults.standard.set(try? PropertyListEncoder().encode(self.allTodos), forKey: "todosKey")
  }
    private func parseColor() -> UIColor{
        
        let str = color
        guard !(str.count == 0) else {return UIColor(red: 0,green: 0,blue: 0, alpha: 0)}
        let components = str.components(separatedBy: ",")
        var red = 0.0
        red = Double(components[0])!/255
        var green = 0.0
        green = Double(components[1])!/255
        var blue = 0.0
        blue = Double(components[2])!/255
        
        print("red: " + String(red))
        print("green: " + String(green))
        print("blue: " + String(blue))
        print("component[0] " + components[0])
        print("green: " + String(green))
        print("blue: " + String(blue))
        return UIColor(red: CGFloat(red) , green: CGFloat(green), blue: CGFloat(blue), alpha:1)
        
    }
    private func saveColor(){
        UserDefaults.standard.set(color, forKey: "colorKey")
        
        print("saving color:"  + color )
        
//        UserDefaults.standard.set(try? PropertyListEncoder().encode(self.color), forKey: "colorKey")
    }
    private func boolUpdateColor( colorUp: String) ->Bool{
        guard !self.newColor.isEmpty else {return false}
        let components = self.newColor.components(separatedBy: ",")
        var is3 = false
        var transcribable = false
        if (components.count == 3){
            is3 = true
        }
        if(is3){
            if((Int(components[0])!)<256) {
                if((Int(components[1])!)<256) {
                    if((Int(components[2])!)<256) {
                        transcribable=true
                        print("is a color")
                    }
                }
              }
        }
        return transcribable
    }

  private func loadData() {
    if let todosData = UserDefaults.standard.value(forKey: "todosKey") as? Data {
      if let todosList = try? PropertyListDecoder().decode(Array<TodoItem>.self, from: todosData) {
        self.allTodos = todosList
      }
    }
      if let colorData = UserDefaults.standard.value(forKey: "colorKey") as? String{
          print("color data: " + colorData)
          self.color = colorData
      }
  }
//    private func loadColor(){
//
//    }
  
  private func deleteTodo(at offsets: IndexSet) {
    self.allTodos.remove(atOffsets: offsets)
    saveTodos()
  }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
