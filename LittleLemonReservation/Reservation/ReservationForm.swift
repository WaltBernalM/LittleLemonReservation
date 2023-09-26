//
//  ReservationForm.swift
//  LittleLemonReservation
//
//  Created by Walter Bernal Montero on 25/09/23.
//

import SwiftUI

struct ReservationForm: View {
    @EnvironmentObject var model: Model
    
    @State var showFormInvalidMessage = false
    @State var errorMessage = ""
    
    private var restaurant: RestaurantLocation
    @State var reservationDate = Date()
    @State var party: Int = 1
    @State var specialRequests: String = ""
    @State var customerName: String = ""
    @State var customerPhoneNumber: String = ""
    @State var customerEmail: String = ""
    
    // This environment variable stores the presentation mode status
    // of this view. THis will be used to dismiss this view when
    // the user taps on RESERVE
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    // Stores a temporary reservation used by this view
    @State private var temporaryReservation = Reservation()
    
    // This flag will trigger .onChange
    // this is necessary because due to a SwiftUI limitation, we cannot
    // change the model values from whitin the view itself, as it is being drawn
    // (inside the button), soe hits flag will defer the change
    @State var mustChangeReservation = false
    
    // initializes the instance of RestaurantLocation
    init(_ restaurant: RestaurantLocation) {
        self.restaurant = restaurant
    }
    
    var body: some View {
        VStack {
            Form {
                RestaurantView(restaurant)
                HStack {
                    VStack (alignment: .leading) {
                        Text("PARTY").font(.subheadline)
                        TextField("",
                                  value: $party,
                                  formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                        /* TODO */
                    }
                    VStack {
                        DatePicker(selection: $reservationDate, in: Date()..., displayedComponents: [.date, .hourAndMinute]) {
//                             Text("Select a date")
                        }
                    }
                }
                .padding([.top, .bottom], 20)
                
                Group {
                    Group {
                        HStack {
                            Text("Name: ").font(.subheadline)
                            TextField("Your name...", text: $customerName)
                        }
                        HStack {
                            Text("Phone: ").font(.subheadline)
                            TextField("Your phone number...", text: $customerPhoneNumber)
                        }
                        HStack {
                            Text("E-mail: ").font(.subheadline)
                            TextField("Your e-mail...", text: $customerEmail)
                        }
                        TextField("add any special request (optional)", text: $specialRequests, axis: .vertical)
                            .padding()
                            .overlay(RoundedRectangle(cornerRadius: 20).stroke(.gray.opacity(0.2)))
                            .lineLimit(6)
                            .padding([.top, .bottom], 20)
                    }
                    
                    Button(action: {
                        /* TODO */
                    }, label: {
                        Text("Confirm reservation")
                    })
                    .padding(.init(top: 10, leading:30, bottom: 10, trailing: 30))
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(20)
                    .padding(.top, 10)
                }
            }
            
            // Forms have this space between the title and the content that is
            // almost impossible to removew without incurring into complex.
            // So, this is a hack, to bring the content up
            .padding(.top, -40)
            
            // Makes the form background invisible, the original color is gray
            .scrollContentBackground(.hidden)
            
            .onChange(of: mustChangeReservation) { _ in
                model.reservation = temporaryReservation
            }
            // TODO
        }
        .onAppear {
            model.displayingReservationForm = true
        }
        .onDisappear {
            model.displayingReservationForm = false
        }
    }
    
    private func validateForm() {
        let nameIsValid = isValid(name: customerName)
        let emailIsValid = isValid(email: customerEmail)
        
        guard nameIsValid && emailIsValid
        else {
            var invalidNameMessage = ""
            if customerName.isEmpty || !isValid(name: customerName) {
                invalidNameMessage = "Names can only contain letters and must have at least 3 characters.\n\n"
            }
            var invalidPhoneMessage = ""
            if !customerPhoneNumber.isEmpty {
                invalidPhoneMessage = "The phone number cannot be blank.\n\n"
            }
            var invalidEmailMessage = ""
            if !customerEmail.isEmpty || !isValid(email: customerEmail) {
                invalidEmailMessage = "The email is invalid and cannot be blank"
            }
            
            self.errorMessage = "Found these errors in the form:\n\n \(invalidNameMessage)\(invalidPhoneMessage) \(invalidEmailMessage)"
            showFormInvalidMessage.toggle()
            return
        }
        
        // Form is valid, lets proceed
        
        // Creation of temporary reservation
        let temporaryReservation = Reservation(restaurant: restaurant, customerName: customerName, customerEmail: customerEmail, customerPhoneNumber: customerPhoneNumber, reservationDate: reservationDate, party: party, specialRequests: specialRequests)
        
        // Store the temporary reservation locally
        self.temporaryReservation = temporaryReservation
        
        // Set flag to defer changin to the model (see .onChange)
        self.mustChangeReservation.toggle()
        
        // Dismiss this view
        self.presentationMode.wrappedValue.dismiss()
    }
    
    func isValid(name: String) -> Bool {
        guard !name.isEmpty, name.count > 2
        else { return false }
        for chr in name {
            if (!(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z") && !(chr == " ")) {
                return false
            }
        }
        return true
    }
    
    func isValid(email: String) -> Bool {
        guard !email.isEmpty else { return false }
        let emailValidationRegex = "^[\\p{L}0-9!#$%&'*+\\/=?^_`{|}~-][\\p{L}0-9.!#$%&'*+\\/=?^_`{|}~-]{0,63}@[\\p{L}0-9-]+(?:\\.[\\p{L}0-9-]{2,7})*$"
        let emailValidationPredicate = NSPredicate(format: "SELF MATCHES %@", emailValidationRegex)
        return emailValidationPredicate.evaluate(with: email)
    }
}

struct ReservationForm_Previews: PreviewProvider {
    static var previews: some View {
        let sampleRestaurant = RestaurantLocation(city: "Las Vegas", neighborhood: "Downtown", phoneNumber: "(702) 555-9898")
        ReservationForm(sampleRestaurant).environmentObject(Model())
    }
}
