//
//  CustomSlider.swift
//  BodyTracker
//
//  Created by Administrator on 22/01/20.
//  Copyright © 2020 RafaelCM. All rights reserved.
//

import Foundation
import SwiftUI

//struct CustomSlider<Component: View>: View {
//
//    var value: Double
//    var range: (Double, Double)
//    var knobWidth: CGFloat?
//    let viewBuilder: (CustomSliderComponents) -> Component
//
//    init(value: Double, range: (Double, Double), knobWidth: CGFloat? = nil,
//         _ viewBuilder: @escaping (CustomSliderComponents) -> Component
//    ) {
//        self.value = value
//        self.range = range
//        self.viewBuilder = viewBuilder
//        self.knobWidth = knobWidth
//    }
//
//    var body: some View {
//        return GeometryReader { geometry in
//            self.view(geometry: geometry) // function below
//        }
//    }
//
//    private func view(geometry: GeometryProxy) -> some View {
//        let frame = geometry.frame(in: .global)
//        let offsetX = self.getOffsetX(frame: frame)
//        let knobSize = CGSize(width: knobWidth ?? frame.height, height: frame.height)
//        let barLeftSize = CGSize(width: CGFloat(offsetX + knobSize.width * 0.5), height:  frame.height)
//        let barRightSize = CGSize(width: frame.width - barLeftSize.width, height: frame.height)
//        let modifiers = CustomSliderComponents(
//            barLeft: CustomSliderModifier(name: .barLeft, size: barLeftSize, offset: 0),
//            barRight: CustomSliderModifier(name: .barRight, size: barRightSize, offset: barLeftSize.width),
//            knob: CustomSliderModifier(name: .knob, size: knobSize, offset: offsetX)
//        )
//        return ZStack { viewBuilder(modifiers) }
//    }
//
//    private func getOffsetX(frame: CGRect) -> CGFloat {
//        let width = (knob: knobWidth ?? frame.size.height, view: frame.size.width)
//        let xrange: (Double, Double) = (0, Double(width.view - width.knob))
//        let result = self.value.convert(fromRange: range, toRange: xrange)
//        return CGFloat(result)
//    }
//
//}
//
//
//struct CustomSliderComponents {
//    let barLeft: CustomSliderModifier
//    let barRight: CustomSliderModifier
//    let knob: CustomSliderModifier
//}
//
//
//struct CustomSliderModifier: ViewModifier {
//    enum Name {
//        case barLeft
//        case barRight
//        case knob
//    }
//    let name: Name
//    let size: CGSize
//    let offset: CGFloat
//
//    func body(content: Content) -> some View {
//        content
//            .frame(width: size.width)
//            .position(x: size.width*0.5, y: size.height*0.5)
//            .offset(x: offset)
//    }
//}
//
//
//extension Double {
//    func convert(fromRange: (Double, Double), toRange: (Double, Double)) -> Double {
//        // Example: if self = 1, fromRange = (0,2), toRange = (10,12) -> solution = 11
//        var value = self
//        value -= fromRange.0
//        value /= Double(fromRange.1 - fromRange.0)
//        value *= toRange.1 - toRange.0
//        value += toRange.0
//        return value
//    }
//}
//
//struct MagnitudeChart: Shape {
//    func path(in rect: CGRect) -> Path {
//        var path = Path()
//        path.move(to: rect.origin)
//        for index in 1...60 {
//            let barWidth: CGFloat = 2
//            let spacing = (rect.width - barWidth*CGFloat(60))/CGFloat(59)
//            let barRect = CGRect(x: (CGFloat(barWidth)+spacing)*CGFloat(index),
//                                 y: rect.origin.y,
//                                 width: barWidth,
//                                 height: rect.height)
//            path.addRoundedRect(in: barRect, cornerSize: CGSize(width:1, height: 1))
//        }
//        let bounds = path.boundingRect
//        let scaleX = rect.size.width/bounds.size.width
//        let scaleY = rect.size.height/bounds.size.height
//        return path.applying(CGAffineTransform(scaleX: scaleX, y: scaleY))
//    }
//}


