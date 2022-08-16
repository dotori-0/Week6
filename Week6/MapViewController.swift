//
//  MapViewController.swift
//  Week6
//
//  Created by SC on 2022/08/11.
//

// Location 1. 임포트
import CoreLocation
//import CoreLocationUI  // iOS 15 이상 로케이션 버튼 등을 다루거나 할 때 사용
import UIKit
import MapKit

/*
 MapView
 - 지도와 위치 권한은 상관 X
 - 만약 지도에 현재 위치 등을 표현하고 싶다면 위치 권한 필요
 - 중심, 범위 지정
 - 핀(어노테이션)
 */

/*
 권한: 지웠다가 실행한다고 하더라도, 반영이 조금씩 느릴 수 있음
 설정: 앱이 바로 안 뜨는 경우도 있을 수 있음
 */

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    // Location 2. 위치에 대한 대부분을 담당
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
        
        // Location 3. 프로토콜 연결
        locationManager.delegate = self
        
        // 제거 가능한 이유 명확히 알기!
//        checkUserDeviceLocationServiceAuthorization()
        print(#function)
        
        let center = CLLocationCoordinate2D(latitude: 28.370722, longitude: -81.558693)
        setRegionAndAnnotation(center: center)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(#function)
        showRequestLocationServiceAlert()
        print(#function)
    }
    
    func setRegionAndAnnotation(center: CLLocationCoordinate2D) {
        // 지도 중심 설정: 애플맵 활용해 좌표 복사
//        let center = CLLocationCoordinate2D(latitude: 40, longitude: 100)
        // 28.380244, -81.561177
//        let center = CLLocationCoordinate2D(latitude: 37.334886, longitude: -122.008988)  // Apple Park
//        let center = CLLocationCoordinate2D(latitude: 28.380244, longitude: -81.561177)  // Disney World
//        let center = CLLocationCoordinate2D(latitude: 28.370722, longitude: -81.558693)  // Disney World
        // 지도 중심 기반으로 보여질 범위
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 1000, longitudinalMeters: 1000)   // 보통 같은 수치를 넣는다
        
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = center
        annotation.title = "여기가 디즈니월드다"
        
        // 지도에 핀 추가
        mapView.addAnnotation(annotation)
    }
}

// 위치 관련된 User Defined 메서드
extension MapViewController {
    
    // Location 7. iOS 버전에 따른 분기 처리 및 iOS 위치 서비스 활성화 여부 확인 (작성 순서는 7번이었지만 먼저 확인해야 함)
    // 위치 서비스가 켜져 있다면 권한을 요청하고, 꺼져 있다면 커스텀 얼럿으로 상황 알려주기
    // CLAuthorizationStatus
    // - denied: 허용 안 함 / 설정에서 추후에 거부 / 위치 서비스 끔 / 비행기 모드
    // - restricted: 앱 권한 자체가 없는 경우 (자녀 보호 기능 같은 것으로 아예 제한)
    func checkUserDeviceLocationServiceAuthorization() {  // 위치 서비스가 켜져 있는지 확인
        let authorizationStatus: CLAuthorizationStatus // 위치에 대한 권한
        
        if #available(iOS 14.0, *) {
            // 인스턴스를 통해 locationManager가 가지고 있는 상태를 가져옴
            authorizationStatus = locationManager.authorizationStatus
            print("🍋", authorizationStatus.rawValue)
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        
        
        // iOS 위치 서비스 활성화 여부 체크: locationServicesEnabled()
        if CLLocationManager.locationServicesEnabled() {
            // 위치 서비스가 활성화 되어 있으므로, 위치 권한 요청이 가능해서, 위치 권한을 요청
            checkUserCurrentLocationAuthorization(authorizationStatus)
        } else {
            print("위치 서비스가 꺼져 있어 위치 권한 요청을 할 수 없습니다.")
        }
    }
    
    
    // Location 8. 사용자의 위치 권한 상태 확인
    // 사용자가 위치를 허용했는지, 거부했는지, 아직 선택하지 않았는지 등을 확인(단, 사전에 iOS 위치 서비스 활성화 여부 꼭 확인)
    func checkUserCurrentLocationAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
            case .notDetermined:  // 권한 요청 창에서 아무것도 선택하지 않은 상태
                print("NOT DETERMINED")
                
