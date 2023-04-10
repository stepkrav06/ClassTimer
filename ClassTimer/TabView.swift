//
//  TabViewAdmin.swift
//
//  Tab view allowing to navigate the app for admin users
//
//

import SwiftUI

struct TabView: View {
    @State var selectedTab: Tab = .timer
    @State var color: Color = .teal
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom){
                Group{
                    switch selectedTab{
                    case .timer:
                        ContentView()
                    case .classes:
                        ContentView()
                    case .settings:
                        ContentView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                

                    HStack{
                        ForEach(tabItems) { item in
                            Button {
                                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)){
                                    selectedTab = item.tab
                                    color = item.color
                                }
                                
                                
                            } label: {
                                VStack(spacing: 0){
                                    Image(systemName: item.icon)
                                        .symbolVariant(.fill)
                                        .font(.body.bold())
                                        .frame(width: 44, height: 29)
                                    Text(item.text)
                                        .font(.caption2)
                                        .lineLimit(1)
                                }
                                .frame(maxWidth: .infinity)
                            }
                            .foregroundStyle(selectedTab == item.tab ? .primary : .secondary)
                            .blendMode(selectedTab == item.tab ? .overlay : .normal)
                        }
                    }
                    .padding(.horizontal, 8)
                    .padding(.top, 14)
                    .frame(height: 88, alignment: .top)
                    .background(.ultraThinMaterial, in:
                                    RoundedRectangle(cornerRadius: 34, style: .continuous))
                    .opacity(1)
                    .background(

                            HStack{
                                if selectedTab == .timer {
                                    Spacer()
                                        .frame(width: geometry.size.width/24)
                                }

                                if selectedTab == .classes {
                                    Spacer()
                                }
                                if selectedTab == .settings {
                                    Spacer()
                                    Spacer()
                                        .frame(width: geometry.size.width/24)
                                }
                                Circle().fill(color).frame(width: 80)
                                if selectedTab == .timer {
                                    Spacer()
                                }

                                if selectedTab == .classes {
                                    Spacer()
                                }
                                if selectedTab == .settings {
                                    Spacer()
                                        .frame(width: geometry.size.width/24)
                                }

                                
                            }
                            .padding(.horizontal, 8)

                    )
                    .overlay(
                            HStack{
                                if selectedTab == .timer {
                                    Spacer()
                                        .frame(width: geometry.size.width/24)
                                }

                                if selectedTab == .classes {
                                    Spacer()
                                }
                                if selectedTab == .settings {
                                    Spacer()
                                    Spacer()
                                        .frame(width: geometry.size.width/24)
                                }
                                Rectangle()
                                    .fill(color)
                                    .frame(width: 28, height: 5)
                                    .cornerRadius(3)
                                    .frame(width: 88)
                                    .frame(maxHeight: .infinity, alignment: .top)
                                if selectedTab == .timer {
                                    Spacer()
                                }

                                if selectedTab == .classes {
                                    Spacer()
                                }
                                if selectedTab == .settings {
                                    Spacer()
                                        .frame(width: geometry.size.width/24)
                                }



                                
                            }
                            .padding(.horizontal, 8)

                    )

                
                
                
                
            }
            
            
        }
        
    }
}

struct TabViewAdmin_Previews: PreviewProvider {
    static var previews: some View {
        TabView()
    }
}
