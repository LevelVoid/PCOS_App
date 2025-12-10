import UIKit
import AVFoundation

protocol BarcodeScannerDelegate: AnyObject {
    func didScanBarcode(_ code: String)
}


class BarcodeScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    weak var delegate: BarcodeScannerDelegate?
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        captureSession = AVCaptureSession() // 1. Camera input
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput = try! AVCaptureDeviceInput(device: videoCaptureDevice)

        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            print("Could not add camera input")
            return
        }   // 2. Barcode output
        let metadataOutput = AVCaptureMetadataOutput()

        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)  // Supported barcodes
            metadataOutput.metadataObjectTypes = [
                .ean8, .ean13, .code128, .qr,
                .upce, .code39, .code93, .pdf417
            ]
        } else {
            print("Could not add metadata output")
            return
        }   // 3. Preview layer
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)    // 4. Start scanning
        captureSession.startRunning()
    }   // 🔥 When a barcode is detected:
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {

        captureSession.stopRunning()

        if let metadataObj = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
           let value = metadataObj.stringValue {

            print("Scanned barcode: \(value)")
            fetchFood(byBarcode: value)
            // You can dismiss and return the value OR pass to delegate
            dismiss(animated: true)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if captureSession?.isRunning == true {
            captureSession.stopRunning()
        }
    }
}


extension BarcodeScannerViewController {
    
    func fetchFood(byBarcode barcode: String) {
        
        let urlString = "https://world.openfoodfacts.org/api/v0/product/\(barcode).json"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Request error:", error)
                return
            }

            guard
                let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200,
                let data = data
            else {
                print("Invalid response")
                return
            }

            do {
                // Decode a minimal structure
                let decoded = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]

                guard
                    let status = decoded?["status"] as? Int,
                    status == 1,
                    let product = decoded?["product"] as? [String: Any],
                    let nutriments = product["nutriments"] as? [String: Any]
                else {
                    print("Product not found for barcode \(barcode)")
                    return
                }
                
                let name = product["product_name"] as? String ?? "Unknown food"

                // These keys come from OpenFoodFacts nutriments
                let kcal = nutriments["energy-kcal_100g"] as? Double ?? 0
                let protein = nutriments["proteins_100g"] as? Double ?? 0
                let carbs = nutriments["carbohydrates_100g"] as? Double ?? 0
                let fat = nutriments["fat_100g"] as? Double ?? 0

                print("Name: \(name)\nKcal: \(kcal)\nProtein: \(protein)\nCarbs: \(carbs)\nFat: \(fat)\n\(product)\n\(nutriments)")
                // Create your Meal model (assuming 100g serving; you can adjust)
//                let meal = Meal(
//                    id: UUID(),
//                    title: name,
//                    calories: Int(kcal),
//                    protein: Int(protein),
//                    carbs: Int(carbs),
//                    fats: Int(fat),
//                    image: nil,
//                    date: Date()
//                )

//                DispatchQueue.main.async {
//                    //self.meals.append(meal)
//                    self.tableView.reloadData()
//                   // self.updateHeader()
//                }

            } catch {
                print("JSON parse error:", error)
            }
        }

        task.resume()
    }

}
