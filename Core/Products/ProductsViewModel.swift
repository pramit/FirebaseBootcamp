//
//  ProductsViewModel.swift
//  FirebaseBootcamp
//
//  Created by Pramit Rashinkar on 8/27/23.
//

import Foundation
import FirebaseFirestore

@MainActor
final class ProductsViewModel: ObservableObject {
    @Published private(set) var products: [Product] = []
    @Published var selectedFilter: FilterOption? = nil
    @Published var selectedCategory: CategoryOption? = nil
    private var lastDocument: DocumentSnapshot? = nil
    
    enum FilterOption: String, CaseIterable {
        case noFilter
        case priceHigh
        case priceLow
        
        var priceDescending: Bool? {
            switch self {
            case .noFilter: return nil
            case .priceHigh: return true
            case .priceLow: return false
            }
        }
    }
    
    func filterSelected(option: FilterOption) async throws {
        self.selectedFilter = option
        
        // reset filters with each query
        self.products = []
        self.lastDocument = nil
        
        self.getProducts()
    }
    
    enum CategoryOption: String, CaseIterable {
        case noCategory
        case smartphones
        case laptops
        case fragrances
        
        var categoryKey: String? {
            if self == .noCategory {
                return nil
            }
            return self.rawValue
        }
    }
    
    func categorySelected(option: CategoryOption) async throws {
        self.selectedCategory = option
        
        // reset filters with each query
        self.products = []
        self.lastDocument = nil
        
        self.getProducts()
    }
    
    func getProducts() {
        Task {
            let (newProducts, lastDocument) = try await ProductsManager.shared.getAllProducts(priceDescending: selectedFilter?.priceDescending, forCategory: selectedCategory?.categoryKey, count: 5, lastDocument: lastDocument)
            
            self.products.append(contentsOf: newProducts)
            
            if let lastDocument {
                self.lastDocument = lastDocument
            }
        }
    }
    
    func getProductsCount() {
        
        Task {
            return try await ProductsManager.shared.getAllProductsCount()
        }

    }
    
    func addUserFavoriteProduct(productId: Int) {
        Task {
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            try await UserManager.shared.addUserFavoriteProduct(userId: authDataResult.uid, productId: productId)
        }
    }
    
//    func getProductsByRating() {
//        Task {
//            let (newProducts, lastDocument) = try await ProductsManager.shared.getProductsByRating(count: 3, lastDocument: lastDocument)
//            self.products.append(contentsOf: newProducts)
//            self.lastDocument = lastDocument
//
//        }
//    }
    
}
