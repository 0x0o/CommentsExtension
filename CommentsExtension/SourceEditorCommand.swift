//
//  SourceEditorCommand.swift
//  CommentsExtension
//
//  Created by M1 on 2024/8/15.
//

import Foundation
import XcodeKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void) {
           switch invocation.commandIdentifier {
           case "\(Bundle.main.bundleIdentifier!).ToggleDocumentComments":
               toggleDocumentComments(with: invocation)
//               debugPrint("移除或添加 /// 的逻辑")
               break
           case "\(Bundle.main.bundleIdentifier!).ToggleBlockComments":
//               debugPrint("移除或添加 /*...*/ 的逻辑")
               toggleBlockComments(with: invocation)
               break
           default:
               break
           }
           completionHandler(nil)
       }
    
    ///"移除或添加 /// 的逻辑
    func toggleDocumentComments(with invocation: XCSourceEditorCommandInvocation) {
        // 获取选中的文本范围
        let selections = invocation.buffer.selections as! [XCSourceTextRange]
        
        // 判断是否需要移除还是添加注释
        var shouldRemove = false
        
        for selection in selections {
            for lineIndex in selection.start.line...selection.end.line {
                let line = invocation.buffer.lines[lineIndex] as! String
                if line.trimmingCharacters(in: .whitespaces).hasPrefix("///") {
                    shouldRemove = true
                    break
                }
            }
            if shouldRemove {
                break
            }
        }
        // 执行添加或移除操作
        for selection in selections {
            for lineIndex in selection.start.line...selection.end.line {
                var line = invocation.buffer.lines[lineIndex] as! String
                if shouldRemove {
                    // 去除行首的 "///"
                    if line.trimmingCharacters(in: .whitespaces).hasPrefix("///") {
                        let regex = try! NSRegularExpression(pattern: "///")
                        let newLine = regex.stringByReplacingMatches(in: line, options: [], range: NSRange(location: 0, length: line.utf16.count), withTemplate: "")
                        debugPrint("新行:\(newLine)")
                        invocation.buffer.lines[lineIndex] = newLine
                    }
                } else {
                    // 添加 "///" 到行首
                    line = "///" + line
                    // 更新缓冲区中的行
                    invocation.buffer.lines[lineIndex] = line
                }
               
            }
        }
    }

    
    ///移除或添加 /*...*/ 的逻辑
    func toggleBlockComments(with invocation: XCSourceEditorCommandInvocation) {
        let buffer = invocation.buffer
        let selections = buffer.selections
        let lines = buffer.lines

        guard let startRange = selections.firstObject as? XCSourceTextRange,
            let endRange = selections.lastObject as? XCSourceTextRange
        else {
            return
        }
        
        let isEmptyRange = (selections.count == 1 && startRange.isEmpty)
        
//        debugPrint("start at \(startRange)")
//        debugPrint("end at \(endRange)")
        
        let startLine = startRange.start.line
        
        let endLine: Int
        if endRange.end.column == 0 && endRange.end.line > startLine {
            endLine = endRange.end.line - 1
        } else {
            endLine = endRange.end.line
        }
        guard let startString = buffer.lines.object(at: max(0, startLine)) as? String,
            let endString = buffer.lines.object(at: min(endLine, buffer.lines.count - 1)) as? String,
            let preString = buffer.lines.object(at: max(0, startLine - 1)) as? String,
            let postString = buffer.lines.object(at: min(endLine + 1, buffer.lines.count - 1)) as? String
        else {
            return
        }
        
//        debugPrint("startLine is \(startString)")
//        debugPrint("endLine is \(endString)")
//        debugPrint("preLine is \(preString)")
//        debugPrint("postLine is \(postString)")

        let commented: Bool
        let surrounded: Bool
        
        if startString.drop(while: { (c) -> Bool in
            [" ", "\t"].contains(c)
        }).starts(with: "/*") && endString.drop(while: { (c) -> Bool in
            [" ", "\t"].contains(c)
        }).starts(with: "*/") {
            commented = true
            surrounded = false
        } else if preString.drop(while: { (c) -> Bool in
            [" ", "\t"].contains(c)
        }).starts(with: "/*") && postString.drop(while: { (c) -> Bool in
            [" ", "\t"].contains(c)
        }).starts(with: "*/") {
            commented = true
            surrounded = true
        } else {
            commented = false
            surrounded = false
        }
        
//        debugPrint("commented \(commented)")
//        debugPrint("surrounded \(surrounded)")
    
        if commented {
            
            if surrounded {
                removeComment(in: lines, atIndex: endLine + 1)
                removeComment(in: lines, atIndex: startLine - 1)
            } else {
                removeComment(in: lines, atIndex: endLine)
                removeComment(in: lines, atIndex: startLine)
            }
            
        } else {
            var numberOfIndentationCharacter = Int.max
            for index in startLine...endLine {
                if let line = lines.object(at: index) as? String {
                    if line == "\n" && startLine != endLine { continue }
                    numberOfIndentationCharacter = min(line.prefix{ [" ", "\t"].contains($0) }.reduce(0){ $0 + ($1 == "\t" ? buffer.tabWidth : 1) }, numberOfIndentationCharacter)
                }
            }
            
            var prefix: String
            if buffer.usesTabsForIndentation {
                prefix = Array<String>.init(repeating: "\t", count: numberOfIndentationCharacter / buffer.tabWidth).joined() + Array<String>.init(repeating: " ", count: numberOfIndentationCharacter % buffer.tabWidth).joined()
            } else {
                prefix = Array<String>.init(repeating: " ", count: numberOfIndentationCharacter).joined()
            }
            
//            debugPrint("insert \"\(prefix)*/\"at line \(endLine + 1)")
            lines.insert("\(prefix)*/", at: endLine + 1)
//            debugPrint("insert \"\(prefix)/*\"at line \(startLine)")
            lines.insert("\(prefix)/*", at: startLine)
            
            if startRange.start.column == 0 {
                startRange.start.line += 1
                if isEmptyRange {
                    endRange.end.line += 1
                }
            }
        }
    }
    
    private func removeComment(in lines: NSMutableArray, atIndex index: Int) {
        guard let line = lines.object(at: index) as? NSString else { return }
        let newLine = line.replacingOccurrences(of: "*/", with: "").replacingOccurrences(of: "/*", with: "")
        if newLine.isEmptyLine {
            lines.removeObject(at: index)
        } else {
            lines[index] = newLine
        }
    }
    
}
