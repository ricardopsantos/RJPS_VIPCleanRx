//
//  V.CartTrackMapView.swift
//  GoodToGo
//
//  Created by Ricardo Santos on 14/05/2020.
//  Copyright (c) 2020 Ricardo P Santos. All rights reserved.
//

// swiftlint:disable no_hardCodedImages

import UIKit
import Foundation
import MapKit
//
import RxCocoa
import RxSwift
import RxDataSources
import TinyConstraints
//
import AppConstants
import AppTheme
import Designables
import DevTools
import Domain
import Extensions
import PointFreeFunctions
import UIBase
import AppResources

//
// INSERT INVISION/ZEPLIN RELATED LAYOUT SCREENS BELOW
//
// Colors WIKI : https://casteamservicesvso.visualstudio.com/i9/_wiki/wikis/i9.wiki/378/Colors
// Labels WIKI : https://casteamservicesvso.visualstudio.com/i9/_wiki/wikis/i9.wiki/880/Typography
// Icons WIKI : https://casteamservicesvso.visualstudio.com/i9/_wiki/wikis/i9.wiki/333/Icons
//

extension V {
    class CartTrackMapView: BaseGenericViewVIP {

        deinit { }

        enum CartTrackMapViewAnnotationType {
            case pinAnnotationView
            case markerAnnotationView
        }

        static var selectedAnnotationsTypeForMap: CartTrackMapViewAnnotationType = .markerAnnotationView

        var rxFilter = BehaviorSubject<String?>(value: nil)
        private var lastModel: [CarTrack.UserModel] = []
        // MARK: - UI Elements (Private and lazy by default)

        private lazy var mapView: MKMapView = {
            return MKMapView()
        }()

        private lazy var searchBar: CustomSearchBar = {
            return UIKitFactory.searchBar(placeholder: Messages.search.localised)
        }()

        private lazy var lblInfo: UILabelWithPadding = {
            return UIKitFactory.labelWithPadding(style: .info)
        }()

        private lazy var viewFeatureFlag: UIView = {
            UIKitFactory.switchWithCaption(caption: DevTools.FeatureFlag.devTeam_useMockedData.rawValue,
            defaultValue: DevTools.FeatureFlag.devTeam_useMockedData.isTrue,
            disposeBag: disposeBag) { value in
                DevTools.FeatureFlag.setFlag(.devTeam_useMockedData, value: value)
            }
        }()

        // MARK: - Mandatory

        // Order in View life-cycle : 1
        // This function is called automatically by super BaseGenericViewVIP
        // There are 3 functions specialised according to what we are doing. Please use them accordingly
        // Function 1/3 : JUST to add stuff to the view....
        override func prepareLayoutCreateHierarchy() {
            addSubview(mapView)
            addSubview(searchBar)
            addSubview(lblInfo)
            addSubview(viewFeatureFlag)
        }

        // This function is called automatically by super BaseGenericViewVIP
        // There are 3 functions specialised according to what we are doing. Please use them accordingly
        // Function 2/3 : JUST to setup layout rules zone....
        override func prepareLayoutBySettingAutoLayoutsRules() {

            lblInfo.autoLayout.topToBottom(of: searchBar, offset: Designables.Sizes.Margins.defaultMargin)
            lblInfo.autoLayout.width(screenWidth / 4)
            lblInfo.autoLayout.trailingToSuperview(offset: Designables.Sizes.Margins.defaultMargin)

            mapView.autoLayout.topToBottom(of: searchBar)
            mapView.autoLayout.bottomToSuperview()
            mapView.autoLayout.leadingToSuperview()
            mapView.autoLayout.trailingToSuperview()

            searchBar.rjsALayouts.setMargin(TopBar.defaultHeight, on: .top)
            searchBar.autoLayout.leadingToSuperview()
            searchBar.autoLayout.trailingToSuperview()
            searchBar.autoLayout.height(50)

            viewFeatureFlag.autoLayout.bottomToSuperview(offset: Designables.Sizes.Margins.defaultMargin + 80)
            viewFeatureFlag.autoLayout.trailingToSuperview(offset: Designables.Sizes.Margins.defaultMargin)

        }

