//
//  ContentView.swift
//  swiftui-selectable-grid
//
//  Created by Carlos Valente on 12/06/2023.
//

import SwiftUI

struct Placeholder: View {
    let text: String;
    let selected: Bool
    
    var body: some View {
        ZStack {
            Rectangle()
                .aspectRatio(1.0, contentMode: .fit)
                .foregroundColor(.cyan)
                .border(.white, width: selected ?  10: 0)
            Text(text)
        }
    }
}

enum SelectableMode {
    case none
    case selectable
    case selected
}
struct Selectable: View {
    let mode: SelectableMode
    
    var body: some View {
        if (mode == .selectable) {
            Image(systemName: "circle")
        } else if (mode == .selected) {
            Image(systemName: "checkmark.circle.fill")
        } else {
            EmptyView()
        }
    }
}

struct Grid: View {
    let data = (1...10).map { "Photo \($0)" }
    
    @State private var isSelectMode: Bool = false
    @State private var selectedPhotos: [String] = []

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 2) {
                let _ = print(selectedPhotos)
                ForEach(data, id: \.self) { item in
                    let selectMode: SelectableMode = {
                        if selectedPhotos.contains(item) {
                            return .selected
                        } else if isSelectMode {
                            return .selectable
                        } else {
                            return .none
                        }
                    }()

                    ZStack {
                        Placeholder(text: item, selected: selectMode == SelectableMode.selected)
                            .onTapGesture {
                                if (isSelectMode) {
                                    if (selectMode == SelectableMode.selected) {
                                        let index = selectedPhotos.firstIndex(of: item)
                                        selectedPhotos.remove(at: index!)
                                    } else {
                                        selectedPhotos.append(item)
                                    }
                                }
                            }
                            .onLongPressGesture {
                                isSelectMode = true
                                selectedPhotos.append(item)
                            }
                        Selectable(mode: selectMode)
                    }
                }
            }
        }
        .background(isSelectMode ? Color.red : Color.blue)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("cancel", action: {
                    selectedPhotos = []
                    isSelectMode = false
                })
            }
        }

    }
}

struct ContentView: View {
    var body: some View {
        NavigationStack {
            Grid().navigationTitle("Testing")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
