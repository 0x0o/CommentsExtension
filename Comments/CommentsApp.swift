//
//  CommentsApp.swift
//  Comments
//
//  Created by M1 on 2024/8/15.
//

import SwiftUI

@main
struct CommentsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(maxWidth: 600, maxHeight: 400)
        }
        .defaultSize(width: 600, height: 400)
        .windowResizability(.contentSize)
    }
}
