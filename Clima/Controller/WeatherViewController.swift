import CoreLocation
import UIKit

class WeatherViewController: UIViewController {
    @IBOutlet var conditionImageView: UIImageView!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var searchField: UITextField!

    var weatherManger = WeatherManager()
    var locationManger = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManger.delegate = self
        locationManger.requestWhenInUseAuthorization()
        locationManger.requestLocation()
        weatherManger.delegate = self
        searchField.delegate = self
    }

    @IBAction func locationButtonPressed(_: UIButton) {
        locationManger.requestLocation()
    }
}

// MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    @IBAction func searchButtonPressed(_: UIButton) {
        searchField.endEditing(true)
        print(searchField.text!)
    }

    func textFieldShouldReturn(_: UITextField) -> Bool {
        searchField.endEditing(true)
        print(searchField.text!)
        return true
    }

    func textFieldDidEndEditing(_: UITextField) {
        if let city = searchField.text {
            weatherManger.fetchWeather(cityName: city)
        }

        //        textField.text = ""
    }
}

// MARK: - WeatherMangerDelegate

extension WeatherViewController: WeatherMangerDelegate {
    func didUpdateWeather(_: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
        }
        print(weather.temperature)
    }

    func didFailWithError(error _: Error) {}
}

// MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Got Location Data!")
        if let location = locations.last {
            locationManger.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let long = location.coordinate.longitude
            weatherManger.fetchWeather(lat: lat, long: long)
        }
    }

    func locationManager(_: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
