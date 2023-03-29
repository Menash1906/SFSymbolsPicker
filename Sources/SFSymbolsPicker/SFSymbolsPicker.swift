//
//  SFSymbolsPicker.swift
//  AntiMess
//
//  Created by Michael Menashe on 29/03/2023.
//

import SwiftUI

public struct SFSymbolsPicker: View {
    
    @Binding public var icon: String
    @Binding public var color: Color
    @State var category: Category = .communication
    @State var searchText = ""
    
    @Environment(\.dismiss) var dismiss
    
    let columns = [GridItem(.adaptive(minimum: 70)), GridItem(.adaptive(minimum: 70)), GridItem(.adaptive(minimum: 70))]
    
    public init(icon: Binding<String>, color: Binding<Color>) {
        _icon = icon
        _color = color
    }
    
    public var body: some View {
        NavigationView {
            VStack(spacing: 12) {
                Image(systemName: icon)
                    .renderingMode(.template)
                    .font(.system(size: 25))
                    .padding(16)
                    .background(color)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                HStack(spacing: 12) {
                    Picker("Category", selection: $category) {
                        ForEach(Category.allCases, id: \.id) { category in
                            Text(category.rawValue == "" ? "All" : category.rawValue)
                                .tag(category)
                        }
                    }
                    .pickerStyle(.menu)
                    ColorPicker(selection: $color, supportsOpacity: false) {
                        Text("Color")
                            .font(.title3)
                            .fontWeight(.bold)
                    }
                    .fixedSize()
                }
                ScrollView {
                    
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(searchText != "" ? symbols[category.rawValue]!.filter{$0.replacingOccurrences(of: ".", with:" ") .contains(searchText.lowercased())} : symbols[category.rawValue]!, id: \.hash) { icon in
                            
                            VStack {
                                Image(systemName: icon)
                                    .font(.system(size: 25))
                                    .foregroundColor(self.icon == icon ? Color.blue : Color.primary)
                                    .onTapGesture {
                                        withAnimation(.linear) {
                                            self.icon = icon
                                        }
                                    }
                                Text(icon.replacingOccurrences(of: ".", with: " "))
                                    .font(.caption)
                                    .multilineTextAlignment(.center)
                            }
                            
                        }.padding(.top, 5)
                    }
                }
                .searchable(text: $searchText)
                .frame(maxWidth: .infinity)
            }
            .padding(8)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Apply") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct SFSymbolsPicker_Previews: PreviewProvider {
    static var previews: some View {
        SFSymbolsPicker(icon: .constant("gear"), color: .constant(.blue))
    }
}
