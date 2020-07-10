//
//  HomeViewController.swift
//  CreateJSONFile
//
//  Created by less on 2020/1/3.
//  Copyright © 2020 Less. All rights reserved.
//

import Cocoa
import SwiftyJSON
import Alamofire

class HomeViewController: NSViewController {
    
    fileprivate lazy var mainSplitView: MainSplitView = {
        let splitView = MainSplitView(frame: CGRect(x: 0, y: 0, width: self.view.width, height: self.view.height))
        splitView.autoresizingMask = [.height, .width]
        splitView.isVertical = true
        splitView.dividerStyle = .thin
        splitView.delegate = self
        return splitView
    }()
    
    override func viewWillAppear() {
        super.viewWillAppear()
        view.window?.isRestorable = false
        view.window?.setContentSize(CGSize(width: 1200, height: 800))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        print(Date.dateWithStr(time: "2020-01-09T03:57:59.000+0000").formattingDate("yyyy-MM-dd HH:mm:ss"))
        initView()
    }
    
    // MARK:- initView
    fileprivate func initView() {
        
        let leftView = MainLeftView(frame: NSRect(x: 0, y: 0, width: 0, height: mainSplitView.height))
        leftView.autoresizingMask = [.width, .height]
        
        let rightView = MainRightView(frame: NSRect(x: 0, y: 0, width: mainSplitView.width, height: mainSplitView.height))
        rightView.autoresizingMask = [.width, .height]
        
//        mainSplitView.addArrangedSubview(leftView)
//        mainSplitView.addArrangedSubview(rightView)
        view.addSubview(rightView)
    

        
    }

    
}
    
extension HomeViewController: NSSplitViewDelegate {
    
    func splitView(_ splitView: NSSplitView, constrainMinCoordinate proposedMinimumPosition: CGFloat, ofSubviewAt dividerIndex: Int) -> CGFloat {
        return 200
    }



    func splitView(_ splitView: NSSplitView, constrainMaxCoordinate proposedMaximumPosition: CGFloat, ofSubviewAt dividerIndex: Int) -> CGFloat {
        return 500
    }

    func splitView(_ splitView: NSSplitView, shouldAdjustSizeOfSubview view: NSView) -> Bool {
        if view == splitView.subviews[1] {
            return true
        }
        return false
    }
}

class ContentView: NSView {
    
    override var isFlipped: Bool {
        return true
    }
}
