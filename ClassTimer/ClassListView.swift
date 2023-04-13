//
//  ClassListView.swift
//  ClassTimer
//
//  Created by Степан Кравцов on 10.04.2023.
//

import SwiftUI

struct ClassListView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @State var pick = "Schedule"
    @State var selectedIndex: Int = 0
    @State var addingClass = false
    @State var addingExam = false
    let dayLetters = ["M","Tu","W","Th","F","Sa","Su"]
    @State var editClassSheet = false
    @State var classToEditOrDelete: Class? = nil
    @State var deleteClassAlert = false
    var body: some View {
        VStack{
            Picker("", selection: $pick) {
                Text("Schedule")
                    .tag("Schedule")
                Text("Classes")
                    .tag("Classes")
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()


            if pick == "Schedule"{
                VStack{
                    ZStack{
                        SegmentedPicker(
                            dayLetters,
                                    selectedIndex: Binding(
                                        get: { selectedIndex },
                                        set: { selectedIndex = $0 ?? 0 }),
                                    content: { item, isSelected in
                                        Text(item)
                                            .foregroundColor(isSelected ? Color.white : Color.gray )
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 8)
                                    },
                                    selection: {
                                        Capsule()
                                            .fill(viewModel.pickedColor.opacity(0.8))
                                    })
                                    .animation(.easeInOut(duration: 0.3))
                }
                    VStack(spacing: 5){
                        Group{

                                Text(days[selectedIndex])
                                    .fontWeight(.thin)
                                    .italic()
                                    .frame(maxWidth: .infinity, alignment: .topLeading)
                                    .padding(.top)
                                    .padding(.horizontal)
                                RoundedRectangle(cornerRadius: 50, style: .continuous)
                                    .frame(height: 2)
                                    .padding(.horizontal)
                                DayView(lessons: (viewModel.schedule.schedule[selectedIndex+1]) ?? [])

                        }

                    }
                    .frame(maxHeight: .infinity, alignment: .top)
                }

            }
            if pick == "Classes"{
                VStack(spacing: 5){
                    HStack{
                        Text("Classes")
                            .fontWeight(.thin)
                            .italic()
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                            .padding(.top)
                            .padding(.horizontal)
                        Button {
                            addingClass.toggle()

                        } label: {
                            ZStack{
                                Image(systemName: "plus")
                                    .foregroundColor(Color.gray)
                                    .font(.system(size: 20))
                            }
                            }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .frame(height: 30)
                        .padding(.top)
                        .padding(.horizontal)
                        .sheet(isPresented: $addingClass){
                            ClassAddView()
                        }
                    }
                    RoundedRectangle(cornerRadius: 50, style: .continuous)
                        .frame(height: 2)
                        .padding(.horizontal)

                    List{
                        ForEach(viewModel.classes){ cl in
                            HStack{
                                
                                Text(cl.name)
                                    .fontWeight(.medium)
                                    .frame(alignment: .leading)


                                    Text(cl.description)
                                        .fontWeight(.thin)
                                        .frame(maxWidth: .infinity, alignment: .trailing)

                                        .padding(.leading, 4)



                                Spacer()


                            }
                            .swipeActions(allowsFullSwipe: false) {
                                                        Button {
                                                            editClassSheet.toggle()
                                                        } label: {
                                                            Label("Edit", systemImage: "pencil")
                                                        }
                                                        .tint(.indigo)

                                                        Button(role: .destructive) {
                                                            classToEditOrDelete = cl
                                                            deleteClassAlert.toggle()
                                                        } label: {
                                                            Label("Delete", systemImage: "trash.fill")
                                                        }
                                                    }
                            .sheet(isPresented: $editClassSheet){
                                EditClassView(classToEdit: cl)
                            }
                        }
                    }

                    .listStyle(.plain)
                    

                }

            }
            if pick == "Exams"{
                VStack(spacing: 5){
                    HStack{
                        Text("Exams")
                            .fontWeight(.thin)
                            .italic()
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                            .padding(.top)
                            .padding(.horizontal)
                        Button {
                            addingExam.toggle()

                        } label: {
                            ZStack{
                                Image(systemName: "plus")
                                    .foregroundColor(Color.gray)
                                    .font(.system(size: 20))
                            }
                            }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .frame(height: 30)
                        .padding(.top)
                        .padding(.horizontal)
                        .sheet(isPresented: $addingExam){
                            ClassAddView()
                        }
                    }
                    RoundedRectangle(cornerRadius: 50, style: .continuous)
                        .frame(height: 2)
                        .padding(.horizontal)

                    List{
                        ForEach(viewModel.classes){ cl in
                            HStack{

                                Text(cl.name)
                                    .fontWeight(.medium)
                                    .frame(alignment: .leading)


                                    Text(cl.description)
                                        .fontWeight(.thin)
                                        .frame(maxWidth: .infinity, alignment: .trailing)

                                        .padding(.leading, 4)



                                Spacer()


                            }
                            .swipeActions(allowsFullSwipe: false) {
                                                        Button {
                                                            editClassSheet.toggle()
                                                        } label: {
                                                            Label("Edit", systemImage: "pencil")
                                                        }
                                                        .tint(.indigo)

                                                        Button(role: .destructive) {
                                                            classToEditOrDelete = cl
                                                            deleteClassAlert.toggle()
                                                        } label: {
                                                            Label("Delete", systemImage: "trash.fill")
                                                        }
                                                    }
                            .sheet(isPresented: $editClassSheet){
                                EditClassView(classToEdit: cl)
                            }
                        }
                    }

                    .listStyle(.plain)


                }

            }





        }
        .onAppear{
            let today = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "E"
            formatter.locale = Locale(identifier: "en_US")
            let todayDay = formatter.string(from: today)
            selectedIndex = dayToDayNumber[todayDay]!-1
        }
        .alert("Are you sure you want to delete this class?", isPresented: $deleteClassAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                viewModel.removeClass(cl: classToEditOrDelete!)
            }
                }
        .frame(maxHeight: .infinity, alignment: .top)
        .navigationTitle("Classes")
    }
    
    
}

