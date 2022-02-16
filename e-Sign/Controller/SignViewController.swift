//
//  SignViewController.swift
//  e-Sign
//
//  Created by macOS on 16/02/22.
//

import UIKit
import PencilKit
import MobileCoreServices
import UniformTypeIdentifiers
import PDFKit


class SignViewController: UIViewController {
    @IBOutlet weak var canvasView: PKCanvasView!
    var toolPicker = PKToolPicker.init()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        setupCanvasView()
        
    }
    
    func setupCanvasView() {
        canvasView.tool = PKInkingTool(.pencil, color: .black, width: 30)
        canvasView.drawingPolicy = .default
        if (UIApplication.shared.windows.first != nil) {
            toolPicker.addObserver(canvasView)
            
            toolPicker.setVisible(true, forFirstResponder: canvasView)
            canvasView.becomeFirstResponder()
        }
    }
    @IBAction func imageTapped(_ sender: UIBarButtonItem) {
        let story = self.storyboard?.instantiateViewController(withIdentifier: "PDFViewControllers") as? PDFViewControllers
        let img = UIGraphicsImageRenderer(bounds: canvasView.bounds).image { (_) in
            view.drawHierarchy(in: canvasView.bounds, afterScreenUpdates: true)
        }
        story?.image = img
        self.navigationController?.pushViewController(story!, animated: true)
    }

}
