//
//  SwiftUICompressionFolderApp.swift
//  SwiftUICompressionFolder
//
//  Created by Angelos Staboulis on 26/11/24.
//

import SwiftUI

@main
struct SwiftUICompressionFolderApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(sourceFolder: "", destinationFolder: "").frame(width: 450, height: 250)
            .windowResizeBehavior(.disabled)
        }.windowResizability(.contentSize)
    }
}