struct ClassListView_Previews: PreviewProvider {
    static var previews: some View {
        ClassListView()
    }
}
public struct SegmentedPicker<Element, Content, Selection>: View
    where
    Content: View,
    Selection: View {

    public typealias Data = [Element]

    @State private var frames: [CGRect]
    @Binding private var selectedIndex: Data.Index?

    private let data: Data
    private let selection: () -> Selection
    private let content: (Data.Element, Bool) -> Content

    public init(_ data: Data,
                selectedIndex: Binding<Data.Index?>,
                @ViewBuilder content: @escaping (Data.Element, Bool) -> Content,
                @ViewBuilder selection: @escaping () -> Selection) {

        self.data = data
        self.content = content
        self.selection = selection
        self._selectedIndex = selectedIndex
        self._frames = State(wrappedValue: Array(repeating: .zero,
                                                 count: data.count))
    }

    public var body: some View {
        ZStack(alignment: Alignment(horizontal: .horizontalCenterAlignment,
                                    vertical: .center)) {

            if let selectedIndex = selectedIndex {
                selection()
                    .frame(width: frames[selectedIndex].width,
                           height: frames[selectedIndex].height)
                    .alignmentGuide(.horizontalCenterAlignment) { dimensions in
                        dimensions[HorizontalAlignment.center]
                    }
            }

            HStack(spacing: 0) {
                ForEach(data.indices, id: \.self) { index in
                    Button(action: { selectedIndex = index },
                           label: { content(data[index], selectedIndex == index) }
                    )
                    .buttonStyle(PlainButtonStyle())
                    .background(GeometryReader { proxy in
                        Color.clear.onAppear { frames[index] = proxy.frame(in: .global) }
                    })
                    .alignmentGuide(.horizontalCenterAlignment,
                                    isActive: selectedIndex == index) { dimensions in
                        dimensions[HorizontalAlignment.center]
                    }
                }
            }
        }
    }
}
extension HorizontalAlignment {
    private enum CenterAlignmentID: AlignmentID {
        static func defaultValue(in dimension: ViewDimensions) -> CGFloat {
            return dimension[HorizontalAlignment.center]
        }
    }

    static var horizontalCenterAlignment: HorizontalAlignment {
        HorizontalAlignment(CenterAlignmentID.self)
    }
}

extension View {
    @ViewBuilder
    @inlinable func alignmentGuide(_ alignment: HorizontalAlignment,
                                   isActive: Bool,
                                   computeValue: @escaping (ViewDimensions) -> CGFloat) -> some View {
        if isActive {
            alignmentGuide(alignment, computeValue: computeValue)
        } else {
            self
        }
    }

    @ViewBuilder
    @inlinable func alignmentGuide(_ alignment: VerticalAlignment,
                                   isActive: Bool,
                                   computeValue: @escaping (ViewDimensions) -> CGFloat) -> some View {

        if isActive {
            alignmentGuide(alignment, computeValue: computeValue)
        } else {
            self
        }
    }
}

