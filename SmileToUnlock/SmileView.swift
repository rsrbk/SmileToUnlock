/*
 MIT License

 Copyright (c) 2017 Ruslan Serebriakov <rsrbk1@gmail.com>

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

import UIKit

public class SmileView: UIView {

    public var distanceBetweenEyes: CGFloat = 100
    public var eyesRadius: CGFloat = 15
    public var lipsHorizontalOffset: CGFloat = 45
    public var lipsVerticalOffset: CGFloat = 120
    public var lipsBottomValue: CGFloat = 150

    private var smileParameter: CGFloat = 0
    private var currentLipsLayer: CAShapeLayer?

    public func drawSmile(parameter: CGFloat) {
        smileParameter = parameter
        createLips()
    }

    override public func draw(_ rect: CGRect) {
        super.draw(rect)

        createFaceContour()
        createEyes()
        createLips()
    }

    private func createShapeLayer() -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 3.0

        return shapeLayer
    }

    private func createFaceContour() {
        let faceContourPath = UIBezierPath(ovalIn: bounds)
        let shapeLayerForFaceCountour = createShapeLayer()
        shapeLayerForFaceCountour.path = faceContourPath.cgPath
        layer.addSublayer(shapeLayerForFaceCountour)
    }

    private func createEyes() {
        let leftEyeCenter = CGPoint(x: frame.width/2 - distanceBetweenEyes/2,
                                    y: frame.height/3)
        let leftEyePath = UIBezierPath(arcCenter: leftEyeCenter,
                                       radius: eyesRadius,
                                       startAngle: 0,
                                       endAngle: CGFloat(Double.pi * 2),
                                       clockwise: true)
        let shapeLayerForLeftEye = createShapeLayer()
        shapeLayerForLeftEye.path = leftEyePath.cgPath
        layer.addSublayer(shapeLayerForLeftEye)

        let rightEyeCenter = CGPoint(x: frame.width/2 + distanceBetweenEyes/2,
                                     y: frame.height/3)
        let rightEyePath = UIBezierPath(arcCenter: rightEyeCenter,
                                        radius: eyesRadius,
                                        startAngle: 0,
                                        endAngle: CGFloat(Double.pi * 2),
                                        clockwise: true)
        let shapeLayerForRightEye = createShapeLayer()
        shapeLayerForRightEye.path = rightEyePath.cgPath
        layer.addSublayer(shapeLayerForRightEye)
    }

    private func createLips() {
        if let previousLayer = currentLipsLayer {
            previousLayer.removeFromSuperlayer()
        }

        let lipsPath = UIBezierPath()
        let leftLipsPoint = CGPoint(x: lipsHorizontalOffset, y: frame.height-lipsVerticalOffset)
        lipsPath.move(to: leftLipsPoint)

        let rightLipsPoint = CGPoint(x: frame.width-lipsHorizontalOffset, y: frame.height-lipsVerticalOffset)
        let bottomLipsPoint = CGPoint(x: frame.width/2, y: frame.height-lipsVerticalOffset+lipsBottomValue*smileParameter)
        lipsPath.addQuadCurve(to: rightLipsPoint, controlPoint: bottomLipsPoint)

        currentLipsLayer = createShapeLayer()
        currentLipsLayer!.path = lipsPath.cgPath

        layer.addSublayer(currentLipsLayer!)
    }
}