struct CustomSlider<Component: View>: View {
    
    var value: Double
    var range: (Double, Double)
    var knobWidth: CGFloat?
    let viewBuilder: (CustomSliderComponents) -> Component
    
    init(value: Double, range: (Double, Double), knobWidth: CGFloat? = nil,
         _ viewBuilder: @escaping (CustomSliderComponents) -> Component
    ) {
        self.value = value
        self.range = range
        self.viewBuilder = viewBuilder
        self.knobWidth = knobWidth
    }
    
    var body: some View {
        return GeometryReader { geometry in
            self.view(geometry: geometry) // function below
        }
    }
    
    private func view(geometry: GeometryProxy) -> some View {
        let frame = geometry.frame(in: .global)
        let offsetX = self.getOffsetX(frame: frame)
        let knobSize = CGSize(width: knobWidth ?? frame.height, height: frame.height)
        let bar1size = CGSize(width: frame.width * 0.12, height:  frame.height)
        let bar2size = CGSize(width: frame.width * 0.28, height: frame.height)
        let bar3size = CGSize(width: frame.width * 0.2, height: frame.height)
        let bar4size = CGSize(width: frame.width * 0.4, height: frame.height)
        let modifiers = CustomSliderComponents(
            bar1: CustomSliderModifier(name: .bar1, size: bar1size, offset: 0),
            bar2: CustomSliderModifier(name: .bar2, size: bar2size, offset: bar1size.width),
            bar3: CustomSliderModifier(name: .bar3, size: bar3size, offset: bar1size.width + bar2size.width),
            bar4: CustomSliderModifier(name: .bar4, size: bar4size, offset: bar1size.width + bar2size.width + bar3size.width),
            knob: CustomSliderModifier(name: .knob, size: knobSize, offset: offsetX)
        )
        return ZStack { viewBuilder(modifiers) }
    }
    
    private func getOffsetX(frame: CGRect) -> CGFloat {
        let width = (knob: knobWidth ?? frame.size.height, view: frame.size.width)
        let xrange: (Double, Double) = (0, Double(width.view - width.knob))
        let result = self.value.convert(fromRange: range, toRange: xrange)
        return CGFloat(result)
    }
    
}


struct CustomSliderComponents {
    let bar1: CustomSliderModifier
    let bar2: CustomSliderModifier
    let bar3: CustomSliderModifier
    let bar4: CustomSliderModifier
    let knob: CustomSliderModifier
}


struct CustomSliderModifier: ViewModifier {
    enum Name {
        case bar1
        case bar2
        case bar3
        case bar4
        case knob
    }
    let name: Name
    let size: CGSize
    let offset: CGFloat
    
    func body(content: Content) -> some View {
        content
            .frame(width: size.width)
            .position(x: size.width*0.5, y: size.height*0.5)
            .offset(x: offset)
    }
}


extension Double {
    func convert(fromRange: (Double, Double), toRange: (Double, Double)) -> Double {
        // Example: if self = 1, fromRange = (0,2), toRange = (10,12) -> solution = 11
        var value = self
        value -= fromRange.0
        value /= Double(fromRange.1 - fromRange.0)
        value *= toRange.1 - toRange.0
        value += toRange.0
        return value
    }
}

struct MagnitudeChart: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: rect.origin)
        for index in 1...60 {
            let barWidth: CGFloat = 2
            let spacing = (rect.width - barWidth*CGFloat(60))/CGFloat(59)
            let barRect = CGRect(x: (CGFloat(barWidth)+spacing)*CGFloat(index),
                                 y: rect.origin.y,
                                 width: barWidth,
                                 height: rect.height)
            path.addRoundedRect(in: barRect, cornerSize: CGSize(width:1, height: 1))
        }
        let bounds = path.boundingRect
        let scaleX = rect.size.width/bounds.size.width
        let scaleY = rect.size.height/bounds.size.height
        return path.applying(CGAffineTransform(scaleX: scaleX, y: scaleY))
    }
}