        // This function is called automatically by super BaseGenericViewVIP
        // There are 3 functions specialised according to what we are doing. Please use them accordingly
        // Function 3/3 : Stuff that is not included in [prepareLayoutCreateHierarchy] and [prepareLayoutBySettingAutoLayoutsRules]
        override func prepareLayoutByFinishingPrepareLayout() {
            // Do any additional setup after loading the view, typically from a nib.
            mapView.delegate = self
            lblInfo.addShadow()
            lblInfo.addCorner(radius: 5)
            lblInfo.textAlignment = .right
            mapView.register(CarTrackMKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        }

        override func setupColorsAndStyles() {
            self.backgroundColor = TopBar.defaultColor
        }

        // Order in View life-cycle : 2
        // This function is called automatically by super BaseGenericView
        override func setupViewUIRx() {
            searchBar.rx.text
                .orEmpty
                .debounce(.milliseconds(AppConstants.Rx.textFieldsDefaultDebounce), scheduler: MainScheduler.instance)
                .subscribe(onNext: { [weak self] _ in
                    guard let self = self else { AppLogger.log(appCode: .referenceLost); return }
                    self.rxFilter.onNext(self.searchBar.text)
                })
                .disposed(by: disposeBag)
            searchBar.rx.textDidEndEditing
                .subscribe(onNext: { [weak self] (_) in
                    guard let self = self else { AppLogger.log(appCode: .referenceLost); return }
                    guard self.searchBar.text!.count>0 else { return }
                    self.rxFilter.onNext(self.searchBar.text)
                })
                .disposed(by: self.disposeBag)
        }

        // MARK: - Custom Getter/Setters

        func setupWith(mapData viewModel: VM.CartTrackMap.MapData.ViewModel) {
            lblInfo.textAnimated = viewModel.report
            updateMapWith(list: viewModel.list)
        }

        func setupWith(screenInitialState viewModel: VM.CartTrackMap.ScreenInitialState.ViewModel) {
            //subTitle = viewModel.subTitle
            //screenLayout = viewModel.screenLayout
        }

        func setupWith(mapDataFilter viewModel: VM.CartTrackMap.MapDataFilter.ViewModel) {
            lblInfo.textAnimated = viewModel.report
            updateMapWith(list: viewModel.list)
        }

    }
}

// MARK: - Private

extension V.CartTrackMapView {

    private func updateMapWith(list: [CarTrack.UserModel]) {
        lastModel = list
        mapView.removeAnnotations()

        guard list.count > 0 else {
            BaseViewControllerMVP.shared.displayMessage(Messages.noRecords.localised, type: .warning)
            return
        }

        if V.CartTrackMapView.selectedAnnotationsTypeForMap == .pinAnnotationView {
            let mkPointAnnotationList: [MKPointAnnotation] = list.map {
                let annotation = MKPointAnnotation()
                annotation.coordinate = $0.mapLocation
                annotation.title = $0.mapTitle
                annotation.subtitle = $0.mapTitle
                return annotation
            }
            mkPointAnnotationList.forEach { (mkPointAnnotation) in
                self.mapView.addAnnotation(mkPointAnnotation)
            }
        } else {
            let mkAnnotationsList: [CarTrackMKAnnotation] = list.map {
                CarTrackMKAnnotation(title: $0.mapTitle, subTitle: $0.mapSubTitle, coordinate: $0.mapLocation, model: $0)
            }
            self.mapView.addAnnotations(mkAnnotationsList)
        }

        if let last  = list.last {
            mapView.setRegion(last.mapLocation)
        }
    }

}

// MARK: - MKMapViewDelegate

extension V.CartTrackMapView: MKMapViewDelegate {

    // Called when the region displayed by the map view is about to change
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        //    print(#function)
    }

    // Called when the annotation was added
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        if annotation is MKUserLocation { return nil }

        let reuseIdentifier = MKMapViewDefaultAnnotationViewReuseIdentifier

        if V.CartTrackMapView.selectedAnnotationsTypeForMap == .pinAnnotationView {
            var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as? MKPinAnnotationView
            if pinView == nil {
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
                pinView?.animatesDrop = true
                pinView?.canShowCallout = true
                pinView?.isDraggable = true
                pinView?.pinTintColor = UIColor.App.primary
                let rightButton: AnyObject! = UIButton(type: UIButton.ButtonType.detailDisclosure)
                pinView?.rightCalloutAccessoryView = rightButton as? UIView
            } else {
                pinView?.annotation = annotation
            }
            return pinView
        } else if V.CartTrackMapView.selectedAnnotationsTypeForMap == .markerAnnotationView {
            guard let annotation = annotation as? CarTrackMKAnnotation else { return nil }
            var view: CarTrackMKMarkerAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as? CarTrackMKMarkerAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = CarTrackMKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
                view.tintColor = UIColor.App.primary
            }
            return view
        }
        return nil
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print(#function)
        if control == view.rightCalloutAccessoryView {
            //   print("toTheMoon")
        }
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        if newState == .ending {
            let droppedAt = view.annotation?.coordinate
            //print(droppedAt.debugDescription)
        }
    }

    // MARK: - Navigation

    @IBAction func didReturnToMapViewController(_ segue: UIStoryboardSegue) {
        print(#function)
    }
}

