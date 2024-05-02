//
//  ProductsManager.swift
//  FirebaseBootcamp
//
//  Created by Pramit Rashinkar on 8/27/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

final class ProductsManager {
    
    // singleton
    static let shared = ProductsManager()
    private init() { }
    
    // collection handler
    private let productsCollection = Firestore.firestore().collection("products")
    
    // document handler (within collection)
    private func productDocument(productId: String) -> DocumentReference {
        productsCollection.document(productId)
    }
    
    // upload new product document
    func uploadProduct(product: Product) async throws {
        try productDocument(productId: String(product.id)).setData(from: product, merge: false)
    }
    
    // get product document
    func getProduct(productId: String) async throws -> Product {
        try await productDocument(productId: productId).getDocument(as: Product.self)
    }
    
//    // get ALL product documents
//    func getAllProducts() async throws -> [Product] {
//        try await productsCollection
//            //.limit(to: 5) // get only first 5 products
//            .getDocuments(as: Product.self)
//    }
//
//    // get all products sorted by price
//    private func getAllProductsSortedByPrice(descending: Bool) async throws -> [Product] {
//        try await productsCollection
//            .order(by: Product.CodingKeys.price.rawValue, descending: descending)
//            .getDocuments(as: Product.self)
//    }
//
//    // get all products in category
//    private func getAllProductsForCategory(category: String) async throws -> [Product] {
//        try await productsCollection
//            .whereField(Product.CodingKeys.category.rawValue, isEqualTo: category)
//            .getDocuments(as: Product.self)
//    }
//
//    // get all products sorted by price + in category
//    private func getAllProductsByPriceAndCategory(descending: Bool, category: String) async throws -> [Product] {
//        try await productsCollection
//            .whereField(Product.CodingKeys.category.rawValue, isEqualTo: category)
//            .order(by: Product.CodingKeys.price.rawValue, descending: descending)
//            .getDocuments(as: Product.self)
//    }
    
    // MARK: QUERY VERSIONS
    
    // query to get all products
    func getAllProductsQuery() -> Query {
        productsCollection
    }
    
    // query to get products sorted by price
    private func getAllProductsSortedByPriceQuery(descending: Bool) -> Query {
        productsCollection
            .order(by: Product.CodingKeys.price.rawValue, descending: descending)
    }
    
    // query to get products in category
    private func getAllProductsForCategoryQuery(category: String) -> Query {
        productsCollection
            .whereField(Product.CodingKeys.category.rawValue, isEqualTo: category)
    }
    
    // query to get products sorted by price + in category
    private func getAllProductsByPriceAndCategoryQuery(descending: Bool, category: String) -> Query {
        productsCollection
            .whereField(Product.CodingKeys.category.rawValue, isEqualTo: category)
            .order(by: Product.CodingKeys.price.rawValue, descending: descending)
    }
    
    // USING ABOVE QUERIES, get all products with sorters / filters
    func getAllProducts(priceDescending descending: Bool?, forCategory category: String?, count: Int, lastDocument: DocumentSnapshot?) async throws -> (products: [Product], lastDocument: DocumentSnapshot?) {
        var query: Query = getAllProductsQuery()
        
        if let descending, let category {
            query = getAllProductsByPriceAndCategoryQuery(descending: descending, category: category)
        } else if let descending {
            query = getAllProductsSortedByPriceQuery(descending: descending)
        } else if let category {
            query = getAllProductsForCategoryQuery(category: category)
        }
        
        return try await query
            .limit(to: count)
            .startOptionally(afterDocument: lastDocument)
            .getDocumentsWithSnapshot(as: Product.self)
    }
    
    func getProductsByRating(count: Int, lastRating: Double?) async throws -> [Product] {
        try await productsCollection
            .order(by: Product.CodingKeys.rating.rawValue, descending: true)
            .limit(to: count)
            .start(after: [lastRating ?? 9999999]) // starts at the last rating
            .getDocuments(as: Product.self)
    }
    
    func getProductsByRating(count: Int, lastDocument: DocumentSnapshot?) async throws -> (products: [Product], lastDocument: DocumentSnapshot?) {
        if let lastDocument {
            return try await productsCollection
                .order(by: Product.CodingKeys.rating.rawValue, descending: true)
                .limit(to: count)
                .start(afterDocument: lastDocument)
                .getDocumentsWithSnapshot(as: Product.self)
        } else {
            return try await productsCollection
                .order(by: Product.CodingKeys.rating.rawValue, descending: true)
                .limit(to: count)
                .getDocumentsWithSnapshot(as: Product.self)
        }
    }
    
    // SAVE MONEY! Get # of products as Int directly from SERVER without loading all products (costs $$) and then counting them.
    func getAllProductsCount() async throws -> Int {
        
        try await productsCollection.aggregateCount()
        
//        let snapshot = try await productsCollection.count.getAggregation(source: .server)
//        return snapshot.count.intValue
        
//        try await productsCollection
//            .aggregateCount()
    }
    
//    private func getAllProducts() async throws -> [Product] {
//        try await productsCollection
//            .getDocuments(as: Product.self)
//    }
//
//
//    func getAllProducts(priceDescending descending: Bool?, forCategory category: String?, count: Int, lastDocument: DocumentSnapshot?) async throws -> (products: [Product], lastDocument: DocumentSnapshot?) {
//        var query: Query = getAllProductsQuery()
//
//        if let descending, let category {
//            query = getAllProductsByPriceAndCategoryQuery(descending: descending, category: category)
//        } else if let descending {
//            query = getAllProductsSortedByPriceQuery(descending: descending)
//        } else if let category {
//            query = getAllProductsForCategoryQuery(category: category)
//        }
//
//        return try await query
//            .startOptionally(afterDocument: lastDocument)
//            .getDocumentsWithSnapshot(as: Product.self)
//    }
//
    
    
}



/*
 func addListenerForAllUserFavoriteProducts(userId: String) -> AnyPublisher<[UserFavoriteProduct], Error> {
     let publisher = PassthroughSubject<[UserFavoriteProduct], Error>()
     
     // asynchronous part
     self.userFavoriteProductsListener = userFavoriteProductCollection(userId: userId).addSnapshotListener { querySnapshot, error in
         guard let documents = querySnapshot?.documents else {
             print("No documents")
             return
         }
         
         let products: [UserFavoriteProduct] = documents.compactMap({ try? $0.data(as: UserFavoriteProduct.self) })
         publisher.send(products)
     }
     
     return publisher.eraseToAnyPublisher()
 }
 */
