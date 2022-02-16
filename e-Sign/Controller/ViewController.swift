//
//  ViewController.swift
//  e-Sign
//
//  Created by macOS on 14/02/22.
//

import UIKit
import PencilKit
import MobileCoreServices
import UniformTypeIdentifiers
import PDFKit

class ViewController: UIViewController {
   
    @IBOutlet weak var ItemCollectionView: UICollectionView!
    var toolPicker = PKToolPicker.init()
    var thumbURL:URL?
    var PDFModel : [ListModel] = [] {
        didSet{
                ItemCollectionView.reloadData()
        }
        willSet(newValue){
            self.PDFModel = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ItemCollectionView.reloadData()
        UserDefaults.standard.url(forKey: "PDFurls")
    }
    
    @IBAction func addDocs(_ sender: UIButton) {
        let importDoc = UIDocumentMenuViewController(documentTypes: [String(kUTTypePDF), String(kUTTypeJPEG)], in: .import)
        importDoc.delegate = self
        importDoc.addOption(withTitle: "Create New Document", image: nil, order: .first, handler: { print("New Doc Requested") })
        importDoc.modalPresentationStyle = .formSheet
        self.present(importDoc, animated: true, completion: nil)
    }
}

extension ViewController:UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PDFModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCell", for: indexPath) as! ItemCollectionViewCell
        cell.PDFThumb.image = pdfThumbnail(url: PDFModel[indexPath.row].PDFUrl)
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 0.0)
        cell.layer.shadowRadius = 10
        cell.layer.shadowOpacity = 0.1
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size:CGFloat = (ItemCollectionView.frame.size.width - space) / 2.0
        return CGSize(width: size, height: 230)
    }
}

extension ViewController: UIDocumentMenuDelegate,UIDocumentPickerDelegate,UINavigationControllerDelegate {
    
    func selectFiles() {
        let types = UTType.types(tag: "json",
                                 tagClass: UTTagClass.filenameExtension,
                                 conformingTo: nil)
        let documentPickerController = UIDocumentPickerViewController(
            forOpeningContentTypes: types)
        documentPickerController.delegate = self
        self.present(documentPickerController, animated: true, completion: nil)
    }
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }
        print("import result : \(myURL)")
        PDFModel.append(ListModel.init(PDFUrl: myURL, PDFthumb: pdfThumbnail(url: myURL)))
        UserDefaults.standard.set(myURL, forKey: "PDFUrls")
    }
    
    func pdfThumbnail(url: URL, width: CGFloat = 240) -> UIImage? {
        guard let data = try? Data(contentsOf: url),
              let page = PDFDocument(data: data)?.page(at: 0) else {
            return nil
        }
        let pageSize = page.bounds(for: .mediaBox)
        let pdfScale = width / pageSize.width
        
        // Apply if you're displaying the thumbnail on screen
        let scale = UIScreen.main.scale * pdfScale
        let screenSize = CGSize(width: pageSize.width * scale,
                                height: pageSize.height * scale)
        return page.thumbnail(of: screenSize, for: .mediaBox)
    }
    
    public func documentMenu(_ documentMenu:UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        dismiss(animated: true, completion: nil)
    }
}

