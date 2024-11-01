//
//  SourceEditorExtension.swift
//  CommentsExtension
//
//  Created by M1 on 2024/8/15.
//

import Foundation
import XcodeKit

class SourceEditorExtension: NSObject, XCSourceEditorExtension {
    
    /*
    func extensionDidFinishLaunching() {
        // If your extension needs to do any work at launch, implement this optional method.
    }
    */
    
    var commandDefinitions: [[XCSourceEditorCommandDefinitionKey: Any]] {
        return [
            [
                XCSourceEditorCommandDefinitionKey.identifierKey: "\(Bundle.main.bundleIdentifier!).ToggleDocumentComments",
                XCSourceEditorCommandDefinitionKey.classNameKey: "\(Bundle.main.infoDictionary?["CFBundleName"] as! String).SourceEditorCommand",
                XCSourceEditorCommandDefinitionKey.nameKey: "Toggle Document Comments ///"
            ],
            [
                XCSourceEditorCommandDefinitionKey.identifierKey: "\(Bundle.main.bundleIdentifier!).ToggleBlockComments",
                XCSourceEditorCommandDefinitionKey.classNameKey: "\(Bundle.main.infoDictionary?["CFBundleName"] as! String).SourceEditorCommand",
                XCSourceEditorCommandDefinitionKey.nameKey: "Toggle Block Comments /*...*/"
            ]
        ]
    }
    
//    var commandDefinitions: [[XCSourceEditorCommandDefinitionKey: Any]] {
//        guard let bundleIdentifier = Bundle.main.bundleIdentifier,
//              let bundleName = Bundle.main.infoDictionary?["CFBundleName"] as? String else {
//            return []
//        }
//
//        func makeDefinition(identifier: String, name: String) -> [XCSourceEditorCommandDefinitionKey: Any] {
//            return [
//                .identifierKey: "\(bundleIdentifier).\(identifier)",
//                .classNameKey: "\(bundleName).\(NSStringFromClass(SourceEditorCommand.self))",
//                .nameKey: name
//            ]
//        }
//
//        return [
//            makeDefinition(identifier: "ToggleDocumentComments", name: "Toggle Document Comments ///"),
//            makeDefinition(identifier: "ToggleBlockComments", name: "Toggle Block Comments /*...*/")
//        ]
//    }

}

extension String {
    var isEmptyLine: Bool {
        var result = true
        for c in self {
            if ![" ", "\t", "\n"].contains(c) {
                result = false
                break
            }
        }
        return result
    }
}

extension XCSourceTextRange {
    var isEmpty: Bool {
        return start.column == end.column && start.line == end.line
    }
}
