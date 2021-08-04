//
//  ContentView.swift
//  API Calling
//
//  Created by Franklin Tan on 7/29/21.
//

import SwiftUI

struct ContentView: View {
    @State private var burgers = [Burger]()
    @State private var showingAlert = false
    var body: some View {
        NavigationView {
            List(burgers) { burger in
                NavigationLink(
                    destination: Text(burger.ingredients)
                        .padding(),
                    label: {
                        Text(burger.description)
                    })
            }
            .navigationTitle("Burgers!")
        }
        .onAppear(perform: {
            getBurgers()
        })
        .alert(isPresented: $showingAlert, content: {
            Alert(title: Text("Loading Error"),
                  message: Text("There was a problem loading the data"),
                  dismissButton: .default(Text("OK")))
        })
    }
    
    func getBurgers() {
        let apiKey = "?rapidapi-key=2ebab9e138msh9178605bc56f667p1873edjsn7b521d2c15f8"
        let query = "https://burgers1.p.rapidapi.com/burgers\(apiKey)"
        if let url = URL(string: query) {
            if let data = try? Data(contentsOf: url) {
                let json = try! JSON(data: data)
                    let contents = json.arrayValue
                    for item in contents {
                        let description = item["description"].stringValue
                        let ingredients = item["incredients"].stringValue
                        let burger = Burger(description: description, ingredients: ingredients)
                        burgers.append(burger)
                    }
                    return
            }
        }
        showingAlert = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Burger: Identifiable {
    let id = UUID()
    var description: String
    var ingredients: String
}
