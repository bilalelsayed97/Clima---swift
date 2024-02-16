import UIKit

class WeatherViewController: UIViewController, UITextFieldDelegate, WeatherMangerDelegate {
    @IBOutlet var conditionImageView: UIImageView!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var searchField: UITextField!

    var weatherManger = WeatherManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        weatherManger.delegate = self
        searchField.delegate = self
    }

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

    func didUpdateWeather(_ weatherManger: WeatherManager,weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
        }
        print(weather.temperature)
    }

    func didFailWithError(error: Error) {
        print(" this a error testtttt \(error)")
    }
}
