import Foundation

protocol Dummyjson {
    func dummyjson(completion: @escaping (Result<[DummyjsonResult], ErrorAPI>) -> Void)
}

final class DummyjsonAPI: Dummyjson {
    
    func dummyjson(completion: @escaping (Result<[DummyjsonResult], ErrorAPI>) -> Void) {
        let url = URL(string: "https://dummyjson.com/todos")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Создание задачи URLSession для выполнения запроса
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
                CoreDataService.shared.saveData(with: results.todos)
                completion(.success(results.todos))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }
        
        task.resume()
    }
}
