//
//  CopyListener.swift
//  MacClips
//
//  Created by blank on 2022/8/19.
//

import Foundation
import AppKit

class Clipboard {
  typealias Hook = (String) -> Void
  typealias HookImg = (Data) ->Void
  private let pasteboard = NSPasteboard.general
  private let timerInterval = 1.0

  private var changeCount: Int
  private var hooks: [Hook]
  private var hookImgs:[HookImg]

  init() {
    changeCount = pasteboard.changeCount
    hooks = []
    hookImgs = []
  }

  func onNewCopy(_ hook: @escaping Hook) {
    hooks.append(hook)
  }
 func onNewCopyImg(_ hookImg: @escaping HookImg) {
      hookImgs.append(hookImg)
    }

  func startListening() {
    Timer.scheduledTimer(timeInterval: timerInterval,
                         target: self,
                         selector: #selector(checkForChangesInPasteboard),
                         userInfo: nil,
                         repeats: true)
  }

  func copy(_ string: String) {
    pasteboard.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
    pasteboard.setString(string, forType: NSPasteboard.PasteboardType.string)
  }

  @objc
  func checkForChangesInPasteboard() {
    guard pasteboard.changeCount != changeCount else {
      return
    }

    if let lastItem = pasteboard.string(forType: NSPasteboard.PasteboardType.string) {
      for hook in hooks {
        hook(lastItem)
      }
    }
      
      if let lastItem = pasteboard.data(forType: NSPasteboard.PasteboardType.tiff
      ) {
        for hookImg in hookImgs {
            hookImg(lastItem)
        }
      }
      
    changeCount = pasteboard.changeCount
  }
}

