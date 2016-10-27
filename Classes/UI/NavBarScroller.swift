//
//  NavBarScroller.swift
//  GH Viewer
//
//  Created by ruckef on 20.09.16.
//  Copyright © 2016 ruckef. All rights reserved.
//

protocol TrackerDelegate : class {
    func didChangeOffsetY(offsetY: CGFloat)
}

extension UINavigationController {
    
    private struct KeyHolder {
        static var scrollKey = "KeyHolder.scrollKey"
        static var trackerKey = "KeyHolder.trackerKey"
    }
    

    class OffsetTracker : NSObject, UIGestureRecognizerDelegate {
        weak var delegate: TrackerDelegate?
        weak var scroll: UIScrollView?
        var lastY = CGFloat(0)
        
        init(delegate: TrackerDelegate) {
            self.delegate = delegate
        }
        var recognizer: UIPanGestureRecognizer?
        
        func track(scroll: UIScrollView) {
            recognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
            recognizer?.delegate = self
            scroll.addGestureRecognizer(recognizer!)
            self.scroll = scroll
        }
        
        func untrack(scroll: UIScrollView) {
            scroll.removeGestureRecognizer(recognizer!)
            self.scroll = nil
        }
        
        func didPan(rec: UIPanGestureRecognizer) {
            print(scroll?.contentOffset.y)
            
            let y = rec.translationInView(scroll).y
            let offset = y - lastY
            print(offset)
            delegate?.didChangeOffsetY(offset)
            lastY = y
        }
        
        func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            return true
        }
    }
    
    func trackScrollView(scrollView: UIScrollView) {
        if self.scrollView != nil {
            tracker?.untrack(self.scrollView!)
        }
        self.scrollView = scrollView
        tracker = OffsetTracker(delegate: self)
        tracker?.track(scrollView)
    }
    
    func untrack() {
        if scrollView != nil {
            tracker?.untrack(scrollView!)
            scrollView = nil
        }
        tracker = nil
    }
    
    var scrollView: UIScrollView? {
        get {
            let obj = objc_getAssociatedObject(self, &KeyHolder.scrollKey) as? UIScrollView
            return obj
        }
        set {
            objc_setAssociatedObject(self, &KeyHolder.scrollKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var tracker: OffsetTracker? {
        get {
            let obj = objc_getAssociatedObject(self, &KeyHolder.trackerKey) as? OffsetTracker
            return obj
        }
        set {
            if newValue != nil {
                if tracker != nil {
                    return
                }
            }
            objc_setAssociatedObject(self, &KeyHolder.trackerKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}

extension UINavigationController : TrackerDelegate {
    func didChangeOffsetY(offsetY: CGFloat) {
        var frame = navigationBar.frame
        frame.origin.y += offsetY
        
        let y = frame.origin.y
        let height = frame.size.height
        if  y >= 20 {
            frame.origin.y = 20
        } else if y <= -height+20 {
            frame.origin.y = -height+20
        }
        navigationBar.frame = frame
    }
}
