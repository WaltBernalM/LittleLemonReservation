//
//  LocationsView.swift
//  LittleLemonReservation
//
//  Created by Walter Bernal Montero on 25/09/23.
//

import SwiftUI

struct LocationsView: View {
    @EnvironmentObject var model: Model
    var body: some View {
        VStack {
            LittleLemonLogo()
                .padding(.top, 50)
            
            Text(model.displayingReservationForm ? "Reservation Details" : "Select a location")
                .padding([.leading, .trailing], 40)
                .padding([.top, .bottom], 8)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(20)
            
            NavigationView {
                List (model.restaurants, id:\.self) { restaurant in
                    NavigationLink(destination: ReservationForm(restaurant)) {
                        RestaurantView(restaurant)
                    }
                }
                .navigationBarTitle("Locations")
                .navigationBarHidden(true)
                .navigationBarTitleDisplayMode(.inline)
                .scrollContentBackground(.hidden)
            }
        }
        .padding(.top, -10)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LocationsView().environmentObject(Model())
    }
}
