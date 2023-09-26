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
                List {
                    ForEach(model.restaurants.indices, id:\.self) {index in
                        NavigationLink(destination: ReservationForm( model.restaurants[index])) {
                            VStack(alignment: .leading) {
                                Text(model.restaurants[index].city)
                                    .padding(.bottom, 3)
                                Text("\(model.restaurants[index].neighborhood) - \(model.restaurants[index].phoneNumber)")
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                            }
                            .padding(.bottom, 5)
                        }
                    }
                }
                .navigationBarTitle("Locations")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarHidden(true)
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
