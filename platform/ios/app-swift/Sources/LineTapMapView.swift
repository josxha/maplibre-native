import MapLibre
import SwiftUI
import UIKit

// #-example-code(LineTapMapView)
struct LineTapMapView: UIViewRepresentable {
    func makeUIView(context: Context) -> MLNMapView {
        let mapView = MLNMapView()

        // Add a single tap gesture recognizer
        let singleTap = UITapGestureRecognizer(
            target: context.coordinator,
            action: #selector(Coordinator.handleMapTap(sender:))
        )
        for recognizer in mapView.gestureRecognizers! where recognizer is UITapGestureRecognizer {
            singleTap.require(toFail: recognizer)
        }
        mapView.addGestureRecognizer(singleTap)
        return mapView
    }

    func updateUIView(_: MLNMapView, context _: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject {
        var parent: LineTapMapView

        init(_ parent: LineTapMapView) {
            self.parent = parent
        }

        @objc func handleMapTap(sender: UITapGestureRecognizer) {
            guard let mapView = sender.view as? MLNMapView else { return }

            // Convert tap location (CGPoint) to geographic coordinate (CLLocationCoordinate2D).
            let tapPoint: CGPoint = sender.location(in: mapView)
            let tapCoordinate: CLLocationCoordinate2D = mapView.convert(tapPoint, toCoordinateFrom: nil)
            print("You tapped at: \(tapCoordinate.latitude), \(tapCoordinate.longitude)")

            // Create an array of coordinates for our polyline, starting at the center of the map and ending at the tap coordinate.
            var coordinates: [CLLocationCoordinate2D] = [mapView.centerCoordinate, tapCoordinate]

            // Remove any existing polyline(s) from the map.
            if let existingAnnotations = mapView.annotations {
                mapView.removeAnnotations(existingAnnotations)
            }

            // Add a polyline with the new coordinates.
            let polyline = MLNPolyline(coordinates: &coordinates, count: UInt(coordinates.count))
            mapView.addAnnotation(polyline)
        }
    }
}

// #-end-example-code
