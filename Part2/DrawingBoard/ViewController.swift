//
//  ViewController.swift
//  DrawingBoard
//
//  Created by sandeep on 2023-10-18.
//

import UIKit

class ViewController: UIViewController {
    var selectedButton: UIButton?
    // Drawing properties
    var currentColor: DrawingColor?
    var lastPoint: CGPoint!
    var drawingImageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        currentColor = .red
        // Create a drawing canvas
        setupDrawingCanvas()
        setupColorButtons()
    }
    
    // Setup the drawing canvas (UIImageView)
    func setupDrawingCanvas() {
        drawingImageView.frame = view.bounds
        drawingImageView.backgroundColor = .clear
        view.addSubview(drawingImageView)
    }
    // Setup the color selection buttons in a stack view
    func setupColorButtons() {
        let topShadowView = TopShadowViewClass()
        topShadowView.translatesAutoresizingMaskIntoConstraints = false
        topShadowView.backgroundColor = .gray
        
        // Add the bottomShadowView to your view hierarchy
        view.addSubview(topShadowView)

        // Add constraints to pin it to the bottom of the superview
        NSLayoutConstraint.activate([
            topShadowView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topShadowView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topShadowView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            topShadowView.heightAnchor.constraint(equalToConstant: 100) // Adjust the height as needed
        ])
           let stackView = UIStackView()
           stackView.axis = .horizontal
           stackView.distribution = .fillEqually
           stackView.spacing = 8
           topShadowView.addSubview(stackView)
        
        
           
           let redButton = createColorButton(withColor: .red)
           let blueButton = createColorButton(withColor: .blue)
           let greenButton = createColorButton(withColor: .green)
           let eraserButton = createEraserButton()
           
           stackView.addArrangedSubview(redButton)
           stackView.addArrangedSubview(blueButton)
           stackView.addArrangedSubview(greenButton)
           stackView.addArrangedSubview(eraserButton)
           
           stackView.translatesAutoresizingMaskIntoConstraints = false
           NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: topShadowView.leadingAnchor, constant: 15),
               stackView.trailingAnchor.constraint(equalTo: topShadowView.trailingAnchor,constant: -15),
               stackView.bottomAnchor.constraint(equalTo: topShadowView.safeAreaLayoutGuide.bottomAnchor),
           ])
       }
    // Create a color selection button with the given color
    func createColorButton(withColor color: DrawingColor) -> UIButton {
            let button = UIButton()
            button.backgroundColor = color.buttonColor
            button.addTarget(self, action: #selector(selectColor(_:)), for: .touchUpInside)
        if color == .red{
            selectButton(button)
        }
            return button
        }
    
    // Highlight the selected button by adding a border
       func selectButton(_ button: UIButton) {
           // Deselect the previously selected button
           selectedButton?.layer.borderWidth = 0
           // Select the current button
           button.layer.borderWidth = 2
           button.layer.borderColor = UIColor.black.cgColor
           selectedButton = button
       }

    
    // Create the eraser button
    func createEraserButton() -> UIButton {
           let button = UIButton()
           button.backgroundColor = .white
           button.setTitle("Eraser", for: .normal)
           button.setTitleColor(.black, for: .normal)
           button.addTarget(self, action: #selector(selectEraser(_:)), for: .touchUpInside)
           return button
       }
    // Handle color selection
    @objc func selectColor(_ sender: UIButton) {
        currentColor = colorForButton(sender) ?? .red
        // Check if the color matches the current color, and highlight it
            selectButton(sender)
            
    }
    
    func colorForButton(_ button: UIButton) -> DrawingColor? {
         let buttonColors: [UIColor: DrawingColor] = [
             .red: .red,
             .blue: .blue,
             .green: .green,
             .white: .eraser
         ]
         
         return buttonColors[button.backgroundColor ?? .clear]
     }
    
    
    
    
    // Handle eraser selection
    @objc func selectEraser(_ sender: UIButton) {
//        currentColor = .eraser (Enable if need to clear the color after erase)
        DispatchQueue.delay(by: 2.0) {
                    self.clearDrawing()
                }
    }
    
    // Handle touch events
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            lastPoint = touch.location(in: view)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, let color = currentColor {
            let newPoint = touch.location(in: view)
            
            // Draw after the specified delay
            let delay = color.drawingDelay
            self.drawLine(from: self.lastPoint, to: newPoint, with: color.buttonColor, delay: delay)
            self.lastPoint = newPoint
        }
    }
    
    
    func drawLine(from startPoint: CGPoint, to endPoint: CGPoint, with color: UIColor,delay:TimeInterval) {
        UIGraphicsBeginImageContext(view.frame.size)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            if let context = UIGraphicsGetCurrentContext() {
                self.drawingImageView.image?.draw(in: self.view.bounds)
                
                context.move(to: startPoint)
                context.addLine(to: endPoint)
                
                context.setBlendMode(.normal)
                context.setLineCap(.round)
                context.setLineWidth(5.0)
                context.setStrokeColor(color.cgColor)
                
                context.strokePath()
                
                self.drawingImageView.image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
            }
        }
    }
    
    
    // Clear the drawing canvas
        func clearDrawing() {
            drawingImageView.image = nil
        }
}
extension DispatchQueue {
    static func delay(by delay: Double, closure: @escaping () -> Void) {
        self.main.asyncAfter(deadline: .now() + delay, execute: closure)
    }
}

