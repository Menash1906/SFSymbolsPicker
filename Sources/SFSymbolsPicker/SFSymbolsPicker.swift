//
//  SFSymbolsPicker.swift
//  AntiMess
//
//  Created by Michael Menashe on 29/03/2023.
//

import SwiftUI

struct SFSymbolsPicker: View {
    
    @Binding public var icon: String
    @State var category: Category = .arrows
    @State var searchText = ""

    let columns = [GridItem(.adaptive(minimum: 70)), GridItem(.adaptive(minimum: 70)), GridItem(.adaptive(minimum: 70))]
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack {
            Picker("Category", selection: $category) {
                ForEach(Category.allCases, id: \.id) { category in
                    Text(category.rawValue == "" ? "All" : category.rawValue)
                        .tag(category)
                }
            }
            .pickerStyle(.menu)
            ScrollView {
                
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(searchText != "" ? symbols[category.rawValue]!.filter{$0.replacingOccurrences(of: ".", with:" ") .contains(searchText.lowercased())} : symbols[category.rawValue]!, id: \.hash) { icon in
                        
                        VStack {
                            Image(systemName: icon)
                                .font(.system(size: 25))
                                .foregroundColor(self.icon == icon ? Color.blue : Color.primary)
                            Text(icon.replacingOccurrences(of: ".", with: " "))
                                .font(.caption)
                                .multilineTextAlignment(.center)
                        }
                        .onTapGesture {
                            // Assign binding value
                            withAnimation(.linear) {
                                self.icon = icon
                                dismiss()
                            }
                        }
                        
                    }.padding(.top, 5)
                }
            }
            .searchable(text: $searchText)
            .frame(maxWidth: .infinity)
        }
        
    }
}

struct SFSymbolsPicker_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SFSymbolsPicker(icon: .constant("gear"), category: .games)
        }
    }
}