                locationManager.desiredAccuracy = kCLLocationAccuracyBest  // iOS 14부터 나오는 정확한 위치와는 다르다
                locationManager.requestWhenInUseAuthorization()  // 앱을 사용하는 동안에 대한 위치 권한 요청
                // plist에 WhenInUse가 등록되어 있어야 request 메서드를 사용할 수 있다
                
//                locationManager.startUpdatingLocation()
                
            case .restricted, .denied:
                print("DENIED, 아이폰 설정으로 유도")
//                showRequestLocationServiceAlert()

            case .authorizedWhenInUse:
                print("WHEN IN USE")
                // 사용자가 위치를 허용해 둔 상태라면, startUpdatingLocation()을 통해 didUpdateLocations 메서드가 실행
                locationManager.startUpdatingLocation()
                
//            case .authorizedAlways: // '항상 허용'했다면 거의 호출되지 않을 것
//                <#code#>
//            case .authorized: // deprecated
//                <#code#>
                
            default: print("DEFAULT")
        }
    }
    
    
    func showRequestLocationServiceAlert() {
      let requestLocationServiceAlert = UIAlertController(title: "위치정보 이용", message: "위치 서비스를 사용할 수 없습니다. 기기의 '설정 > 개인정보 보호'에서 위치 서비스를 켜 주세요.", preferredStyle: .alert)
        
        // 설정까지 이동하거나 혹은 설정 세부화면까지 이동하거나
        // 한 번도 설정 앱에 들어가지 않았거나, 막 다운받은 앱이거나
      let goSetting = UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in
          if let appSetting = URL(string: UIApplication.openSettingsURLString) {
              UIApplication.shared.open(appSetting)
          }
      }
      let cancel = UIAlertAction(title: "취소", style: .default)
      requestLocationServiceAlert.addAction(cancel)
      requestLocationServiceAlert.addAction(goSetting)
      
      present(requestLocationServiceAlert, animated: true, completion: nil)
    }

}


// Location 4. 프로토콜 채택
extension MapViewController: CLLocationManagerDelegate {
    
    // Location 5. 사용자의 위치를 성공적으로 가지고 온 경우
    // 🔗 움직이면 실행이 되는 것은 맞지만, 세부적으로 되는 것은 아님
    // 일반적인 앱 상황에서는 명시적으로 사용자가 특정 액션을 취했을 때 startUpdatingLocation()을 하는 편
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(#function, locations)
        
        // ex 1. 위도 경도 기반으로 날씨 정보를 조회
        // ex 2. 지도를 다시 세팅
        if let coordinate = locations.last?.coordinate {
//            let latitude = coordinate.latitude
//            let longitude = coordinate.longitude
//            let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//            setRegionAndAnnotation(center: center)
            
            setRegionAndAnnotation(center: coordinate)
            // 날씨 정보 API 요청
        }
        
        // 위치 업데이트 멈춰!
        locationManager.stopUpdatingLocation()  // 계속 보여주고 싶더라도 계속 쌓이지 않도록 특정 시점에는 구현 필요
    }
    
    
    // Location 6. 사용자의 위치를 못 가지고 온 경우
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function)
    }
    
    
    // Location 9. 사용자의 권한 상태가 바뀔 때를 알려줌
    // 거부했다가 설정에서 변경했거나, notDetermined에서 허용을 눌렀거나 등
    // 허용했어서 위치를 가지고 오는 중에, 설정에서 거부하고 돌아온다면??
    // iOS 14 이상: 사용자의 권한 상태가 변경될 때, 위치 관리자(locationManager)가 생성될 때 호출됨
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(#function)
        checkUserDeviceLocationServiceAuthorization()
    }
    
    
    // iOS 14 미만
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
    }
}


extension MapViewController: MKMapViewDelegate {
    // 지도에 커스텀 핀 추가
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        <#code#>
//    }
    
    // 사용자가 지도를 움직였다가 멈출 때 호출  // This method is called at the end of a change to the map's visible region.
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
         
    }
}
