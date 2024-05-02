//
//  ProductCellViewBuilder.swift
//  FirebaseBootcamp
//
//  Created by Pramit Rashinkar on 8/27/23.
//

import SwiftUI

struct ProductCellViewBuilder: View {
    
    let productId: String
    @State private var product: Product? = nil
    
    var body: some View {
        ZStack {
            if let product {
                ProductCellView(product: product)
            }
        }
        .task {
            self.product = try? await ProductsManager.shared.getProduct(productId: productId)
        }
    }
}

struct ProductCellViewBuilder_Previews: PreviewProvider {
    static var previews: some View {
        ProductCellViewBuilder(productId: "1")
    }
}
