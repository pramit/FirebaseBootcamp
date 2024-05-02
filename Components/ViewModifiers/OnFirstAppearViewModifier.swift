//
//  OnFirstAppearViewModifier.swift
//  FirebaseBootcamp
//
//  Created by Pramit Rashinkar on 8/28/23.
//

import SwiftUI

struct OnFirstAppearViewModifier: ViewModifier {
    
    @State private var didAppear: Bool = false
    let perform: (() -> Void)?
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                if !didAppear {
                    perform?()
                    didAppear = true
                }
            }
    }
}
