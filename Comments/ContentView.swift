//
//  ContentView.swift
//  Comments
//
//  Created by M1 on 2024/8/15.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
//        https://stackoverflow.com/questions/67278130/how-can-we-remove-comments-from-apple-documentation-code 可以去宣传一波
        InstructionsView()
    }
}

#Preview {
    ContentView()
}

import SwiftUI

struct InstructionsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("How to Install")
                .font(.title2)
                .bold()

            VStack(alignment: .leading, spacing: 10) {
                Text("1. Run the application at least once.")
                Text("2. Open **System Preferences**.")
                Text("3. Click on **Extensions** and select **Xcode Source Editor**.")
                Text("   (Note: The location may vary depending on your macOS version.)")
                Text("4. Make sure the checkbox next to **Comments** is selected.")
                Text("5. Relaunch Xcode.")
            }
            .padding(.leading)

            Text("How to Set a Hot Key")
                .font(.title2)
                .bold()
                .padding(.top, 20)

            VStack(alignment: .leading, spacing: 10) {
                Text("1. After relaunching Xcode, go to **Xcode** > **Preferences** > **Key Bindings**.")
                Text("2. Search for `commentsExtension`.")
                Text("3. Assign a new hot key of your choice.")
            }
            .padding(.leading)
        }
        .padding()
    }
}

struct InstructionsView_Previews: PreviewProvider {
    static var previews: some View {
        InstructionsView()
    }
}
