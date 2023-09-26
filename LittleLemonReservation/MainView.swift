//
//  ContentView.swift
//  LittleLemonReservation
//
//  Created by Walter Bernal Montero on 25/09/23.
//

import SwiftUI

struct MainView: View {
    @StateObject var model = Model()
    @State var tabSection = 0
    
    var body: some View {
        TabView(selection: $model.tabViewSelectedIndex) {
            LocationsView()
                .tag(0)
                .tabItem {
                    if !model.displayingReservationForm {
                        Label("Locations", systemImage: "fork.knife")
                    }
                }
            
            ReservationView()
                .tag(1)
                .tabItem {
                    if !model.displayingReservationForm {
                        Label("Reservation", systemImage: "square.and.pencil")
                    }
                }
        }
        .environmentObject(model)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
