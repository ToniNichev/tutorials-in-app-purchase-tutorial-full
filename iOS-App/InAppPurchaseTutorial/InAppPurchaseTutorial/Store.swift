import StoreKit

@MainActor final class Store: ObservableObject {
    private var productIDs = ["InAppPurchaseTutorialToniconsumableFuel", "InAppPurchaseTutorialToniConsumableOil", "BrakePads", "InAppPurchaseRenewalPro"]
    private var updates: Task<Void, Never>?
    
    @Published var products = [Product]()
    @Published var activeTransactions: Set<StoreKit.Transaction> = []
    
    init() {
        Task {
            await requestProducts()
        }
        Task {
            await transactionUpdates()
        }
    }
    
    deinit {
        updates?.cancel()
    }
    
    func transactionUpdates () async {
        for await update in StoreKit.Transaction.updates {
            if let transaction = try? update.payloadValue {
                activeTransactions.insert(transaction)
                await transaction.finish()
            }
            }
    }
    
    func requestProducts() async {
        do {
            products = try await Product.products(for: productIDs)
        } catch {
            print(error)
        }
    }
    
    func purchaseProduct(_ product: Product) async throws {
        print("Purchase tapped ...")
        let result = try await product.purchase()
        switch result {
        case .success(let verifyResult):
            print("Purchase successfull!")
            if let transaction = try? verifyResult.payloadValue {
                activeTransactions.insert(transaction)
                print("PURCHASE:")
                try print(verifyResult.payloadValue)
                print(transaction)
                await transaction.finish()
            }
        
        case .userCancelled:
            print("Purchase Canceled !")
            break
        case .pending:
            print("Purchase pending ...")
            break
        @unknown default:
            break
        }
    }
    
    func fetchActiveTransactions() async {
        var activeTransactions: Set<StoreKit.Transaction> = []
        for await entitelment in StoreKit.Transaction.currentEntitlements {
            if let transaction = try? entitelment.payloadValue {
                activeTransactions.insert(transaction)
                print("fetchActiveTransactions: ")
                print(transaction)
            }
        }
    }
}
