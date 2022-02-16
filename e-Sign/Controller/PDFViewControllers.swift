//
//  PDFViewController.swift
//  e-Sign
//
//  Created by macOS on 14/02/22.
//

import UIKit
import PDFReader

class PDFViewControllers: UIViewController{

    @IBOutlet weak var SignPrevue: UIImageView!
    @IBOutlet weak var pdfView: UIView!
    var image = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SignPrevue.image = image

    }
}
