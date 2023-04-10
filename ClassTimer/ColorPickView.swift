//
//  ColorPickView.swift
//  ClassTimer
//
//  Created by Степан Кравцов on 10.04.2023.
//

import SwiftUI

struct ColorPickView: View {
    @State private var bgColor =
           Color(.sRGB, red: 0.98, green: 0.9, blue: 0.2)

    var body: some View {
        VStack {
            ColorPicker("", selection: $bgColor)
        }
    }
}

struct ColorPickView_Previews: PreviewProvider {
    static var previews: some View {
        ColorPickView()
    }
}
