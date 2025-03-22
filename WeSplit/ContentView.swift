//
//  ContentView.swift
//  WeSplit
//
//  Created by Anastasiia Kotova on 21.03.25.
//

import SwiftUI

struct ContentView: View {
    @State private var checkAmount: String = ""
    @State private var numberOfPeople = 0
    @State private var tipPercentage: Int
    @FocusState private var amountIsFocused: Bool

    var tipPercentages = [0, 5, 10, 15, 20]

    var currencySymbol: String {
        Locale.current.currencySymbol ?? "€"
    }

    var currencyFormatter = Locale.current.currency?.identifier ?? "EUR"

    var tipAmount: Double {
        (Double(checkAmount.replacingOccurrences(of: ",", with: ".")) ?? 0.0) * Double(tipPercentage) / 100
    }

    var totalAmount: Double {
        (Double(checkAmount.replacingOccurrences(of: ",", with: ".")) ?? 0.0) + tipAmount
    }

    var totalPerPerson: Double {
        let peopleCount = Double(numberOfPeople + 2)
        return totalAmount / peopleCount
    }

    init() {
        _tipPercentage = State(initialValue: tipPercentages.first ?? 0)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color("MyGreenColor").ignoresSafeArea()
                Form {
                    Section {
                        HStack {
                            Text(currencySymbol)
                                .foregroundStyle(.gray)
                            
                            TextField("0,00", text: $checkAmount)
                                .keyboardType(.decimalPad)
                                .focused($amountIsFocused)
                                .onTapGesture {
                                        checkAmount = ""
                                }
                                .onChange(of: checkAmount) {
                                    checkAmount = formatInput(checkAmount)
                                }
                        }

                        Picker("Number of people", selection: $numberOfPeople) {
                            ForEach(2..<18) {
                                Text("\($0) people")
                            }
                        }
                        .pickerStyle(.navigationLink)
                    }

                    Section {
                        Picker("Tip", selection: $tipPercentage) {
                            ForEach(tipPercentages, id: \.self) {
                                Text($0, format: .percent)
                            }
                        }
                        .pickerStyle(.segmented)
                    } header: {
                        Text("Choose tip amount")
                            .foregroundStyle(.black)
                            .bold()
                    }

                    Section {
                        Text("Amount per person").bold()
                        Text(totalPerPerson, format: .currency(code: currencyFormatter))
                        Text("Total tips amount").bold()
                        Text(tipAmount, format: .currency(code: currencyFormatter))
                        Text("Total with tips").bold()
                        Text(totalAmount, format: .currency(code: currencyFormatter))
                    }
                }
                .navigationTitle("WeSplit")
                .scrollContentBackground(.hidden)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        if amountIsFocused {
                            Button("Clear") {
                                checkAmount = ""
                            }
                            Button("Done") {
                                amountIsFocused = false
                            }
                        }
                    }
                }
            }
        }
    }

    private func formatInput(_ input: String) -> String {
        let filtered = input.filter { "0123456789,".contains($0) }

        let components = filtered.split(separator: ",")
        if components.count > 2 {
            return String(components[0]) + "," + String(components.dropFirst().joined())
        }

        if let decimalIndex = filtered.firstIndex(of: ",") {
            let afterDecimal = filtered.distance(from: decimalIndex, to: filtered.endIndex)
            if afterDecimal > 3 {
                return String(filtered.prefix(filtered.distance(from: filtered.startIndex, to: decimalIndex) + 3))
            }
        }

        return filtered
    }
}

#Preview {
    ContentView()
}
