
import Foundation
import SwiftUI


class ImagePickerCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @Binding var myimage: UIImage?
    @Binding var isShown: Bool
    
    var net: Yolov5?
    @Binding var results: [Object]
    @Binding var time: Double
    
    init(image: Binding<UIImage?>, isShown: Binding<Bool>, re: Binding<[Object]>, time: Binding<Double>) {
        _myimage = image
        _isShown = isShown
        net = Yolov5()
        _results = re
        _time = time
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let uiImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            myimage = uiImage
            isShown = false
        }
        if let net = net {
            let tmp = net.predict(for: myimage!)
            results = tmp.0
            time = tmp.1
            if results.count == 0{
                time = -1
            }
        }else{
            results = []
            time = -1
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        isShown = false
    }
}


struct ImagePicker: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = UIImagePickerController
    typealias Coordinator = ImagePickerCoordinator
    
    @Binding var image: UIImage?
    @Binding var isShown: Bool
    @Binding var re: [Object]
    @Binding var time: Double
//    @Binding var test: Int
    
    var sourceType: UIImagePickerController.SourceType = .camera
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context:
        UIViewControllerRepresentableContext<ImagePicker>){
    }
    
    func makeCoordinator() -> ImagePicker.Coordinator {
        return ImagePickerCoordinator(image: $image, isShown: $isShown, re: $re, time: $time)
    }
    
    func makeUIViewController(context:
        UIViewControllerRepresentableContext<ImagePicker>) ->
        UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
}