// MARK: - Events capture

extension V.CartTrackMapView {
    /*   var rxBtnSample1Tap: Observable<Void> { btnSample1.rx.tapSmart(disposeBag) }
     var rxBtnSample2Tap: Observable<Void> { btnSample2.rx.tapSmart(disposeBag) }
     var rxBtnSample3Tap: Observable<Void> { btnSample3.rx.tapSmart(disposeBag) }
     var rxModelSelected: ControlEvent<VM.CartTrackMap.TableItem> {
     tableView.rx.modelSelected(VM.CartTrackMap.TableItem.self)
     }*/
}

// MARK: MKMapViewUtils

extension MKMapView {
    func removeAnnotations() {
        self.removeAnnotations(self.annotations)
    }

    func setRegion(_ center: CLLocationCoordinate2D) {
        guard self.annotations.count > 0 else {
            return
        }

        let maxLongitude = annotations.max { (a, b) -> Bool in a.coordinate.longitude > b.coordinate.longitude }!.coordinate.longitude
        let minLongitude = annotations.min { (a, b) -> Bool in a.coordinate.longitude > b.coordinate.longitude }!.coordinate.longitude
        let maxLatitude = annotations.max { (a, b) -> Bool in a.coordinate.latitude > b.coordinate.latitude }!.coordinate.longitude
        let minLatitude = annotations.min { (a, b) -> Bool in a.coordinate.latitude > b.coordinate.latitude }!.coordinate.longitude
        //print(maxLongitude, minLongitude)
        //print(maxLatitude, minLatitude)
        //let latitudeDelta = CLLocationDegrees()
        //let longitudeDelta = CLLocationDegrees()
        let span = MKCoordinateSpan(latitudeDelta: 4, longitudeDelta: 4)
        let region = MKCoordinateRegion.init(center: center, span: span)
        self.setRegion(region, animated: true)
    }
}

// MARK: MKMapViewUtils

class CarTrackMKAnnotation: NSObject, MKAnnotation {

    let model: Domain.CarTrack.UserModel
    let title: String?
    let subTitle: String?
    let coordinate: CLLocationCoordinate2D

    init(title: String, subTitle: String, coordinate: CLLocationCoordinate2D, model: Domain.CarTrack.UserModel) {
        self.title = title
        self.subTitle = subTitle
        self.coordinate = coordinate
        self.model = model
        super.init()
    }
}

class CarTrackMKMarkerAnnotationView: MKMarkerAnnotationView {

    override var annotation: MKAnnotation? {
        willSet {
            guard let carTrackMKAnnotation = newValue as? CarTrackMKAnnotation else { return }
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            markerTintColor = carTrackMKAnnotation.model.mapColor
            glyphText       = carTrackMKAnnotation.model.mapGlyphText
            rightCalloutAccessoryView = carTrackMKAnnotation.model.mapButton

            let detailLabel = UILabel()
            detailLabel.numberOfLines = 0
            detailLabel.font = UIFont.App.light(size: .regular)
            detailLabel.text = carTrackMKAnnotation.model.mapSubTitle
            detailCalloutAccessoryView = detailLabel

        }
    }
}

// MARK: Extension

extension Domain.CarTrack.UserModel {

    var mapTitle: String { return name }
    var mapSubTitle: String { return self.company.name + "\n" + self.email }
    var mapColor: UIColor { return self.id % 2 == 0 ? UIColor.App.error : UIColor.App.success }
    var mapGlyphText: String { return mapTitle.first }
    var mapButton: UIButton {
        let size = 30
        let some = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: size, height: size)))
        some.setBackgroundImage(#imageLiteral(resourceName: "appleMaps"), for: .normal)
        return some
    }
    var mapLocation: CLLocationCoordinate2D {
        let latitude  = self.address.geo.lat
        let longitude = self.address.geo.lng
        let lat: CLLocationDegrees = CLLocationDegrees(Double(latitude)!)
        let lng: CLLocationDegrees = CLLocationDegrees(Double(longitude)!)
        let coordinate = CLLocationCoordinate2DMake(lat, lng)
        return coordinate
    }
}
