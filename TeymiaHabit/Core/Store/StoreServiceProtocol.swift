import StoreKit

@MainActor
protocol StoreServiceProtocol: AnyObject {
    var products: [Product] { get }
    var isPremium: Bool { get }
    
    func loadProducts() async
    func purchase(_ product: Product) async throws -> Bool
    func restorePurchases() async throws
}
