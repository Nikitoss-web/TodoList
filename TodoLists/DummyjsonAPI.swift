import Foundation

protocol Dummyjson {
    func dummyjson(completion: @escaping (Result<[DummyjsonResult], ErrorAPI>) -> Void)
}

final class DummyjsonAPI: Dummyjson {
    
    internal func dummyjson(completion: @escaping (Result<[DummyjsonResult], ErrorAPI>) -> Void) {
        let url = URL(string: "https://dummyjson.com/todos")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(.decodingError(error)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let results = try JSONDecoder().decode(DummyjsonResponse.self, from: data)
                CoreDataService.shared.saveData(with: results.todos, time: self.timeLoadingData())
                completion(.success(results.todos))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }
        
        task.resume()
    }
    private func timeLoadingData() -> String{
        let date = Date()
        let calendar = Calendar.current

        let oneHourLater = calendar.date(byAdding: .hour, value: 1, to: date)!

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = " h:mm a"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        let currentTime = dateFormatter.string(from: date)
        let oneHourLaterTime = dateFormatter.string(from: oneHourLater)

        let timeLoading = "Today \(currentTime) - \(oneHourLaterTime)"
        return timeLoading
    }
}
