//
//  CameraViewController.swift
//  Week6
//
//  Created by SC on 2022/08/12.
//

import Alamofire
import SwiftyJSON
import UIKit

import YPImagePicker


class CameraViewController: UIViewController {

    @IBOutlet weak var resultImageView: UIImageView!
    
    // UIImagePickerController 1.
    let picker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // UIImagePickerController 2.
        picker.delegate = self
    }
    
    
    
    

    @IBAction func cameraButtonClicked(_ sender: UIButton) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("사용 불가 + 토스트/얼럿")
            return
        }
        print(picker.sourceType.rawValue)
        picker.sourceType = .camera
        print(picker.sourceType.rawValue)
        picker.allowsEditing = true  // false 로 하면 편집화면이 나오지 않을 것
        
        present(picker, animated: true)
    }
    
    // OpenSource
    // 권한 문구 등도 내부적으로 구현! 실제로 카메라를 쓸 때 권한을 요청
    @IBAction func YPImagePickerButtonClicked(_ sender: UIButton) {
        let picker = YPImagePicker()
        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
                print(photo.fromCamera) // Image source (camera or library)
                print(photo.image) // Final image selected by the user
                print(photo.originalImage) // original image selected by the user, unfiltered
                print(photo.modifiedImage) // Transformed image, can be nil
                print(photo.exifMeta) // Print exif meta data of original image.
                
                self.resultImageView.image = photo.image
            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func photoLibraryButtonClicked(_ sender: UIButton) {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            print("사용 불가 + 토스트/얼럿")
            return
        }
        print(picker.sourceType.rawValue)
        picker.sourceType = .photoLibrary
        print(picker.sourceType.rawValue)
        picker.allowsEditing = true  // false 로 하면 편집화면이 나오지 않을 것
        
        present(picker, animated: true)
    }
    
    
    @IBAction func saveToPhotoLibrary(_ sender: UIButton) {
        if let image = resultImageView.image {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
    }
    
    
    // 이미지뷰 이미지 > 네이버 > 얼굴 분석 해줘 요청 > 응답!
    // 문자열이 아닌 파일, 이미지, PDF 파일 자체가 그대로 전송되지 않음 -> 텍스트 형태로 인코딩
    // 어떤 파일의 종류가 서버에게 전달이 되는지 명시가 필요 = Content-Type
    @IBAction func clovaButtonClicked(_ sender: UIButton) {
        let url = "https://openapi.naver.com/v1/vision/celebrity"
        let headers: HTTPHeaders = ["X-Naver-Client-Id": APIKey.NAVER_ID,
                                    "X-Naver-Client-Secret": APIKey.NAVER_SECRET,
                                    "Content-Type": "multipart/form-data"]  // Content-Type 안 해도 되는 이유: 라이브러리에 내장되어 있음
        
        // UIImage를 텍스트 형태(바이너리 타입)로 변환해서 전달
        guard let imageData = resultImageView.image?.pngData() else { return }
        
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData, withName: "image")
        }, to: url, headers: headers)
            .validate().responseData { response in
            switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print(json)
                    
            
                    
//
                case .failure(let error):
                    print(error)
            }
        }
    }
}



// UIImagePickerController 3.
// UIImagePickerController가 UINavigationController를 상속받고 있음
extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // UIImagePickerController 4. 사진 선택이나 카메라 촬영 직후
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(#function)
        
        // 원본, 편집, 메타 데이터 등 - infoKey
        if picker.sourceType == .camera {
            
        }
        
        
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.resultImageView.image = image
            dismiss(animated: true)
        }
    }
    
    // UIImagePickerController 5. 취소 버튼 클릭 시
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print(#function)
    }
}
