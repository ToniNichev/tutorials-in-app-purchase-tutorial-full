//
//  ContentView.swift
//  InAppPurchaseTutorial
//
//  Created by Toni Nichev on 1/2/24.
//

import SwiftUI
import StoreKit

struct ContentView: View {
    @EnvironmentObject var store: Store
    
    var body: some View {
        

        VStack {
            Text("Welcome to my store").font(.title)
            ProductView(id: "InAppPurchaseTutorialToniconsumableFuel") {
                Image(systemName: "crown")
            }
            .productViewStyle(.compact)
            .padding()
            .onInAppPurchaseCompletion { product, result in
                if case .success(.success(let transaction)) = result {
                    print("Purchased successfully: \(transaction.signedDate)")
                } else {
                    print("Something else happened")
                }
            }
        }
        
        Section(header: Text("To buy:").font(.title)) {
            ForEach(store.products, id: \.id)  { product in
                Button {
                    Task {
                        try await store.purchaseProduct(product)
                    }
                } label: {
                    HStack {
                        Text(product.displayName + ":")
                        Text(verbatim: product.displayPrice)
                    }
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }
}

#Preview {
    ContentView().environmentObject(Store())
}
