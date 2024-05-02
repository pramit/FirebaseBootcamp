//
//  FavoriteView.swift
//  FirebaseBootcamp
//
//  Created by Pramit Rashinkar on 8/28/23.
//

import SwiftUI

struct FavoriteView: View {
    
    @StateObject private var viewModel = FavoriteViewModel()
    @State private var didAppear: Bool = false
    
    var body: some View {
        List {
            ForEach(viewModel.userFavoriteProducts, id: \.id.self) { faveProduct in
                ProductCellViewBuilder(productId: faveProduct.productId.description)
                    .contextMenu {
                        Button("Remove from favorites") {
                            viewModel.removeFromFavorites(faveProductId: faveProduct.id)
                        }
                    }
            }
        }
        .navigationTitle("Favorites")
        //.modifier(OnFirstAppearViewModifier)
        .onFirstAppear {
            viewModel.addListenerForFavorites()
        }
    }
}

struct FavoriteView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            FavoriteView()
        }
    }
}



extension View {
    func onFirstAppear(perform: (() -> Void)?) -> some View {
        modifier(OnFirstAppearViewModifier(perform: perform))
    }
}
