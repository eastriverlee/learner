//
//  Learner.swift
//  Shared
//
//  Created by dan lee on 2021/09/15.
//

import SwiftUI

@main
struct Learner: App {
    var body: some Scene {
        WindowGroup {
			ContentView().onAppear(perform: test)
        }
    }
}
